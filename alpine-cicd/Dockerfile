FROM docker.io/library/alpine:latest

RUN apk add --no-cache \
    # common tools:
    curl \
    # docker builds:
    docker-cli docker-cli-buildx

LABEL sapphiccode.version.cmd "grep VERSION_ID /etc/os-release | cut -d = -f 2"
