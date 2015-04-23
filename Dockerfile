FROM ubuntu:14.04

MAINTAINER Branden Rolston <branden@disqus.com>

ENV BUILD_DEPS git maven
ENV RUNTIME_DEPS oracle-java7-installer

RUN apt-get install -y software-properties-common --no-install-recommends && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update  && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y $BUILD_DEPS $RUNTIME_DEPS --no-install-recommends && \
    git clone https://github.com/pinterest/secor.git && \
    cd secor && mvn clean package && cd .. && \
    mkdir /opt/secor && \
    tar zxvf secor/target/secor-0.1-SNAPSHOT-bin.tar.gz -C /opt/secor && \
    apt-get purge -y --auto-remove $BUILD_DEPS software-properties-common && \
    rm -rf secor ~/.m2

ADD run.sh /opt/secor/run.sh

WORKDIR /opt/secor

ENTRYPOINT ["/opt/secor/run.sh"]

