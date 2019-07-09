# The microservices stack deployed with the Helm in a prod-alike Kubernetes cluster.
The k8s cluster is deployed on AWS and consists of two EC2 instances: one master and one worker node. Additionally there are two Load Balancers: one for kube-api access and another serving as an Ingess controller gateway. 
Only the `calc` microservice is exposed to the outer world. (The Ingress resource and nginx-based Ingress controler are in charge of that).

## The project structure
- `/k8s` directory contains scripts for deploy and stop Kubernetes cluster, deploy Helm and Ingress-controller. 
(The latter is supposed to be a kops addon and deployed in declarative way as a part of template. However at the moment the out-of-the-box version lacks RBAC support). 
- `/src` directory contains the app code of microservices.
- `/charts` directory contains the Helm chart files.

## To make services work you may need:
- Deploy the Kubernetes cluster:
 ```
 cd k8s/
 ./run_cluster.sh
 ```
- Install ingress-cotroller
 ```
 ./install_ingress_nginx.sh
 ``` 
- Install Helm and Tiller:
 ```
 ./init_Helm.sh
 ```
- Deploy the Helm chart:
 ```
  cd ..
  cd charts/
  helm install acceleration
  ```
  
## Testing  
  The cluster is deployed in "gossip" configuration on AWS so only Amazon-provided DNS names of Load Balancers are accessible publicly.
  To get the entry point of "calc" service you may run:
  ```
  kubectl get ing
  ```
  The output would be something like:
  ```
  NAME                       HOSTS   ADDRESS                                                                  PORTS   AGE
  calc-ingress-<helm-release-name>   *.com   <elb-address-hash>.eu-west-1.elb.amazonaws.com   80      9m2s
  ```
  That is the publicly visible ELB entry point which maps to the `calc` service via the Ingress resource.
  Now you are able to test the service:
  ```
  curl "<elb-address-hash>.eu-west-1.elb.amazonaws.com/calc?vf=200&vi=5&t=123"
  ```
  If everything is good you'll get an answer:
  ```
  {"a":1.5853658536585367}
  ```
## Cleanup
After the testing in order to clean up resources you need to run:
```
 ./k8s/delete_cluster.sh
 ```
 To cleanup only Helm-created resources:
 ```
 helm ls --all --short | xargs -L1 helm delete --purge
 ```
## Notes
There are a few simplifications compared to real world production clusters:
- The cluster is not featuring HA configuration. 
  It is a good practice to have a control plane of more than one (odd number, often 3 to 5) instances, preferably multy-AZ.
- Microservices communicate in a synchronous way.  
  The sevices may fail and the network may behave in unpredictable way (latency, congestion etc) so async communication with the help of some intermediary message broker is often preffered.
- The `dev` and `prod` envs differ significantly. Dev is to be run on same host and addressed by `ip:port` tuple. Prod is run in k8s cluster and addressed by DNS names.
  It is considered to be a good practice to have various kinds of environments similar is possible.
- The project lacks CI/CD functionality. The Docker images are prebuild and stored in the private repo. They are provided `as-is` and not considered to be maintained.