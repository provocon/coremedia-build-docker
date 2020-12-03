# CoreMedia Build Container

This repository contains the necessary parts to create a Docker container with
the few required tools to build [CoreMedia][coremedia] Plattform 17nm, 18nm, 
19nm, and 20nm as used in CoreMedia Content Cloud 10, CMS-9, and CoreMedia Live
Context 3 workspaces.

The home of this repository is at [github][github] with an automated mirror at
[gitlab][gitlab].

## Feedback

Please use the [issues][issues] section of this repository at [github][github] 
for feedback. 

## Goals

This container is intended for use in container based CI system like the
[GitLab][gitlabci] CI. An example starting point is included with this 
repository.

See example directory with a usage example and mind the essential parameters
when building CoreMedia Content Cloud with [Maven][maven]:

```
mvn install -Dwebdriver.chrome.driver=/usr/bin/chromedriver -Dwebdriver.chrome.verboseLogging=true -DjooUnitWebDriverBrowserArguments=--no-sandbox,--disable-dev-shm-usage
```

## Availability

This container can be used via the canonical name `provocon/coremedia-build`.
The tag `latest` should be expected to usable for the latest release by
[CoreMedia][coremedia].

Tags are named after the first release for which the implemented changed are
required. Thus, `1801` can be used for releases e.g. cms-9-1801 and onwards. 
`1904` is the last release intended for CMS-9 and LiveContext 3, while `1907`
is the first release for CMCC-10. It can be used at least up to CMCC-10-2004.

## Build

### Manual Build

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
docker build -t provocon/coremedia-build:2007.1 .
docker build -t provocon/coremedia-build:2007 .
docker build -t provocon/coremedia-build:latest .
```

```
docker push provocon/coremedia-build:2007.1
docker push provocon/coremedia-build:2007
docker push provocon/coremedia-build:latest
```

### Scripted Build

Alternatively you could use the [Gradle Build Tool][gradle] and issue

```
gradle -PbuildTag=2007.1  dockerPush
gradle -PbuildTag=2007    dockerPush
gradle -PbuildTag=latest dockerPush
```

which does all the steps above for you except building the base-container.


## Test

Test the generated resulting container with

```
$ docker run --name docker --rm -it --entrypoint=docker provocon/coremedia-build version
Client: Docker Engine - Community
 Version:           19.03.4
 API version:       1.40
 Go version:        go1.12.10
 Git commit:        9013bf583a
 Built:             Fri Oct 18 15:49:05 2019
 OS/Arch:           linux/amd64
 Experimental:      false
```

```
$ docker run --name mvn --rm -it --entrypoint=mvn provocon/coremedia-build -v
Apache Maven 3.6.1 (d66c9c0b3152b2e69ee9bac180bb8fcc8e6af555; 2019-04-04T19:00:29Z)
Maven home: /usr/share/maven
Java version: 11, vendor: Oracle Corporation, runtime: /opt/java/openjdk
Default locale: de_DE, platform encoding: UTF-8
OS name: "linux", version: "4.4.0-166-generic", arch: "amd64", family: "unix"
```

```
$ docker run --name sencha --rm -it --entrypoint=sencha provocon/coremedia-build which
Sencha Cmd v6.7.0.63
/usr/local/sencha/6.7.0.63/
```

To call the container image use

```
docker run -it provocon/coremedia-build
```

[sencha]: https://www.sencha.com/products/extjs/cmd-download/
[coremedia]: http://www.coremedia.com/
[gitlabci]: https://gitlab.com/
[issues]: https://github.com/provocon/coremedia-build-docker/issues
[github]: https://github.com/provocon/coremedia-build-docker
[gitlab]: https://gitlab.com/provocon/coremedia-build-docker
[alpine]: https://www.alpinelinux.org/
[maven]: https://maven.apache.org/
[gradle]: https://gradle.org/
