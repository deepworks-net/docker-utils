# funcs.sh
Contains several functions useful for building, tagging and publishing docker images. Source it like so:
```SHELL
~]$ . "./funcs.sh"
```

## Environmental Variables
### DOCKER_UTILS_STRIP_PREFIX
- Ignore the tag prefix (if it exists) when building and tagging
- Possible values (YES|NO) Default 'NO'

### DOCKER_UTILS_STRIP_VERSION
- Ignore the version prefix (v) (if it exists) when building and tagging
- Possible values (YES|NO) Default 'YES'

### DOCKER_UTILS_USE_COMPOSE
- Use Compose, not Docker, to build the image. The default is 'NO' (ie use docker cli)
- Possible values (YES|NO) Default 'NO'

### DOCKER_UTILS_TAG_EM
- Default tagging behavior, Build a single image or make semantic versioning tags as well (ie latest, 1.4.2, 1.4, etc)
- Possible values (YES|NO) Default 'NO'

### DOCKER_UTILS_DOCKER_DOMAIN
- If connecting to a custom docker domain, set it here. IE 'docker.deepworks.net'
- Default ''

### DOCKER_UTILS_DOCKER_GROUP
- If the custom docker domain supports groups, it can be set here. Must have DOCKER_UTILS_DOCKER_DOMAIN defined. IE 'images/production'
- Default ''

### DOCKER_UTILS_DEBUG
- Set debug mode. Only print build and tagging information, don't actually build or publish.
- Possible values (YES|NO) Default 'NO'

### DOCKER_UTILS_PUBLISH
- Sets if the image should be published after being built and/or tagged. 'ONLY' will publish any existing images
- Possible values (YES|NO|ONLY) Default 'NO'

## IS_VALID_TAG
Requires 1 parameter:
1. The Full Version Tag (IE centos8-v1.4.2-alpha)

Check if the Passed String is a 'valid' tag. IE in the form of:
```REGEX
(((.*)(-))?(v?)([0-9]+)((\.)([0-9]+))?((\.)([0-9]+))?((-)(.*))?)
```

or in psudo code:
```REGEX
({prefix}-)? (v?{version}) (-{stage})?
```

Returns 'true' if valid, 'false' if not.

### Examples:
```SHELL
~]$ IS_VALID_TAG "v1.4.2-alpha"
true

~]$ IS_VALID_TAG "is-this-valid?"
false

```

## EXTRACT_FROM_TAG
Requires 2 parameters:
1. The Full Version Tag (IE centos8-v1.4.2-alpha)
2. The Capture Group to 'get' - IE 3 Would return the what matches the 3rd capture group in the VALID_TAG_PATTERN regex.

Returns the substring from the Full Version Tag based on the capture group number

### Examples:
```SHELL
~]$ echo $VALID_TAG_PATTERN
(((.*)(-))?(v?)([0-9]+)((\.)([0-9]+))?((\.)([0-9]+))?((-)(.*))?)

~]$ EXTRACT_FROM_TAG "centos8-v1.4.2-alpha" 3
centos8

~]$ EXTRACT_FROM_TAG "centos8-v1.4.2-alpha" 15
alpha

```

## GET_BUILD_PREFIX
Requires 1 parameter:
1. The Full Version Tag (IE centos8-v1.4.2-alpha)

Returns the build prefix from the full version tag.
Returns Empty String if it does not have a prefix.

### Examples:
```SHELL
~]$ GET_BUILD_PREFIX "centos8-v1.4.2-alpha"
centos8

~]$ GET_BUILD_PREFIX "v1.4.2-alpha"

```

## GET_MAJOR_VERSION
Requires 1 parameter:
1. The Full Version Tag (IE centos8-v1.4.2-alpha)

Returns 1 from the tag centos8-v1.4.2-alpha.
Returns Empty String if it does not have a Major Version.

### Examples:
```SHELL
~]$ GET_MAJOR_VERSION "centos8-v1.4.2-alpha"
1

~]$ GET_MAJOR_VERSION "1.4.2"
1

~]$ GET_MAJOR_VERSION "latest"

```

## GET_MINOR_VERSION
Requires 1 parameter:
1. The Full Version Tag (IE centos8-v1.4.2-alpha)

Returns 4 from the tag centos8-v1.4.2-alpha.
Returns Empty String if it does not have a Minor Version.

### Examples:
```SHELL
~]$ GET_MINOR_VERSION "centos8-v1.4.2-alpha"
4

~]$ GET_MINOR_VERSION "1.4.2"
4

~]$ GET_MINOR_VERSION "centos8-v1-alpha"

```

## GET_PATCH_VERSION
Requires 1 parameter:
1. The Full Version Tag (IE centos8-v1.4.2-alpha)

Returns 2 from the tag centos8-v1.4.2-alpha.
Returns Empty String if it does not have a Patch Version.

### Examples:
```SHELL
~]$ GET_PATCH_VERSION "centos8-v1.4.2-alpha"
2

~]$ GET_PATCH_VERSION "1.4.2"
2

~]$ GET_PATCH_VERSION "centos8-v1-alpha"

```

## GET_BUILD_STAGE
Requires 1 parameter:
1. The Full Version Tag (IE centos8-v1.4.2-alpha)

Returns alpha from the tag centos8-v1.4.2-alpha.
Returns Empty String if it does not have a Build Stage.

### Examples:
```SHELL
~]$ GET_PATCH_VERSION "centos8-v1.4.2-alpha"
alpha

~]$ GET_PATCH_VERSION "1.4.2"


~]$ GET_PATCH_VERSION "centos8-v1-beta"
beta

```

## GET_ENV_VARS
Requires 1 parameter:
1.  The path of the file to load IE '.env' or 'settings/variables.txt'

NOTE: This function currently expects the variable file to exist, and will not catch the error if not!

### Example:
```SHELL
~]$ echo "IMAGE_NAME=deepworks/docker-utils" >> ".env"
~]$ echo "IMAGE_VERSION=centos8-v1-beta" >> ".env"
~]$ cat ".env"
IMAGE_NAME=deepworks/docker-utils
IMAGE_VERSION=centos8-v1-beta

~]$ GET_ENV_VARS ".env"
~]$ echo "$IMAGE_NAME:$IMAGE_VERSION"
deepworks/docker-utils:centos8-v1-beta

```

## EVAL_LINE
Requires 2 parameters:
1. The Statement to execute
2. Override the default debug behavior (Optional)

### Example:
```SHELL
~]$ EVAL_LINE "echo 'Hello World'!"
echo 'Hello World'!
Hello World!

~]$ EVAL_LINE "echo 'Hello World'!" "YES"
echo 'Hello World'!

```

## TAG_IMAGE
Requires 3 parameters:
1. The Source Image Name and Tag IE 'centos8:1.4.2'
2. The New Image Tag IE 'centos8:latest'
3. Override the default debug behavior (Optional)

### Example:
```SHELL
~]$ TAG_IMAGE "centos8:1.4.2" "centos8:latest"
docker tag centos8:1.4.2 centos8:latest

```

## PUBLISH_IMAGE
Requires 2 parameters:
1. The Source Image Name and Tag to publish (full path!) (IE 'centos8:1.4.2')
2. Override the default debug behavior (Optional)

### Example:
```SHELL
~]$ PUBLISH_IMAGE "centos8:latest"
docker push centos8:latest

```

## GET_TAG_N_PUBLISH
Requires 4 parameters:
1. The Source Image Name and Tag IE 'centos8:1.4.2'
2. The New Image Tag IE 'centos8:latest'
3. Publish the image? (YES|NO|ONLY)
4. Override the default debug behavior (Optional)

Can Tag and/or publish an image

### Example:
```SHELL
~]$ GET_TAG_N_PUBLISH "centos8:1.4.2" "centos8:latest"
docker tag centos8:1.4.2 centos8:latest
docker push centos8:latest

~]$ GET_TAG_N_PUBLISH "centos8:1.4.2" "centos8:latest" "ONLY"
docker push centos8:latest

```

## BTP_IMAGE
Build and/or Tag and/or Publish Images

Possible Parameters/Flags that can be passed:
```SHELL
   --strip-prefix 
           Ignore the tag prefix (if it exists) when building and tagging - Default = 'NO'
   --strip-version
           Ignore the version prefix (v) (if it exists) when building and tagging - Default = 'YES'
   -c|--compose
           Use Compose, not Docker, to build the image. The default is 'NO' (ie use docker cli)
   -t|--tag-em
           Default tagging behavior, Build a single image or make semantic versioning tags as well (ie latest, 1.4.2, 1.4, etc). Default = 'NO'
   -i|--image-name '$imageName'
           The Image Name for the built image
   -v|--image-version '$tagVersion'
           The Image Tag Version for the built image
   -s|--service '$serviceName'
           If using Docker Compose to build the image, the service name in the compose file is required.
   --build-arg '$key=$value'
           Build Args to pass to docker or compose when building the image
   --no-cache
           Pass the 'no-cache' flag to docker or compose when building the image
   -x|--build-context '$buildContext'
           Override the default build context ('.')
   -d|--domain '$domain'
           If connecting to a custom docker domain, set it here. IE 'docker.deepworks.net'
   -g|--group '$group'
           If the custom docker domain supports groups, it can be set here. Must have (-d|--domain) defined. IE 'images/production'
   -p|--publish '$publish'
           Publish the images built and tagged
```

See [examples/](examples) for it all in action!
