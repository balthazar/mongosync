FROM ubuntu:24.04

WORKDIR /tmp

ARG PKG=mongosync-ubuntu2004-x86_64-1.7.2

RUN apt update && apt install -y wget rsyslog-gssapi
RUN wget https://fastdl.mongodb.org/tools/mongosync/$PKG.tgz
RUN tar -xzf $PKG.tgz
RUN cp $PKG/bin/mongosync /usr/local/bin
RUN mongosync -v

ENTRYPOINT ["mongosync"]
