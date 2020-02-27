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
IMAGE_VERSION="flytesnack_2020-02-27_22-10-00"
IMAGE_FULL_NAME="${REPO}${IMAGE_NAME}:${IMAGE_VERSION}"

# RELEASE_SEMVER=$(git describe --tags --exact-match "$GIT_SHA" 2>/dev/null) || true
# if [ -n "$RELEASE_SEMVER" ]; then
#   IMAGE_TAG_WITH_SEMVER="${IMAGE_NAME}:${RELEASE_SEMVER}${IMAGE_TAG_SUFFIX}"
# fi

# build the image
docker build -t "${IMAGE_FULL_NAME}" --build-arg IMAGE_TAG="${IMAGE_NAME}:${IMAGE_VERSION}" .
echo "${IMAGE_FULL_NAME} built locally."

# login docker hub
# docker login docker.hobot.cc

# push to docker hub
docker image push "${IMAGE_FULL_NAME}"

# register this workflow to flyte
FLYTE_PLATFORM_URL="10.10.13.126:30081"
FLYTE_PROJECT="flyteexamples"
FLYTE_DOMAIN="development"
docker run --network host -e FLYTE_PLATFORM_URL="${FLYTE_PLATFORM_URL}" "${IMAGE_FULL_NAME}" pyflyte -p "${FLYTE_PROJECT}" -d "${FLYTE_DOMAIN}" -c sandbox.config register workflows
