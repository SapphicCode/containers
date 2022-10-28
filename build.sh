#!/usr/bin/env bash

set -eux

context="${1}"

if [ -e "${context}/build.sh" ]; then
    "${context}/build.sh"
else
    buildah build --manifest=build "${context}"
fi

if [ "${CI_COMMIT_BRANCH:-unset}" = "main" ]; then
	buildah push build docker://quay.io/sapphiccode/"${context}":latest
    buildah push build docker://quay.io/sapphiccode/"${context}":"$(date +'%Y%m%d')"
fi
