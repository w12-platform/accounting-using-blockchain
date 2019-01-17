FROM node:latest
MAINTAINER gauss


COPY ./service/service.js /root/service/service.js
COPY ./src/js/*.js /root/src/js/
COPY ./keys.js /root
COPY ./package.json /root/package.json
RUN cd ./root && npm install --production

WORKDIR /root/service

CMD ["nodejs", "./service.js"]
