#!/bin/sh

# DOCKER_DOMAIN = The domain to publish to. IE docker.myrepo.com (if a private repository) (optional, defaults to offical docker hub)
# IMAGE_PATH = The path where the image resides. IE mycompany
# IMAGE_NAME = The name of the image. IE apache
# BASEVER = The Major version of the image. IE 1
# BASEVER_WHOLE = The Minor version of the image. IE 1.0
# BASEVER_FULL = The Full version of the image. IE 1.0.0

# Build and Tag Image
# $1 - The service name from the docker-compose file to build. IE CentOS8
# $2 - The image tag. IE centos8
#
# With the above examples the BUILD_IMAGE function would eval to:
#
#   docker-compose build CentOS8
#
#   docker tag apache:centos8 apache:centos8-latest
#   docker tag apache:centos8 apache:centos8-1
#   docker tag apache:centos8 apache:centos8-1.0
#   docker tag apache:centos8 apache:centos8-1.0.0
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8-latest
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8-1
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8-1.0
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8-1.0.0
#
# If an image tag is 'latest', it will evaluate as follows instead:
#
#   docker-compose build CentOS8
#
#   docker tag apache:latest apache:1
#   docker tag apache:latest apache:1.0
#   docker tag apache:latest apache:1.0.0
#   docker tag apache:latest docker.myrepo.com/mycompany/apache:latest
#   docker tag apache:latest docker.myrepo.com/mycompany/apache:1
#   docker tag apache:latest docker.myrepo.com/mycompany/apache:1.0
#   docker tag apache:latest docker.myrepo.com/mycompany/apache:1.0.0
# 
#  If the DOCKER_DOMAIN is empty, it will assume you are building for docker hub and will skip any tagging that includes the full repository name, ie:
# 
#   docker-compose build CentOS8
#   
#   docker tag apache:latest apache:1
#   docker tag apache:latest apache:1.0
#   docker tag apache:latest apache:1.0.0
#   
BUILD_IMAGE(){

    # Build image
    docker-compose build $1

    # 'latest' tag switch
    _BASEVER=$2-${BASEVER}; _BASEVER_WHOLE=$2-${BASEVER_WHOLE}; _BASEVER_FULL=$2-${BASEVER_FULL};
    if test "latest" = $2; then
        _BASEVER=${BASEVER}; _BASEVER_WHOLE=${BASEVER_WHOLE}; _BASEVER_FULL=${BASEVER_FULL};
    fi 

    _PRIV="NO"
    if ! test -z "${DOCKER_DOMAIN}"; then _PRIV="YES"; fi

    echo "$_PRIV"

    # make all tags
    docker tag ${IMAGE_NAME}:$2 ${IMAGE_NAME}:${_BASEVER}
    docker tag ${IMAGE_NAME}:$2 ${IMAGE_NAME}:${_BASEVER_WHOLE}
    docker tag ${IMAGE_NAME}:$2 ${IMAGE_NAME}:${_BASEVER_FULL}
    if test "YES" = $_PRIV; then 
        docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${IMAGE_PATH}/${IMAGE_NAME}:$2
        docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${IMAGE_PATH}/${IMAGE_NAME}:${_BASEVER}
        docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${IMAGE_PATH}/${IMAGE_NAME}:${_BASEVER_WHOLE}
        docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${IMAGE_PATH}/${IMAGE_NAME}:${_BASEVER_FULL}
    fi
    if ! test "latest" = $2; then
        docker tag ${IMAGE_NAME}:$2 ${IMAGE_NAME}:$2-latest;
        if test "YES" = $_PRIV; then 
            docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${IMAGE_PATH}/${IMAGE_NAME}:$2-latest;
        fi
    fi
}

# Publish Image
# $1 - The image tag. IE centos8
#
# With the above examples the PUBLISH_IMAGE functions would eval to:
#
#   docker push docker.myrepo.com/mycompany/apache:centos8
#   docker push docker.myrepo.com/mycompany/apache:centos8-latest
#   docker push docker.myrepo.com/mycompany/apache:centos8-1
#   docker push docker.myrepo.com/mycompany/apache:centos8-1.0
#   docker push docker.myrepo.com/mycompany/apache:centos8-1.0.0
#
# If an image tag is 'latest', it will evaluate as follows instead:
#
#   docker push docker.myrepo.com/mycompany/apache:latest
#   docker push docker.myrepo.com/mycompany/apache:1
#   docker push docker.myrepo.com/mycompany/apache:1.0
#   docker push docker.myrepo.com/mycompany/apache:1.0.0
# 
# If the DOCKER_DOMAIN is empty, it will assume you are publishing to docker hub and will omit the domain name, ie:
#
#   docker push mycompany/apache:latest
#   docker push mycompany/apache:1
#   docker push mycompany/apache:1.0
#   docker push mycompany/apache:1.0.0
#
PUBLISH_IMAGE(){

    # 'latest' tag switch
    _BASEVER=$1-${BASEVER}; _BASEVER_WHOLE=$1-${BASEVER_WHOLE}; _BASEVER_FULL=$1-${BASEVER_FULL};
    if test "latest" = $1; then
        _BASEVER=${BASEVER}; _BASEVER_WHOLE=${BASEVER_WHOLE}; _BASEVER_FULL=${BASEVER_FULL};
    fi 
     _PRIV="NO"
    if ! test -z "${DOCKER_DOMAIN}"; then _PRIV="YES"; fi
    _DOMAIN_PATH="";
    if test "YES" = $_PRIV; then 
        _DOMAIN_PATH="${DOCKER_DOMAIN}/${IMAGE_PATH}/";
    fi 

    docker push ${_DOMAIN_PATH}${IMAGE_NAME}:$1
    docker push ${_DOMAIN_PATH}${IMAGE_NAME}:${_BASEVER}
    docker push ${_DOMAIN_PATH}${IMAGE_NAME}:${_BASEVER_WHOLE}
    docker push ${_DOMAIN_PATH}${IMAGE_NAME}:${_BASEVER_FULL}
    if ! test "latest" = $1; then
        docker push ${_DOMAIN_PATH}${IMAGE_NAME}:$1-latest;
    fi
}

# Build and then Publish the resulting image
# $1 - The service name from the docker-compose file to build. IE CentOS8
# $2 - The image tag. IE centos8
#
# This combines the Build and Publish functions into one.
#
BUILD_AND_PUBLISH_IMAGE(){
    BUILD_IMAGE $1 $2
    PUBLISH_IMAGE $2
}