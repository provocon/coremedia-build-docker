# CoreMedia Build Container

This repository contains the necessary parts to create a Docker container with
the few required tools to build [CoreMedia][coremedia] Plattforms starting from
17nm throughout 22nm as used in CoreMedia Content Cloud 11, CoreMedia Content
Cloud 10, CMS-9, and CoreMedia Live Context 3 workspaces.

The home of this repository is at [github][github] with a mirror at
[gitlab][gitlab].

## Feedback

Please use the [issues][issues] section of this repository at [github][github] 
for feedback. 

## Goals

This container is intended for use in container based CI system like the
[GitLab][gitlabci] CI. Example starting points are included with this
repository.

See the `examples/` directory with usage examples and don't forget the
[Maven][maven] and [NPM][npm] registry setup.

Examples for builds with [GitLab][gitlabci] CI and [github][github] Actions
will need the additional files in `examples/workspace-configuration` and
a personal `npmrc` needs to be created through `npm-registry-login.sh`.

Also some common tools for additional preparation steps are included like

* `git`
* `gnupg`
* `cosign`
* `openssh`

and some compression tools.

Perhaps you still need to mind some parameters when building CoreMedia Content
Cloud, e.g.

```
mvn install -Dwebdriver.chrome.driver=/usr/bin/chromedriver -Dwebdriver.chrome.verboseLogging=true -DjooUnitWebDriverBrowserArguments=--no-sandbox,--disable-dev-shm-usage
```

## Availability

This container can be used via the canonical name `provocon/coremedia-build`.
The tag `latest` should be expected to usable for the latest release by
[CoreMedia][coremedia].

Tags are named after the first release for which the implemented changes are
required. Thus, `1801` can be used for releases e.g. cms-9-1801 and onwards. 
`1904` is the last release intended for CMS-9 and LiveContext 3, while `1907`
is the first release for CMCC-10, which can be used at least up to CMCC-10-2004.
The latest Tag works with - at least again - CMCC-11-2207.

## Build

### Manual Build

The preparation of the container is accomplished using the usual

```
docker build -t <myname> .
```

So, for the current version this is

```
docker build -t provocon/coremedia-build:2110.4 .
docker build -t provocon/coremedia-build:2110 .
docker build -t provocon/coremedia-build:latest .
```

```
docker push provocon/coremedia-build:2110.4
docker push provocon/coremedia-build:2110
docker push provocon/coremedia-build:latest
```

### Scripted Build

Alternatively you could use the [Gradle Build Tool][gradle] and issue

```
./gradlew -PbuildTag=2110.4 dockerPush
./gradlew -PbuildTag=2110   dockerPush
./gradlew -PbuildTag=latest dockerPush
```

which does all the steps above for you.


## Test

Test the generated resulting container with

```
$ docker run --name docker --rm -it --entrypoint=docker provocon/coremedia-build version
Client:
 Version:           20.10.17
 API version:       1.41
 Go version:        go1.17.11
 Git commit:        100c701
 Built:             Mon Jun  6 22:56:42 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true
```

```
$ docker run --name mvn --rm -it --entrypoint=mvn provocon/coremedia-build -v
Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
Maven home: /usr/share/maven
Java version: 11.0.16.1, vendor: Amazon.com Inc., runtime: /usr/lib/jvm/java-11-amazon-corretto
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "5.10.0-9-amd64", arch: "amd64", family: "unix"
```

```
$ docker run --name sencha --rm -it --entrypoint=sencha provocon/coremedia-build which
Sencha Cmd v7.2.0.84
/usr/local/sencha/7.2.0.84/
```

To call the container image use

```
docker run -it provocon/coremedia-build /bin/bash
```

[sencha]: https://www.sencha.com/products/extjs/cmd-download/
[coremedia]: http://www.coremedia.com/
[gitlabci]: https://gitlab.com/
[issues]: https://github.com/provocon/coremedia-build-docker/issues
[github]: https://github.com/provocon/coremedia-build-docker
[gitlab]: https://gitlab.com/provocon/coremedia-build-docker
[maven]: https://maven.apache.org/
[gradle]: https://gradle.org/
[npm]: https://www.npmjs.com/
