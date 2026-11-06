FROM docker.io/library/alpine:latest

RUN apk add --no-cache \
    # common tools:
    bash curl git git git-lfs gnupg grep jq openssh ripgrep sed yq-go \
    # docker builds:
    docker-cli docker-cli-buildx

LABEL sapphiccode.version.cmd="grep VERSION_ID /etc/os-release | cut -d = -f 2"
