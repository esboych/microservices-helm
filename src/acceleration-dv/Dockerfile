FROM node:10.14.2-alpine

# installing some debug tools
RUN apk add --no-cache bash curl net-tools
RUN npm config set unsafe-perm true
RUN npm install -g yarn

#WORKDIR /

COPY src/acceleration-dv/ .

RUN yarn install
RUN yarn build

ENTRYPOINT [ "yarn", "start" ]
