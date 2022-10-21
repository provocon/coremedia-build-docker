#
# Copyright 2017-2022 Martin Goellnitz, Markus Schwarz.
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
# https://github.com/docker-library/docker/blob/master/20.10/Dockerfile
FROM docker:20.10

# Maven
# Helm to support using charts from within your build:
# SenchaCmd:
ARG MAVEN_VERSION=3.8.6
ARG MAVEN_SHA=f790857f3b1f90ae8d16281f902c689e4f136ebe584aba45e4b1fa66c80cba826d3e0e52fdd04ed44b4c66f6d3fe3584a057c26dfcac544a60b301e6d0f91c26
ARG USER_HOME_DIR="/root"
ARG MAVEN_BASE_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries
ARG HELM_VERSION=3.7.2
ARG SENCHA_VERSION=7.6.0.87
ARG PNPM_VERSION=7.13.4
ARG MAINTAINER='PROVOCON https://github.com/provocon/'

LABEL maintainer="${MAINTAINER}"
LABEL PNPM_VERSION="${PNPM_VERSION}"

ENV MAVEN_HOME /usr/share/maven \
    MAVEN_CONFIG "$USER_HOME_DIR/.m2" \
    JAVA_HOME=/usr/lib/jvm/default-jvm \
    PNPM_HOME=/usr/local/bin \
    PATH="$JAVA_HOME/bin:$PATH:/usr/local/sencha" \
    LANG='de_DE.UTF-8' LANGUAGE='de_DE:en' LC_ALL='de_DE.UTF-8' \
    DISPLAY :20.0 \
    SCREEN_GEOMETRY "1440x900x24"

# The tools cosign, xz, zip, openssh etc are helpers for common CI usages
RUN apk add -q curl ca-certificates xz zip p7zip parallel sudo git bash openssh-client font-noto gnupg cosign && \
    ARCH=$(uname -m|sed -e 's/x86_64/amd64/g'|sed -e 's/aarch64/arm64/g') && \
    echo "Detecting architecture label $ARCH" && \
    curl -fsSL -o /etc/apk/keys/amazoncorretto.rsa.pub  https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    echo "https://apk.corretto.aws/" >> /etc/apk/repositories && \
    apk update && \
    apk add -q amazon-corretto-11 nodejs npm && \
    mkdir -p /usr/share/maven /usr/share/maven/ref  && \
    curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - && \
    tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    curl -o /usr/local/sencha.zip http://cdn.sencha.com/cmd/${SENCHA_VERSION}/no-jre/SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh.zip 2> /dev/null && \
    cd /usr/local && \
    unzip /usr/local/sencha.zip && \
    /usr/local/SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh -q -d --illegal-access=warn -dir /usr/local/sencha/${SENCHA_VERSION} && \
    mkdir /usr/local/sencha/repo && \
    chmod 777 /usr/local/sencha/repo && \
    ln -s /usr/local/sencha/sencha-${SENCHA_VERSION} /usr/local/bin/sencha && \
    rm -f sencha.zip SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh && \
    rm /usr/local/sencha/${SENCHA_VERSION}/bin/linux-x64/node/node && \
    ln -s /usr/bin/node /usr/local/sencha/${SENCHA_VERSION}/bin/linux-x64/node/node && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    fc-cache -fv && \
    npm install -g pnpm@${PNPM_VERSION} && \
    export PNPM_HOME=/usr/local/bin && \
    pnpm install -g pnpm@${PNPM_VERSION} && \
    curl -Lo helm.tar.gz "https://get.helm.sh/helm-v$HELM_VERSION-linux-${ARCH}.tar.gz" 2> /dev/null && \
    tar xzf helm.tar.gz && \
    mv linux-${ARCH}/helm /usr/local/bin && \
    rm -rf helm.tar.gz linux-amd /tmp/apache-maven.tar.gz /tmp/*.apk /tmp/gcc \
           /tmp/gcc-libs.tar.xz /tmp/libz /tmp/libz.tar.xz /var/cache/apk/*

EXPOSE 4444

CMD ["bash"]
