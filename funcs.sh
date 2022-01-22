#!/bin/sh

# DOCKER_DOMAIN = The domain to publish to. IE docker.myrepo.com (if a private repository) (optional, defaults to offical docker hub)
# IMAGE_PATH = The path where the image resides. IE mycompany
# IMAGE_NAME = The name of the image. IE apache

# Get The Major Version (IE 1)
# $1 - The Full Version Tag (IE v1.4.2-alpha)
# 
# Returns 1 from the tag v1.4.2-alpha. The v and -{version} are optional, IE 1.4.2 will also return 1.
GET_MAJOR_VERSION(){
    TRIMED_TAG=${1##*v};
    FULL_VERSION=${TRIMED_TAG%-*};
    IFS=. read major minor build <<<${FULL_VERSION}
    echo "$major"
}

# Get The Major Version (IE 1.4)
# $1 - The Full Version Tag (IE v1.4.2-alpha)
# 
# Returns 1.4 from the tag v1.4.2-alpha. The v and -{version} are optional, IE 1.4.2 will also return 1.4.
GET_MINOR_VERSION(){
    TRIMED_TAG=${1##*v};
    FULL_VERSION=${TRIMED_TAG%-*};
    IFS=. read major minor build <<<${FULL_VERSION}
    echo "$major.$minor"
}

# Get The Major Version (IE 1.4.2)
# $1 - The Full Version Tag (IE v1.4.2-alpha)
# 
# Returns 1.4.2 from the tag v1.4.2-alpha. The v and -{version} are optional, IE 1.4.2 will also return 1.4.2.
GET_BUILD_VERSION(){
    TRIMED_TAG=${1##*v};
    echo "${TRIMED_TAG%-*}"
}

# Get The Build Stage (IE alpha)
# $1 - The Full Version Tag (IE v1.4.2-alpha)
# 
# Returns alpha from the tag v1.4.2-alpha. The v is optional, IE 1.4.2-alpha will also return alpha. If there is no build stage, an empty string is returned.
GET_BUILD_STAGE(){
    TRIMED_TAG=${1##*v};
    BUILD_STAGE=${TRIMED_TAG##*-};
    FULL_VERSION=${TRIMED_TAG%-*};
    if test "$BUILD_STAGE"="$FULL_VERSION"; then BUILD_STAGE=""; fi
    echo "$BUILD_STAGE"
}

# Build and Tag Image
# $1 - The service name from the docker-compose file to build. IE CentOS8
# $2 - The image tag. IE centos8
# $3 - The Version Tag. IE v1.4.2-alpha
#
# With the above examples the BUILD_IMAGE function would eval to:
#
#   docker-compose build CentOS8
#
#   docker tag apache:centos8 apache:centos8-latest
#   docker tag apache:centos8 apache:centos8-1
#   docker tag apache:centos8 apache:centos8-1.4
#   docker tag apache:centos8 apache:centos8-1.4.2
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8-latest
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8-1
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8-1.4
#   docker tag apache:centos8 docker.myrepo.com/mycompany/apache:centos8-1.4.2
#
# If an image tag is 'latest', it will evaluate as follows instead:
#
#   docker-compose build CentOS8
#
#   docker tag apache:latest apache:1
#   docker tag apache:latest apache:1.4
#   docker tag apache:latest apache:1.4.2
#   docker tag apache:latest docker.myrepo.com/mycompany/apache:latest
#   docker tag apache:latest docker.myrepo.com/mycompany/apache:1
#   docker tag apache:latest docker.myrepo.com/mycompany/apache:1.4
#   docker tag apache:latest docker.myrepo.com/mycompany/apache:1.4.2
# 
#  If the DOCKER_DOMAIN is empty, it will assume you are building for docker hub and will skip any tagging that includes the full repository name, ie:
# 
#   docker-compose build CentOS8
#   
#   docker tag apache:latest apache:1
#   docker tag apache:latest apache:1.4
#   docker tag apache:latest apache:1.4.2
#   
BUILD_IMAGE(){

    # Build image
    docker-compose build $1

    _BUILD_VERSION=$(GET_BUILD_VERSION $3)
    _MINOR_VERSION=$(GET_MINOR_VERSION $3)
    _MAJOR_VERSION=$(GET_MAJOR_VERSION $3)

    # 'latest' tag switch
    _BASEVER=$2-${_MAJOR_VERSION}; _BASEVER_WHOLE=$2-${_MINOR_VERSION}; _BASEVER_FULL=$2-${_BUILD_VERSION};
    if test "latest" = $2; then
        _BASEVER=${_MAJOR_VERSION}; _BASEVER_WHOLE=${_MINOR_VERSION}; _BASEVER_FULL=${_BUILD_VERSION};
    fi 

    _PRIV="NO"
    if ! test -z "${DOCKER_DOMAIN}"; then _PRIV="YES"; fi

    # Build the path
    THEPATH=${IMAGE_NAME};
    if ! test -z "${IMAGE_PATH}"; then THEPATH=${IMAGE_PATH}/$THEPATH; fi

    # make all tags
    docker tag ${IMAGE_NAME}:$2 ${THEPATH}:${_BASEVER}
    docker tag ${IMAGE_NAME}:$2 ${THEPATH}:${_BASEVER_WHOLE}
    docker tag ${IMAGE_NAME}:$2 ${THEPATH}:${_BASEVER_FULL}
    if test "YES" = $_PRIV; then 
        docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${THEPATH}:$2
        docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${THEPATH}:${_BASEVER}
        docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${THEPATH}:${_BASEVER_WHOLE}
        docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${THEPATH}:${_BASEVER_FULL}
    fi
    if ! test "latest" = $2; then
        docker tag ${IMAGE_NAME}:$2 ${THEPATH}:$2-latest;
        if test "YES" = $_PRIV; then 
            docker tag ${IMAGE_NAME}:$2 ${DOCKER_DOMAIN}/${THEPATH}:$2-latest;
        fi
    fi
}

# Publish Image
# $1 - The image tag. IE centos8
# $2 - The Version Tag. IE v1.4.2-alpha
#
# With the above examples the PUBLISH_IMAGE functions would eval to:
#
#   docker push docker.myrepo.com/mycompany/apache:centos8
#   docker push docker.myrepo.com/mycompany/apache:centos8-latest
#   docker push docker.myrepo.com/mycompany/apache:centos8-1
#   docker push docker.myrepo.com/mycompany/apache:centos8-1.4
#   docker push docker.myrepo.com/mycompany/apache:centos8-1.4.2
#
# If an image tag is 'latest', it will evaluate as follows instead:
#
#   docker push docker.myrepo.com/mycompany/apache:latest
#   docker push docker.myrepo.com/mycompany/apache:1
#   docker push docker.myrepo.com/mycompany/apache:1.4
#   docker push docker.myrepo.com/mycompany/apache:1.4.2
# 
# If the DOCKER_DOMAIN is empty, it will assume you are publishing to docker hub and will omit the domain name, ie:
#
#   docker push mycompany/apache:latest
#   docker push mycompany/apache:1
#   docker push mycompany/apache:1.4
#   docker push mycompany/apache:1.4.2
#
PUBLISH_IMAGE(){

    _BUILD_VERSION=$(GET_BUILD_VERSION $2)
    _MINOR_VERSION=$(GET_MINOR_VERSION $2)
    _MAJOR_VERSION=$(GET_MAJOR_VERSION $2)

    # 'latest' tag switch
    _BASEVER=$1-${_MAJOR_VERSION}; _BASEVER_WHOLE=$1-${_MINOR_VERSION}; _BASEVER_FULL=$1-${_BUILD_VERSION};
    if test "latest" = $1; then
        _BASEVER=${_MAJOR_VERSION}; _BASEVER_WHOLE=${_MINOR_VERSION}; _BASEVER_FULL=${_BUILD_VERSION};
    fi 
     _PRIV="NO"
    if ! test -z "${DOCKER_DOMAIN}"; then _PRIV="YES"; fi
    _DOMAIN_PATH=""
    if ! test -z "${IMAGE_PATH}"; then _DOMAIN_PATH="${IMAGE_PATH}/"; fi
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
# $3 - The Version Tag. IE v1.4.2-alpha
#
# This combines the Build and Publish functions into one.
#
BUILD_AND_PUBLISH_IMAGE(){
    BUILD_IMAGE $1 $2 $3
    PUBLISH_IMAGE $2 $3
}