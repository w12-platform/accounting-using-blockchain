FROM node:latest
MAINTAINER gauss

COPY ./server/server.js /root/server/server.js
COPY ./lib/*.* /root/lib/
COPY ./src/js/*.js /root/src/js/
COPY ./src/css/styles.css /root/src/css/styles.css
COPY ./src/img/flag.png /root/src/img/flag.png
COPY ./src/icon.png /root/src/icon.png
COPY ./src/index.html /root/src/index.html
COPY ./keys.js /root/keys.js
COPY ./package.json /root/package.json
RUN cd ./root && npm install --production

EXPOSE 8080

WORKDIR /root/server

CMD ["nodejs", "./server.js"]