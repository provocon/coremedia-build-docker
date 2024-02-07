# CoreMedia Build Image

This repository provides an image with the required tools to build
[CoreMedia][coremedia] Content Cloud 12, 11, 10, CoreMedia CMS-9, and CoreMedia
Live Context 3 workspaces for use with [podman][podman], Docker, and
similar systems. Supported platform versions range from 17nm to 23nm.

Images started to be available for AMD64/x86_64 and ARM64/Aarch64 with CMCC-11.

Ready to use examples for some CI environments are also included. They are
meant for unchanged integration with platform workspaces in their state without
any customizations. Thus they should form a good starting point for real world
projects.

The home for the sources to create the image lives at [Codeberg][codeberg] with
mirrors at [GitHub][github] and [GitLab][gitlab].


## Feedback

Please use the [issues][issues] section of this repository at [GitHub][github]
for feedback.


## Goals

This image is intended for use in container based CI systems like
[Forgejo Actions][forgejo], [GitLab CI][gitlabci], or [GitHub Actions][actions].
Example starting points are included with this repository, which work within
the bounds of the public shared runner limitations.

Also, some common tools for additional preparation steps are included like

* `git`
* `gnupg`
* `cosign`
* `openssh`

and some compression tools.

We like to support different hardware architectures where appropriate.


## Availability

This image can be used via the canonical name `provocon/coremedia-build`.
The tag `latest` should be expected to be usable for the latest release by
[CoreMedia][coremedia].

Tags are named after the first release where the implemented changes are
required. Thus, `1801` can be used for releases e.g. cms-9-1801 and onwards.
`1904` is the last release intended for CMS-9 and LiveContext 3. `1907`
was the first release for CMCC-10, which can be used at least up to
CMCC-10-2004 and so on.

* `2110` is the current release to work with CMCC-10.
* `2307` is the current release to work with CMCC-11.
* `2401` is the current release to work with CMCC-12.

The latest Tag works with - at least again - CMCC-12-2401.

Unpublished, daily builds are available from the [Codeberg][codeberg],
[GitHub][github] and [GitLab][gitlab] project registries.


## Usage

See the `examples/` directory with usage examples and don't forget the
[Maven][maven] and [NPM][npm] registry setup.

Examples for builds with [Forgejo Actions][forgejo], [GitLab CI][gitlabci] and
[GitHub Actions][actions] will need the additional files in
`examples/workspace-configuration` and a personal `npmrc` needs to be created
through `npm-registry-login.sh`.

Perhaps you still need to mind some parameters when building CoreMedia Content
Cloud, e.g.

```
mvn install -Dwebdriver.chrome.driver=/usr/bin/chromedriver -Dwebdriver.chrome.verboseLogging=true -DjooUnitWebDriverBrowserArguments=--no-sandbox,--disable-dev-shm-usage
```

So, with [Forgejo Actions][forgejo], [GitLab CI][gitlabci], or
[GitHub Actions][actions] the steps are

### Adding files

* `workspace-configuration/maven-settings.xml`
* `workspace-configuration/npm-registry-login.sh`

[Forgejo Actions][forgejo]:

* `.forgejo/workflows/build.yml`

[GitHub Actions][actions]:

* `.github/workflows/build.yml`

[GitLab CI][gitlabci]:

* `.github/workflows/build.yml`


### Adding secrets

These values have to be added as CI variables for [GitLab CI][gitlabci] and
as action secrets for [Forgejo Actions][forgejo] and [GitHub Actions][actions]
respectively.

CoreMedia Maven Artifacts Repository User and Password:

* `CM_MAVEN_USER`
* `CM_MAVEN_PASSWORD`

CoreMedia NPM Registry Token for [GitLab CI][gitlabci] :

* `NPMRC_TOKEN`

Full NPM RC-File for [Forgejo Actions][forgejo] and [GitHub Actions][actions]

* `NPMRC`

The NPMRC raw data can be obtained by using the login script provided in the
`workspace-configuration` folder as indicated above. You will need to update
this value every few months.

Optionally add Maven Options

* `MAVEN_OPTS`

and use Docker Hub login to extend the download rate.

* `DH_REGISTRY_USER`
* `DH_REGISTRY_PASSWORD`


## Build

### Manual Build

The preparation of the container is accomplished using the usual

```
docker build -t <myname> .
```

So, for the current version, this is

```
docker build -t provocon/coremedia-build:2401.1 .
docker build -t provocon/coremedia-build:2401 .
docker build -t provocon/coremedia-build:latest .
```

```
docker push provocon/coremedia-build:2401.1
docker push provocon/coremedia-build:2401
docker push provocon/coremedia-build:latest
```

You could as well use [podman][podman] instead of docker in each of the lines.


### Scripted Build

Alternatively, you could use the [Gradle Build Tool][gradle] and issue

```
./gradlew -Ptag=2401.1 dockerPush
./gradlew -Ptag=2401   dockerPush
./gradlew -Ptag=latest dockerPush
```

which does all the steps above for you.


## Test

Test the generated resulting container with

```
$ docker run --name docker --rm -it --entrypoint=docker provocon/coremedia-build version
Client:
 Version:           25.0.3
 API version:       1.44
 Go version:        go1.21.6
 Git commit:        4debf41
 Built:             Tue Feb  6 21:13:00 2024
 OS/Arch:           linux/amd64
 Context:           default
```

```
$ docker run --name buildx --rm -it --entrypoint=docker provocon/coremedia-build buildx version
github.com/docker/buildx v0.12.1 30feaa1a915b869ebc2eea6328624b49facd4bfb
```

```
$ docker run --name mvn --rm -it --entrypoint=mvn provocon/coremedia-build -v
Apache Maven 3.9.6 (bc0240f3c744dd6b6ec2920b3cd08dcc295161ae)
Maven home: /usr/local/maven
Java version: 17.0.10, vendor: Azul Systems, Inc., runtime: /usr/local/zulu17.48.15-ca-jdk17.0.10-linux_musl_x64
Default locale: de_DE, platform encoding: UTF-8
OS name: "linux", version: "5.10.0-25-amd64", arch: "amd64", family: "unix"
```

```
$ docker run --name sencha --rm -it --entrypoint=sencha provocon/coremedia-build which
Sencha Cmd v7.6.0.87
/usr/local/sencha/7.6.0.87/
```

```
$ docker run --name node --rm -it --entrypoint=node provocon/coremedia-build -v
v20.11.0
```

$ docker run --name helm --rm -it --entrypoint=helm provocon/coremedia-build version
version.BuildInfo{Version:"v3.14.0", GitCommit:"3fc9f4b2638e76f26739cd77c7017139be81d0ea", GitTreeState:"clean", GoVersion:"go1.21.5"}
```

To call the container image use

```
docker run -it --rm provocon/coremedia-build /bin/bash
```

[sencha]: https://www.sencha.com/products/extjs/cmd-download/
[coremedia]: http://www.coremedia.com/
[maven]: https://maven.apache.org/
[gradle]: https://gradle.org/
[npm]: https://www.npmjs.com/
[gitlabci]: https://docs.gitlab.com/ee/ci/
[actions]: https://github.com/features/actions
[forgejo]: https://forgejo.org/docs/latest/user/actions/
[podman]: https://podman.io/
[dockerhub]: https://hub.docker.com/
[issues]: https://github.com/provocon/coremedia-build-docker/issues
[github]: https://github.com/provocon/coremedia-build-docker
[codeberg]: https://codeberg.org/provocon/coremedia-build-image
[gitlab]: https://gitlab.com/provocon/coremedia-build-docker
