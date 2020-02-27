#!/usr/bin/env bash

# WARNING: THIS FILE IS MANAGED IN THE 'BOILERPLATE' REPO AND COPIED TO OTHER REPOSITORIES.
# ONLY EDIT THIS FILE FROM WITHIN THE 'LYFT/BOILERPLATE' REPOSITORY:
# 
# TO OPT OUT OF UPDATES, SEE https://github.com/lyft/boilerplate/blob/master/Readme.rst

set -e

echo ""
echo "------------------------------------"
echo "           DOCKER BUILD"
echo "------------------------------------"
echo ""

if [ -n "$REGISTRY" ]; then
  # Do not push if there are unstaged git changes
  CHANGED=$(git status --porcelain)
  if [ -n "$CHANGED" ]; then
    echo "Please commit git changes before pushing to a registry"
    exit 1
  fi
fi


GIT_SHA=$(git rev-parse HEAD)

REPO="docker.hobot.cc/aitools/"
IMAGE_NAME="flyte_testruns"
IMAGE_VERSION="flytesnack_2020-02-27_16-00-00"
IMAGE_TAG_WITH_SHA="${REPO}${IMAGE_NAME}:${IMAGE_VERSION}"

# RELEASE_SEMVER=$(git describe --tags --exact-match "$GIT_SHA" 2>/dev/null) || true
# if [ -n "$RELEASE_SEMVER" ]; then
#   IMAGE_TAG_WITH_SEMVER="${IMAGE_NAME}:${RELEASE_SEMVER}${IMAGE_TAG_SUFFIX}"
# fi

# build the image
docker build -t "$IMAGE_TAG_WITH_SHA" --build-arg IMAGE_TAG="${IMAGE_NAME}:${IMAGE_VERSION}" .
echo "${IMAGE_TAG_WITH_SHA} built locally."
# tg: manually pushing image to docker.hobot.cc, so we stop here
exit 0

# if REGISTRY specified, push the images to the remote registy
if [ -n "$REGISTRY" ]; then

  if [ -n "${DOCKER_REGISTRY_PASSWORD}" ]; then
    # docker login --username="$DOCKER_REGISTRY_USERNAME" --password="$DOCKER_REGISTRY_PASSWORD"
    docker login docker.hobot.cc --username="$DOCKER_REGISTRY_USERNAME" --password="$DOCKER_REGISTRY_PASSWORD"
  fi

  docker tag "$IMAGE_TAG_WITH_SHA" "${REGISTRY}/${IMAGE_TAG_WITH_SHA}"

  docker push "${REGISTRY}/${IMAGE_TAG_WITH_SHA}"
  echo "${REGISTRY}/${IMAGE_TAG_WITH_SHA} pushed to remote."

  # If the current commit has a semver tag, also push the images with the semver tag
  if [ -n "$RELEASE_SEMVER" ]; then

    docker tag "$IMAGE_TAG_WITH_SHA" "${REGISTRY}/${IMAGE_TAG_WITH_SEMVER}"

    docker push "${REGISTRY}/${IMAGE_TAG_WITH_SEMVER}"
    echo "${REGISTRY}/${IMAGE_TAG_WITH_SEMVER} pushed to remote."

  fi
fi
