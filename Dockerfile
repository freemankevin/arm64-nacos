FROM freemankevin/arm64v8-centos7-java8:v1 

MAINTAINER freemankevin <https://github.com/freemankevin>

# set environment
ENV MODE="cluster" \
    PREFER_HOST_MODE="ip"\
    BASE_DIR="/home/nacos" \
    CLASSPATH=".:/home/nacos/conf:$CLASSPATH" \
    CLUSTER_CONF="/home/nacos/conf/cluster.conf" \
    FUNCTION_MODE="all" \
    JAVA_HOME="/usr/share/jdk1.8.0_311" \
    NACOS_USER="nacos" \
    JAVA="/usr/share/jdk1.8.0_311/bin/java" \
    JVM_XMS="2g" \
    JVM_XMX="2g" \
    JVM_XMN="1g" \
    JVM_MS="128m" \
    JVM_MMS="320m" \
    NACOS_DEBUG="n" \
    TOMCAT_ACCESSLOG_ENABLED="false" \
    TIME_ZONE="Asia/Shanghai"

ARG NACOS_VERSION=1.2.1

WORKDIR /$BASE_DIR

ADD ./nacos-server-${NACOS_VERSION}.tar.gz $BASE_DIR

RUN set -x \
    && rm -rf $BASE_DIR/bin/* $BASE_DIR/conf/*.properties $BASE_DIR/conf/*.example $BASE_DIR/conf/nacos-mysql.sql \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo '$TIME_ZONE' > /etc/timezone

ADD bin/docker-startup.sh bin/docker-startup.sh
ADD conf/application.properties conf/application.properties
ADD init.d/custom.properties init.d/custom.properties


# set startup log dir
RUN mkdir -p logs \
	&& cd logs \
	&& touch start.out \
	&& ln -sf /dev/stdout start.out \
	&& ln -sf /dev/stderr start.out
RUN chmod +x bin/docker-startup.sh

EXPOSE 8848
ENTRYPOINT ["bin/docker-startup.sh"]
