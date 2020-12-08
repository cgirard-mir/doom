#!/usr/bin/env bash
echo "Searching for Docker image ..."
DOCKER_IMAGE_ID=$(docker images --format="{{.ID}}" client:latest | head -n 1)
echo "Found and using ${DOCKER_IMAGE_ID}"

USER_UID=$(id -u)

docker run -it -p 6081:6081 \
  --volume=/run/user/${USER_UID}/pulse:/run/user/1000/pulse \
  ${DOCKER_IMAGE_ID} \
  ${@}
