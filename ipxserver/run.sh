#!/usr/bin/env bash
echo "Searching for Docker image ..."
DOCKER_IMAGE_ID=$(docker images --format="{{.ID}}" ipxserver:latest | head -n 1)
echo "Found and using ${DOCKER_IMAGE_ID}"

USER_UID=$(id -u)

docker run -it -p 6080:6080 \
  -h ipxserver \
  ${DOCKER_IMAGE_ID} \
  ${@}
