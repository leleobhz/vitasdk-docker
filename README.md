Vita SDK in a Docker Image
==========================

This is based on [pspdev-docker](https://github.com/pspdev/pspdev-docker) and [vitasdk-docker](https://github.com/gnuton/vitasdk-docker).

Build status badge:
-------------------

[![Docker](https://github.com/leleobhz/vitasdk-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/leleobhz/vitasdk-docker/actions/workflows/docker-publish.yml)

Using it
--------

You can manually use the image `ghcr.io/leleobhz/vitasdk-docker:latest` 
and set the root of you application as volume to `/build`. 

This project also contains a script called `vitasdk-docker`.
This script allows user to run it from any project you need 
and wrap build commands inside the container.

The directory where you run the script gets exposed to the
Docker image as `/build/`, and this is also the working
directory. This allows you to run e.g.:

    vitasdk-docker make

You can also just run a shell by running it without args:

    vitasdk-docker

Note that only the current folder is exported, so you can't
do a `cmake ..` in a build folder, for this, use the shell:

    vitasdk-docker
    mkdir build
    cd build
    cmake ..

Once this is set up, you can use the script from outside
(again, from the parent folder, so it can find source files):

    vitasdk-docker make -C build

Docker Compose
--------------

If you wan't to use docker compose, you can use a 
new file called `docker-compose.override.yaml` 
to add you build using base compose as skel.

Build the image
---------------

    docker build -t localhost/vitasdk-docker:latest .

(or just run `make`)
