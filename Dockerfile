#
# Copyright 2017-2025 Martin Goellnitz, Markus Schwarz.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# https://github.com/docker-library/docker/blob/30d7b9bf7663c96fcd888bd75e9aaa547a808a23/20.10/Dockerfile
FROM docker:29.1

ARG MAVEN_VERSION=3.9.12
ARG MAVEN_SHA=0a1be79f02466533fc1a80abbef8796e4f737c46c6574ede5658b110899942a94db634477dfd3745501c80aef9aac0d4f841d38574373f7e2d24cce89d694f70
ARG USER_HOME_DIR="/root"
ARG MAVEN_BASE=https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven
ARG HELM_BASE=https://get.helm.sh/helm
ARG HELM_VERSION=3.19.4
ARG HELM_SHAS="amd64:759c656fbd9c11e6a47784ecbeac6ad1eb16a9e76d202e51163ab78504848862\narm64:9e1064f5de43745bdedbff2722a1674d0397bc4b4d8d8196d52a2b730909fe62\nriscv64:9d90a7532b426e5d99edfa9fa93e1dba4729f96a3b493974e847651a9aa34020"
ARG PNPM_VERSION=10.26.1
ARG MAINTAINER='PROVOCON https://codeberg.org/provocon'

LABEL maintainer="$MAINTAINER"
LABEL Maven="$MAVEN_VERSION"
LABEL Helm="$HELM_VERSION"
LABEL PNPM="$PNPM_VERSION"

ENV DOCKER_TLS_CERTDIR=/certs \
    MAVEN_HOME=/usr/local/maven MAVEN_CONFIG="$USER_HOME_DIR/.m2" \
    JAVA_HOME=/usr/lib/jvm/default-jvm PNPM_HOME=/usr/local/bin \
    PATH="$PATH:$JAVA_HOME/bin" \
    LANG='de_DE.UTF-8' LANGUAGE='de_DE:en' LC_ALL='de_DE.UTF-8' \
    DISPLAY=":20.0" SCREEN_GEOMETRY="1440x900x24"

WORKDIR /usr/local

# The tools cosign, xz, zip, openssh etc are helpers for common CI usages
RUN apk update -q && \
    apk upgrade -q && \
    apk add -q curl ca-certificates xz zip font-noto gnupg bash nodejs npm git \
               libxtst libxi openssh-client libxext libxrender cosign parallel \
               sudo openjdk17-jdk && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    fc-cache -f && \
    PATH=/usr/bin:$PATH && \
    npm install -g pnpm@$PNPM_VERSION && \
    mkdir -p $MAVEN_HOME $MAVEN_HOME/ref  && \
    curl -Lo maven.tgz $MAVEN_BASE-$MAVEN_VERSION-bin.tar.gz 2> /dev/null && \
    echo "$MAVEN_SHA  maven.tgz" | sha512sum -c - && \
    tar xzf maven.tgz -C $MAVEN_HOME --strip-components=1 && \
    ln -s $MAVEN_HOME/bin/mvn /usr/local/bin/mvn && \
    ARCH=$(uname -m|sed -e 's/x86_64/amd64/g'|sed -e 's/aarch64/arm64/g') && \
    MACHINE=$(uname -m|sed -e 's/86_//g') && \
    echo "Detecting architecture $ARCH / $MACHINE" && \
    HELM_SHA=$(echo -e $HELM_SHAS|grep $ARCH|cut -d ':' -f 2) && \
    curl -Lo helm.tgz "$HELM_BASE-v$HELM_VERSION-linux-$ARCH.tar.gz" 2> /dev/null && \
    echo "$HELM_SHA  helm.tgz" | sha256sum -c - && \
    tar xzf helm.tgz && \
    mv linux-$ARCH/helm bin && \
    rm -rf linux-* *.tgz *.zip *.sh /root/.[cjn]* /var/cache/apk/*

CMD ["bash"]
