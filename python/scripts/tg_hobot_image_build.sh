#!/usr/bin/env bash

set -e

echo ""
echo "------------------------------------"
echo "           DOCKER BUILD"
echo "------------------------------------"
echo ""

REPO="docker.hobot.cc/aitools/"
IMAGE_NAME="flyte_testruns"
IMAGE_VERSION="flytesnack_2020-02-26_18-30-00"

# build the image
docker build -t $REPO$IMAGE_NAME:$IMAGE_VERSION --build-arg IMAGE_TAG=$REPO$IMAGE_NAME:$IMAGE_VERSION .
echo "$REPO$IMAGE_NAME:$IMAGE_VERSION built locally."
