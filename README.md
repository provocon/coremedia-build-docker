# CoreMedia Build Container

This repository contains the necessary parts to create a Docker container with
the few tools necessary to build [CoreMedia][coremedia] Plattform 170x (CoreMedia 
CMS 9 and CoreMedia Live Context 3) workspaces.

Find mirrors of this git repository at [gitlab][gitlab] and [github][github].


## Preparation

The preparation of the container is accomplished using the usual

```
docker build -t <myname> .
```


## Goals

This container is intended for use in container based CI system like the
[GitLab][gitlabci] CI.


## Feedback

Please use the [issues][issues] section of this repository at [github][github] 
for feedback. 

[sencha]: https://www.sencha.com/products/extjs/cmd-download/
[coremedia]: http://www.coremedia.com/
[gitlabci]: https://gitlab.com/
[issues]: https://github.com/provocon/coremedia-build-docker/issues
[github]: https://github.com/provocon/coremedia-build-docker
[gitlab]: https://gitlab.com/provocon/coremedia-build-docker
