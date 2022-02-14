#!/bin/sh
DOCKER_UTILS_TAG_EM=${DOCKER_UTILS_TAG_EM:-YES}
#DOCKER_UTILS_DEBUG=${DOCKER_UTILS_DEBUG:-YES}
# Copy New Info Script (as Dockerfile cannot reach into a parent directory)
cp "../info.sh" "info.sh"
# Load functions
. "../funcs.sh"

# Load variables
GET_ENV_VARS ".env"

# Docker Build Example
EX_DOCKER_BUILD(){
echo "Building via Docker $1 - $2"
BTP_IMAGE --image-name "$1" \
            --image-version "$2" \
            --build-arg "BASE_IMAGE_NAME=$BASE_IMAGE_NAME" \
            --build-arg "BASE_IMAGE_VERSION=$BASE_IMAGE_VERSION" \
            --build-arg "HOMEDIR=$HOMEDIR" \
            --build-arg "MAINTAINER=$MAINTAINER" \
            --build-arg "THEEMAIL=$THEEMAIL" \
            --no-cache
}

# Compose Build Example
EX_COMPOSE_BUILD(){
echo "Building via Compose $1 - $2"
BTP_IMAGE --image-name "$1" \
            --image-version "$2" \
            --service "$3" \
            --compose \
            --no-cache
}

case $1 in
    "docker-build-example1")
# Docker Build Example1
EX_DOCKER_BUILD "$EX1_DOCKER_IMAGE_NAME" "$EX1_DOCKER_IMAGE_VERSION"
    ;;
    "compose-build-example1")
# Compose Build Example1
EX_COMPOSE_BUILD "$EX1_COMPOSE_IMAGE_NAME" "$EX1_COMPOSE_IMAGE_VERSION" "example1"
    ;;
    "docker-build-example2")
# Docker Build Example2
EX_DOCKER_BUILD "$EX2_DOCKER_IMAGE_NAME" "$EX2_DOCKER_IMAGE_VERSION"
    ;;
    "compose-build-example2")
# Compose Build Example2
EX_COMPOSE_BUILD "$EX2_COMPOSE_IMAGE_NAME" "$EX2_COMPOSE_IMAGE_VERSION" "example2"
    ;;
    "docker-build-example3")
# Docker Build Example3
EX_DOCKER_BUILD "$EX3_DOCKER_IMAGE_NAME" "$EX3_DOCKER_IMAGE_VERSION"
    ;;
    "compose-build-example3")
# Compose Build Example3
EX_COMPOSE_BUILD "$EX3_COMPOSE_IMAGE_NAME" "$EX3_COMPOSE_IMAGE_VERSION" "example3"
    ;;
    "docker-build-example4")
# Docker Build Example4
EX_DOCKER_BUILD "$EX4_DOCKER_IMAGE_NAME" "$EX4_DOCKER_IMAGE_VERSION" 
    ;;
    "compose-build-example4")
# Compose Build Example4
EX_COMPOSE_BUILD "$EX4_COMPOSE_IMAGE_NAME" "$EX4_COMPOSE_IMAGE_VERSION" "example4"
    ;;
    "docker-build-example5")
# Docker Build Example5
EX_DOCKER_BUILD "$EX5_DOCKER_IMAGE_NAME" "$EX5_DOCKER_IMAGE_VERSION"
    ;;
    "compose-build-example5")
# Compose Build Example5
EX_COMPOSE_BUILD "$EX5_COMPOSE_IMAGE_NAME" "$EX5_COMPOSE_IMAGE_VERSION" "example5"
    ;;
    "docker-build-example6")
# Docker Build Example6
EX_DOCKER_BUILD "$EX6_DOCKER_IMAGE_NAME" "$EX6_DOCKER_IMAGE_VERSION"
    ;;
    "compose-build-example6")
# Compose Build Example6
EX_COMPOSE_BUILD "$EX6_COMPOSE_IMAGE_NAME" "$EX6_COMPOSE_IMAGE_VERSION" "example6"
    ;;
        "docker-build-example7")
# Docker Build Example7
EX_DOCKER_BUILD "$EX7_DOCKER_IMAGE_NAME" "$EX7_DOCKER_IMAGE_VERSION"
    ;;
    "compose-build-example7")
# Compose Build Example7
EX_COMPOSE_BUILD "$EX7_COMPOSE_IMAGE_NAME" "$EX7_COMPOSE_IMAGE_VERSION" "example7"
    ;;
esac