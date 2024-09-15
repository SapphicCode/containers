FROM docker.io/library/fedora:latest

RUN dnf upgrade -y && \
    dnf clean all

RUN curl -sSf -L https://install.lix.systems/lix | sh -s -- install linux --init none --no-confirm

COPY version.sh /

LABEL sapphiccode.version.cmd="/version.sh"
