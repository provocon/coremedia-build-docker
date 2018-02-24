# CoreMedia Build Container

This repository contains the necessary parts to create a Docker container with
the few required tools to build [CoreMedia][coremedia] Plattform 17nm or 18nm 
as used in CoreMedia CMS-9 and CoreMedia Live Context 3 workspaces.

Find mirrors of this git repository at [gitlab][gitlab] and [github][github].

## Preparation

The preparation of the container is accomplished using the usual

```
docker build -t <myname> .
```

```
docker build -t provocon/coremedia-build:1801.1 .
docker build -t provocon/coremedia-build:1801 .
docker build -t provocon/coremedia-build:latest .
docker push provocon/coremedia-build:1801.1
docker push provocon/coremedia-build:1801
docker push provocon/coremedia-build:latest
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
