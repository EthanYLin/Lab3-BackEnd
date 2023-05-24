FROM ubuntu:20.04

# 安装JDK, MySQL
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt-get -qq install -y openjdk-17-jre-headless && \
    apt-get -qq install -y mysql-server mysql-client

# 将Spring Boot的jar包复制到容器中
COPY Lab3-Backend.jar /app/Lab3-Backend.jar
COPY lab3.sql /app/lab3.sql

# 创建名为web_lab3的数据库
RUN service mysql start && \
    mysql -u root -e "CREATE DATABASE web_lab3;" && \
    mysql -u root web_lab3 < /app/lab3.sql && \
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123';"

# 暴露端口
EXPOSE 8080

# 启动Mysql服务并运行应用程序
CMD service mysql start && java -jar /app/Lab3-Backend.jar