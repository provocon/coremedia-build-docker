# CoreMedia Build Container

This repository contains the necessary parts to create Docker container with
the few tools necessary to build [CoreMedia][coremedia] Plattform 17x (CoreMedia 
CMS 9 and CoreMedia Live Context 3) workspaces.


## Preparation

Since the [Sencha command line][sencha] tooling has a graphical installer, it 
cannot be integrated script based (?). So we decided to copy it from an existing
installation on your local path. (You'll have it installed on your local 
maschine anyway, if you're working with the latest CoreMedia)

This installation is not really copy-safe to simly use it in your container.
This is why you have to use the `prepare-sench.sh` script.

After this step there's nothing special lef, and you can issue the usual

```
docker build -t <myname> .
```


## Goals

This container is intended for use in container based CI system like the
[GitLab][gitlab] CI.


## Feedback

Please use the [issues][issues] section of this repository for feedback. 

[sencha]: https://www.sencha.com/products/extjs/cmd-download/
[coremedia]: http://www.coremedia.com/
[gitlab]: https://gitlab.com/
[issues]: https://github.com/mgoellnitz/coremedia-build-docker/issues
