# CoreMedia Build Container

This repository contains the necessary parts to create a Docker container with
the few required tools to build [CoreMedia][coremedia] Plattform 17nm, 18nm, 
or 19nm as used in CoreMedia Content Cloud 10, CMS-9, and CoreMedia Live 
Context 3 workspaces.

Find mirrors of this git repository at [gitlab][gitlab] and [github][github].

## Build

To be able to support `docker in docker` creation of containers, we had to
prepare a new base-container with [Alpine Linux][alpine], JDK11, and
[Maven 3.6][maven]:

```
docker build -f Dockerfile.alpine-docker-jdk11-maven3.6 -t provocon/alpine-docker-jdk11-maven3.6:latest .
docker push provocon/alpine-docker-jdk11-maven3.6:latest
```

The further preparation of the container is accomplished using the usual

```
docker build -t <myname> .
```

So, for the current version this is

```
docker build -t provocon/coremedia-build:1907.1 .
docker build -t provocon/coremedia-build:1907 .
docker build -t provocon/coremedia-build:latest .
```

```
docker push provocon/coremedia-build:1907.1
docker push provocon/coremedia-build:1907
docker push provocon/coremedia-build:latest
```    
**Alternatively you could use the [Gradle Build Tool][gradle] and issue**
````shell script
gradle -PbuildTag=1907.1  dockerPush
gradle -PbuildTag=1907    dockerPush
gradle -PbuildTag=latest dockerPush
````             
which does all the steps above for you.
 

## Test

Test the generated interim container with

```
$ docker run --name mvn --rm -it --entrypoint=mvn provocon/alpine-jdk11-maven3.6 -v
Apache Maven 3.6.1 (d66c9c0b3152b2e69ee9bac180bb8fcc8e6af555; 2019-04-04T19:00:29Z)
Maven home: /usr/share/maven
Java version: 11, vendor: Oracle Corporation, runtime: /opt/java/openjdk
Default locale: de_DE, platform encoding: UTF-8
OS name: "linux", version: "4.4.0-166-generic", arch: "amd64", family: "unix"
```

Test the generated resulting container with

```
$ docker run --name mvn --rm -it --entrypoint=mvn provocon/coremedia-build -v
Apache Maven 3.6.1 (d66c9c0b3152b2e69ee9bac180bb8fcc8e6af555; 2019-04-04T19:00:29Z)
Maven home: /usr/share/maven
Java version: 11, vendor: Oracle Corporation, runtime: /opt/java/openjdk
Default locale: de_DE, platform encoding: UTF-8
OS name: "linux", version: "4.4.0-166-generic", arch: "amd64", family: "unix"
$ docker run --name mvn --rm -it --entrypoint=sencha provocon/coremedia-build which
Sencha Cmd v6.7.0.63
/usr/local/sencha/6.7.0.63/
```

To call the container image use

```
docker run -it provocon/coremedia-build bash
```

## Availability

This container can be used via the canonical name `provocon/coremedia-build`.

## Goals

This container is intended for use in container based CI system like the
[GitLab][gitlabci] CI. An example starting point is included with this 
repository.

## Feedback

Please use the [issues][issues] section of this repository at [github][github] 
for feedback. 

[sencha]: https://www.sencha.com/products/extjs/cmd-download/
[coremedia]: http://www.coremedia.com/
[gitlabci]: https://gitlab.com/
[issues]: https://github.com/provocon/coremedia-build-docker/issues
[github]: https://github.com/provocon/coremedia-build-docker
[gitlab]: https://gitlab.com/provocon/coremedia-build-docker
[alpine]: https://www.alpinelinux.org/
[maven]: https://maven.apache.org/
[gradle]: https://gradle.org/
