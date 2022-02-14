#!/bin/sh
DOCKER_UTILS_TAG_EM=${DOCKER_UTILS_TAG_EM:-YES}
DOCKER_UTILS_PUBLISH=${DOCKER_UTILS_PUBLISH:-YES}
#DOCKER_UTILS_DEBUG=${DOCKER_UTILS_DEBUG:-YES}
# Copy New Info Script (as Dockerfile cannot reach into a parent directory)
cp "../info.sh" "info.sh"
# Load functions
. "../funcs.sh"

# Load variables
GET_ENV_VARS ".env"

# Docker Publish Example
EX_DOCKER_PUBLISH(){
echo "Publishing $1 - $2"
BTP_IMAGE --image-name "$1" \
            --image-version "$2" \
            --publish "ONLY"
}

case $1 in
    "docker-publish-example1")
# Docker Build Example1
EX_DOCKER_PUBLISH "$EX1_DOCKER_IMAGE_NAME" "$EX1_DOCKER_IMAGE_VERSION"
    ;;
    "compose-publish-example1")
# Compose Build Example1
EX_DOCKER_PUBLISH "$EX1_COMPOSE_IMAGE_NAME" "$EX1_COMPOSE_IMAGE_VERSION"
    ;;
    "docker-publish-example2")
# Docker Build Example2
EX_DOCKER_PUBLISH "$EX2_DOCKER_IMAGE_NAME" "$EX2_DOCKER_IMAGE_VERSION"
    ;;
    "compose-publish-example2")
# Compose Build Example2
EX_DOCKER_PUBLISH "$EX2_COMPOSE_IMAGE_NAME" "$EX2_COMPOSE_IMAGE_VERSION"
    ;;
    "docker-publish-example3")
# Docker Build Example3
EX_DOCKER_PUBLISH "$EX3_DOCKER_IMAGE_NAME" "$EX3_DOCKER_IMAGE_VERSION"
    ;;
    "compose-publish-example3")
# Compose Build Example3
EX_DOCKER_PUBLISH "$EX3_COMPOSE_IMAGE_NAME" "$EX3_COMPOSE_IMAGE_VERSION"
    ;;
    "docker-publish-example4")
# Docker Build Example4
EX_DOCKER_PUBLISH "$EX4_DOCKER_IMAGE_NAME" "$EX4_DOCKER_IMAGE_VERSION" 
    ;;
    "compose-publish-example4")
# Compose Build Example4
EX_DOCKER_PUBLISH "$EX4_COMPOSE_IMAGE_NAME" "$EX4_COMPOSE_IMAGE_VERSION"
    ;;
    "docker-publish-example5")
# Docker Build Example5
EX_DOCKER_PUBLISH "$EX5_DOCKER_IMAGE_NAME" "$EX5_DOCKER_IMAGE_VERSION"
    ;;
    "compose-publish-example5")
# Compose Build Example5
EX_DOCKER_PUBLISH "$EX5_COMPOSE_IMAGE_NAME" "$EX5_COMPOSE_IMAGE_VERSION"
    ;;
    "docker-publish-example6")
# Docker Build Example6
EX_DOCKER_PUBLISH "$EX6_DOCKER_IMAGE_NAME" "$EX6_DOCKER_IMAGE_VERSION"
    ;;
    "compose-publish-example6")
# Compose Build Example6
EX_DOCKER_PUBLISH "$EX6_COMPOSE_IMAGE_NAME" "$EX6_COMPOSE_IMAGE_VERSION"
    ;;
    "docker-publish-example7")
# Docker Build Example7
EX_DOCKER_PUBLISH "$EX7_DOCKER_IMAGE_NAME" "$EX7_DOCKER_IMAGE_VERSION"
    ;;
    "compose-publish-example7")
# Compose Build Example7
EX_DOCKER_PUBLISH "$EX7_COMPOSE_IMAGE_NAME" "$EX7_COMPOSE_IMAGE_VERSION"
    ;;
esac