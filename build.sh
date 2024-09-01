#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -lt 4 ]; then
  echo "Usage: $0 <base_image> <package_manager> <additional_packages> <registry>"
  exit 1
fi

# Assign arguments to variables
BASE_IMAGE=$1
PACKAGE_MANAGER=$2
ADDITIONAL_PACKAGES=$3
REGISTRY=$4

# Validate the package manager
if [ "$PACKAGE_MANAGER" != "apt" ] && [ "$PACKAGE_MANAGER" != "apk" ]; then
  echo "Invalid package manager. Please specify 'apt' or 'apk'."
  exit 1
fi

# Build the Docker image with specified parameters
docker build \
  --build-arg BASE_IMAGE=$BASE_IMAGE \
  --build-arg PACKAGE_MANAGER=$PACKAGE_MANAGER \
  --build-arg ADDITIONAL_PACKAGES="$ADDITIONAL_PACKAGES" \
  -t my-app .

# Tag and push the Docker image to the specified registry
docker tag my-app $REGISTRY/my-app
docker push $REGISTRY/my-app

# Output the built image name and registry URL
echo "Built and pushed Docker image: $REGISTRY/my-app"
