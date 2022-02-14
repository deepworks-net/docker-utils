#!/bin/sh

# The REGEX Pattern for what is considered a valid tag
VALID_TAG_PATTERN='(((.*)(-))?(v?)([0-9]+)((\.)([0-9]+))?((\.)([0-9]+))?((-)(.*))?)'

# Check if the Passed String is a 'valid' tag. IE in the form of:
# ({prefix}-)? (v?{version}) (-{stage})?
# $1 - The Tag to verify (IE centos8-v1.4.2-alpha)
# 
# Returns 'true' if valid, 'false' if not.
IS_VALID_TAG(){
    [[ $1 =~ $VALID_TAG_PATTERN ]] && echo "true" || echo "false"
}

# 'Extract' a substring from a Version Tag based on the capture group passed to the function
# $1 - The Full Version Tag (IE centos8-v1.4.2-alpha)
# $2 - The Capture Group - IE 3 Would return the prefix, if there is one, as that is it's capture group in the VALID_TAG_PATTERN regex
# 
# Returns the substring from the Full Version Tag based on the capture group number
EXTRACT_FROM_TAG(){
    test ! -z $1 && test ! -z $2 && [[ $1 =~ $VALID_TAG_PATTERN ]] && echo "${BASH_REMATCH[$2]}"
}

# Get The Build Prefix (IE centos8)
# $1 - The Full Version Tag (IE centos8-v1.4.2-alpha)
# 
# Returns everything up to the first '-' from the tag centos8-v1.4.2-alpha. It will return 'centos8' from the tag 'centos8-v1.4.2-alpha'. The -{stage} is optional. centos8-v1.4.2 will return 'centos8'. Returns Empty String if it does not have a prefix.
GET_BUILD_PREFIX(){ 
    EXTRACT_FROM_TAG $1 3
}

# Get The Major Version Number (IE 1)
# $1 - The Full Version Tag (IE v1.4.2-alpha)
# 
# Returns 1 from the tag v1.4.2-alpha. The {prefix}(-)v and (-){stage} are optional, IE 1.4.2 will also return 1.
GET_MAJOR_VERSION(){
    EXTRACT_FROM_TAG $1 6
}

# Get The Minor Version Number (IE 4)
# $1 - The Full Version Tag (IE v1.4.2-alpha)
# 
# Returns 4 from the tag v1.4.2-alpha. The {prefix}v and -{stage} are optional, IE 1.4.2 will also return 4.
GET_MINOR_VERSION(){
    EXTRACT_FROM_TAG $1 9
}

# Get The Patch Version (IE 1.4.2)
# $1 - The Full Version Tag (IE v1.4.2-alpha)
# 
# Returns 2 from the tag v1.4.2-alpha. The {prefix}v and -{stage} are optional, IE 1.4.2 will also return 2.
GET_PATCH_VERSION(){
    EXTRACT_FROM_TAG $1 12
}

# Get The Build Stage (IE alpha)
# $1 - The Full Version Tag (IE v1.4.2-alpha)
# 
# Returns alpha from the tag v1.4.2-alpha. The {prefix}v is optional, IE 1.4.2-alpha will also return alpha. If there is no build stage, an empty string is returned.
GET_BUILD_STAGE(){
    EXTRACT_FROM_TAG $1 15
}

# Get the KEY=VALUE pairs from a specified file and export them to the environment
# $1 - The path of the file to load IE '.env' or 'settings/variables.txt'
# 
# NOTE: This function currently expects the variable file to exist, and will not catch the error if not!
GET_ENV_VARS(){
    export $(cat $1 | sed 's/#.*//g' | xargs)
}

# echo, then evaluate a statement or just echo it
# $1 - The Statement to execute/echo
# $2 - Debug? (YES|NO)
#
EVAL_LINE(){
    [[ "${2:-${DOCKER_UTILS_DEBUG:-NO}}" = "YES" ]] && echo "$1" || ( echo "$1" && eval "$1")
}

# Perform the docker Tag lines for reusability
# $1 - The Source Image Name and Tag IE 'centos8:1.4.2'
# $2 - The New Image Tag IE 'centos8:latest'
# $3 - Debug? (YES|NO)
#
TAG_IMAGE(){
    EVAL_LINE "docker tag $1 $2" "${3:-${DOCKER_UTILS_DEBUG:-NO}}"
}

# Perform the docker Publish lines for reusability
# $1 - The Source Image Name and Tag to publish (full path!) (IE 'centos8:1.4.2')
# $2 - Debug? (YES|NO)
#
PUBLISH_IMAGE(){
    EVAL_LINE "docker push $1" "${2:-${DOCKER_UTILS_DEBUG:-NO}}"
}

# Perform the docker Tag and Publish lines for reusability
# $1 - The Source Image Name and Tag IE 'centos8:1.4.2'
# $2 - The New Image Tag IE 'centos8:latest'
# $3 - Publish the image? (YES|NO|ONLY)
# $4 - Debug? (YES|NO)
#
GET_TAG_N_PUBLISH(){
    if [ "$3" != "ONLY" ]; then
        EVAL_LINE "docker tag $1 $2" "${4:-${DOCKER_UTILS_DEBUG:-NO}}"
    fi
    if [ "$3" = "YES" ] || [ "$3" = "ONLY" ]; then 
        EVAL_LINE "docker push $2" "${4:-${DOCKER_UTILS_DEBUG:-NO}}"
    fi
}

# Behavior can be overridden with the following Environmental Variables (passed parameters will override these values!):
# 
# DOCKER_UTILS_STRIP_PREFIX
#   Ignore the tag prefix (if it exists) when building and tagging
#   Possible values (YES|NO) Default 'NO'
# 
# DOCKER_UTILS_STRIP_VERSION
#   Ignore the version prefix (v) (if it exists) when building and tagging
#   Possible values (YES|NO) Default 'YES'
# 
# DOCKER_UTILS_USE_COMPOSE
#   Use Compose, not Docker, to build the image. The default is 'NO' (ie use docker cli)
#   Possible values (YES|NO) Default 'NO'
# 
# DOCKER_UTILS_TAG_EM
#   Default tagging behavior, Build a single image or make semantic versioning tags as well (ie latest, 1.4.2, 1.4, etc)
#   Possible values (YES|NO) Default 'NO'
# 
# DOCKER_UTILS_DOCKER_DOMAIN
#   If connecting to a custom docker domain, set it here. IE 'docker.deepworks.net'
#   Default ''
# 
# DOCKER_UTILS_DOCKER_GROUP
#   If the custom docker domain supports groups, it can be set here. Must have DOCKER_UTILS_DOCKER_DOMAIN defined. IE 'images/production'
#   Default ''
# 
# DOCKER_UTILS_DEBUG
#   Set debug mode. Only print build and tagging information, don't actually build or publish.
#   Possible values (YES|NO) Default 'NO'
# 
# DOCKER_UTILS_PUBLISH
#   Sets if the image should be published after being built and/or tagged. 'ONLY' will publish any existing images
#   Possible values (YES|NO|ONLY) Default 'NO'
# 

# Build and/or Tag and/or Publish Images
# 
# Possible Parameters/Flags that can be passed:
#   --strip-prefix 
#           Ignore the tag prefix (if it exists) when building and tagging - Default = 'NO'
#   --strip-version
#           Ignore the version prefix (v) (if it exists) when building and tagging - Default = 'YES'
#   -c|--compose
#           Use Compose, not Docker, to build the image. The default is 'NO' (ie use docker cli)
#   -t|--tag-em
#           Default tagging behavior, Build a single image or make semantic versioning tags as well (ie latest, 1.4.2, 1.4, etc). Default = 'NO'
#   -i|--image-name '$imageName'
#           The Image Name for the built image
#   -v|--image-version '$tagVersion'
#           The Image Tag Version for the built image
#   -s|--service '$serviceName'
#           If using Docker Compose to build the image, the service name in the compose file is required.
#   --build-arg '$key=$value'
#           Build Args to pass to docker or compose when building the image
#   --no-cache
#           Pass the 'no-cache' flag to docker or compose when building the image
#   -x|--build-context '$buildContext'
#           Override the default build context ('.')
#   -d|--domain '$domain'
#           If connecting to a custom docker domain, set it here. IE 'docker.deepworks.net'
#   -g|--group '$group'
#           If the custom docker domain supports groups, it can be set here. Must have (-d|--domain) defined. IE 'images/production'
#   -p|--publish '$publish'
#           Publish the images built and tagged
#
BTP_IMAGE(){

    # Define Docker Utils Strip Prefix Flag to get Default Value - Default = NO
    local _STRIP_PREFIX=${DOCKER_UTILS_STRIP_PREFIX:-NO}
    # Define Docker Utils Strip Version Flag to get Default Value - Default = YES
    local _STRIP_VERSION=${DOCKER_UTILS_STRIP_VERSION:-YES}
    # Define Docker Utils Use Compose Flag to get Default Value - Default = NO
    local _USE_COMPOSE=${DOCKER_UTILS_USE_COMPOSE:-NO}
    # Define Docker Tagging Beghavior to get Default Value - Default = NO (Only build, don't tag)
    local _TAG_EM=${DOCKER_UTILS_TAG_EM:-NO}
    # Define Docker Domain (for Private Repository)
    local _DOCKER_DOMAIN=${DOCKER_UTILS_DOCKER_DOMAIN}
    # Define Docker Group (for Private Repository)
    local _DOCKER_GROUP=${DOCKER_UTILS_DOCKER_GROUP}
    # Define Docker DEBUG Option (for debugging!)
    local _DOCKER_DEBUG=${DOCKER_UTILS_DEBUG:-NO}
    # Define Docker Publishing Behavior
    local _DOCKER_PUBLISH=${DOCKER_UTILS_PUBLISH:-NO}

    # Define Potential Defaults
    local _IMAGE_NAME=${IMAGE_NAME};
    local _IMAGE_VERSION=${IMAGE_VERSION:-latest};
    local _BUILD_ARGS="";
    local _NO_CACHE="";
    local _BUILD_CONTEXT=".";
    local _USE_PRIV="NO"

    # Parameter Overrides
    while [[ "$#" -gt 0 ]]
    do
        case $1 in
            --strip-prefix)
            local _STRIP_PREFIX=${2:-$_STRIP_PREFIX}
            ;;
            ---strip-version)
            local _STRIP_VERSION=${2:-$_STRIP_VERSION}
            ;;
            -c|--compose)
            local _USE_COMPOSE="YES"
            ;;
            -i|--image-name)
            local _IMAGE_NAME=${2:-${_IMAGE_NAME:?err}}
            ;;
            -v|--image-version)
            local _IMAGE_VERSION=${2:-${_IMAGE_VERSION}}
            ;;
            -s|--service)
            local _SERVICE_NAME=${2:-latest}
            ;;
            --build-arg)
                if test ! -z $2; then
                    local _BUILD_ARGS="$_BUILD_ARGS--build-arg $2 "
                fi
            ;;
            --no-cache)
            local _NO_CACHE="--no-cache ";
            ;;
            -x|--build-context)
            local _BUILD_CONTEXT=${2:-$_BUILD_CONTEXT}
            ;;
            -t|--tag-em)
            local _TAG_EM="YES"
            ;;
            -d|--domain)
            local _DOCKER_DOMAIN=${2:-$_DOCKER_DOMAIN}
            ;;
            -g|--group)
            local _DOCKER_GROUP=${2:-$_DOCKER_GROUP}
            ;;
            -p|--publish)
            local _DOCKER_PUBLISH=${2:-$_DOCKER_PUBLISH}
            ;;
        esac
        shift
    done

    local _VALID_TAG=$(IS_VALID_TAG $_IMAGE_VERSION)

    # Tag Behavior Override
    if [ "$_VALID_TAG" = "false" ] || [ $_IMAGE_VERSION = "latest" ]; then
        local _TAG_VERSION=$_IMAGE_VERSION; 
    else 

        local _BUILD_PREFIX=$(GET_BUILD_PREFIX $_IMAGE_VERSION)
        local _MAJOR_VERSION=$(GET_MAJOR_VERSION $_IMAGE_VERSION)
        local _MINOR_VERSION=$(GET_MINOR_VERSION $_IMAGE_VERSION)
        local _PATCH_VERSION=$(GET_PATCH_VERSION $_IMAGE_VERSION)
        local _BUILD_STAGE=$(GET_BUILD_STAGE $_IMAGE_VERSION)

        if [ "$_STRIP_PREFIX" = "NO" ] && test ! -z "$_BUILD_PREFIX"; then
            local _TAG_VERSION="$_BUILD_PREFIX-";
            local _TAG_VERSIONL="$_TAG_VERSION"
            local _TAG_VERSION_ALT="$_BUILD_PREFIX"
        fi

        local _TAG_VERSIONL="$_TAG_VERSIONL""latest"

        # This should never fail as 'valid' tags should always have at least a major version number...
        if test ! -z "$_MAJOR_VERSION"; then

            if [ "$_STRIP_VERSION" = "NO" ]; then
                local _TAG_VERSION="$_TAG_VERSION""v";
            fi
            local _TAG_VERSION="$_TAG_VERSION$_MAJOR_VERSION";
            local _TAG_VERSION_MAJOR="$_TAG_VERSION"

            if test ! -z "$_MINOR_VERSION"; then
                local _TAG_VERSION="$_TAG_VERSION.$_MINOR_VERSION";
                local _TAG_VERSION_MINOR="$_TAG_VERSION"

                if test ! -z "$_PATCH_VERSION"; then
                    local _TAG_VERSION="$_TAG_VERSION.$_PATCH_VERSION";
                    local _TAG_VERSION_BUILD="$_TAG_VERSION"
                fi
            fi
        fi

        if test ! -z "$_BUILD_STAGE"; then
            local _TAG_VERSION="$_TAG_VERSION-$_BUILD_STAGE";
            if test ! -z "$_TAG_VERSION_ALT"; then _TAG_VERSION_ALT="$_TAG_VERSION_ALT-$_BUILD_STAGE"; fi
            if test ! -z "$_TAG_VERSION_MINOR"; then local _TAG_VERSION_MINOR="$_TAG_VERSION_MINOR-$_BUILD_STAGE"; fi
            if test ! -z "$_TAG_VERSION_MAJOR"; then local _TAG_VERSION_MAJOR="$_TAG_VERSION_MAJOR-$_BUILD_STAGE"; fi
            if test ! -z "$_TAG_VERSIONL"; then local _TAG_VERSIONL="$_TAG_VERSIONL-$_BUILD_STAGE"; fi
        fi

    fi

    # 'Private' Repo Behavior
    local _THE_PATH=${_IMAGE_NAME}
    if test ! -z "${_DOCKER_DOMAIN}"; then 
        local _USE_PRIV="YES"
        if test ! -z "${_DOCKER_GROUP}"; then local _THE_PATH=${_DOCKER_GROUP}/$_THE_PATH; fi
        local _THE_PATH=${_DOCKER_DOMAIN}/$_THE_PATH;
    fi

    # Build Behavior (Docker or Compose)
    if [ "$_DOCKER_PUBLISH" != "ONLY" ]; then
        if [ "$_USE_COMPOSE" = "NO" ]; then 
            local _BUILD_STATEMENT="docker build -t $_IMAGE_NAME:$_TAG_VERSION \
                --build-arg IMAGE_NAME=$_IMAGE_NAME \
                --build-arg IMAGE_VERSION=$_TAG_VERSION \
                $_BUILD_ARGS \
                $_NO_CACHE \
                $_BUILD_CONTEXT"
            echo $_BUILD_STATEMENT;
            if [ "$_DOCKER_DEBUG" != "YES" ]; then
                eval $_BUILD_STATEMENT;
            fi
        else 
            local _BUILD_STATEMENT="IMAGE_NAME=$_IMAGE_NAME \
            IMAGE_VERSION=$_TAG_VERSION \
            docker compose build $_SERVICE_NAME \
                --build-arg IMAGE_NAME=$_IMAGE_NAME \
                --build-arg IMAGE_VERSION=$_TAG_VERSION \
                $_BUILD_ARGS \
                $_NO_CACHE"
            echo $_BUILD_STATEMENT;
            if [ "$_DOCKER_DEBUG" != "YES" ]; then
                eval $_BUILD_STATEMENT;
            fi
        fi
    fi

    if [ "$_USE_PRIV" = "YES" ]; then 
        GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_THE_PATH}:${_TAG_VERSION}" "$_DOCKER_PUBLISH" "$_DOCKER_DEBUG"
    else
        GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_IMAGE_NAME}:${_TAG_VERSION}" "$_DOCKER_PUBLISH" "$_DOCKER_DEBUG"
    fi

    # To Tag or Not To Tag? That is the Question....
    if [ "$_TAG_EM" = "YES" ] && [ "$_TAG_VERSION" != "latest" ] && [ "$_VALID_TAG" != "false" ]; then

        local _TMP_PUBLISH=$_DOCKER_PUBLISH
        if [ "$_USE_PRIV" = "YES" ] && ([ "$_DOCKER_PUBLISH" = "YES" ] || [ "$_DOCKER_PUBLISH" = "ONLY" ]); then local _TMP_PUBLISH='NO'; fi

        if [ "$_DOCKER_DEBUG" = "YES" ]; then
            echo "$_TAG_VERSION"
            echo "$_TAG_VERSION_MINOR"
            echo "$_TAG_VERSION_MAJOR"
            echo "$_TAG_VERSIONL"
            echo "$_TAG_VERSION_ALT"
        fi

        GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_IMAGE_NAME}:${_TAG_VERSIONL}" "$_TMP_PUBLISH" "$_DOCKER_DEBUG"
        if test ! -z "$_TAG_VERSION_MAJOR" && [ "$_TAG_VERSION_MAJOR" != "$_TAG_VERSION" ]; then 
            GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_IMAGE_NAME}:${_TAG_VERSION_MAJOR}" "$_TMP_PUBLISH" "$_DOCKER_DEBUG"
        fi
        if test ! -z "$_TAG_VERSION_MINOR" && [ "$_TAG_VERSION_MINOR" != "$_TAG_VERSION" ]; then 
            GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_IMAGE_NAME}:${_TAG_VERSION_MINOR}" "$_TMP_PUBLISH" "$_DOCKER_DEBUG"
        fi
        if test ! -z "$_TAG_VERSION_ALT"; then 
            GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_IMAGE_NAME}:${_TAG_VERSION_ALT}" "$_TMP_PUBLISH" "$_DOCKER_DEBUG"
        fi

        if [ "$_USE_PRIV" = "YES" ]; then
            GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_THE_PATH}:${_TAG_VERSIONL}" "$_DOCKER_PUBLISH" "$_DOCKER_DEBUG"
            if test ! -z "$_TAG_VERSION_MAJOR" && [ "$_TAG_VERSION_MAJOR" != "$_TAG_VERSION" ]; then 
               GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_THE_PATH}:${_TAG_VERSION_MAJOR}" "$_DOCKER_PUBLISH" "$_DOCKER_DEBUG"
            fi
            if test ! -z "$_TAG_VERSION_MINOR" && [ "$_TAG_VERSION_MINOR" != "$_TAG_VERSION" ]; then 
                GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_THE_PATH}:${_TAG_VERSION_MINOR}" "$_DOCKER_PUBLISH" "$_DOCKER_DEBUG"
            fi
            if test ! -z "$_TAG_VERSION_ALT"; then 
                GET_TAG_N_PUBLISH "${_IMAGE_NAME}:$_TAG_VERSION" "${_THE_PATH}:${_TAG_VERSION_ALT}" "$_DOCKER_PUBLISH" "$_DOCKER_DEBUG"
            fi
        fi

    fi

}