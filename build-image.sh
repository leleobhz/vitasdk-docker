#!/bin/bash

docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v  "$(pwd)":"$(pwd)" -w "$(pwd)" -v "$HOME/.dive.yaml":"$HOME/.dive.yaml" -v "$HOME/.docker":"$HOME/.docker" -v "/var/lib/docker/:/var/lib/docker/" -e TERM=xterm-256colors -e DOCKER_BUILDKIT=1 wagoodman/dive:latest build -t vitasdk-docker:latest .
