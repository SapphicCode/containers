FROM docker.io/pufferpanel/pufferpanel:latest

RUN useradd --system --no-create-home --user-group pufferpanel
USER pufferpanel
# bugfix for source image:
ENV PUFFER_TOKEN_PUBLIC=/etc/pufferpanel/public.pem PUFFER_TOKEN_PRIVATE=/etc/pufferpanel/private.pem

LABEL sapphiccode.version.cmd="sha256sum /pufferpanel/pufferpanel | awk '{ print $1 }' | head -c 8"
