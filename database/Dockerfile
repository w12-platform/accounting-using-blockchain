FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD 123
ENV MYSQL_DATABASE accounting
ENV MYSQL_PASSWORD 123

ADD ./database/setup.sql /docker-entrypoint-initdb.d