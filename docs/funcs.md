## funcs.sh
Contains several functions useful for building and publishing docker images.

### GET_MAJOR_VERSION
Requires 1 parameter:
1. The Full Version Tag (IE v1.4.2-alpha)

Returns 1 from the tag v1.4.2-alpha. The 'v' and '-{version}' are optional, IE 1.4.2 will also return 1.

### GET_MINOR_VERSION
Requires 1 parameter:
1. The Full Version Tag (IE v1.4.2-alpha)

Returns 1.4 from the tag v1.4.2-alpha. The 'v' and '-{version}' are optional, IE 1.4.2 will also return 1.4.

### GET_BUILD_VERSION
Requires 1 parameter:
1. The Full Version Tag (IE v1.4.2-alpha)

Returns 1.4.2 from the tag v1.4.2-alpha. The 'v' and '-{version}' are optional, IE 1.4.2 will also return 1.4.2.

### GET_BUILD_STAGE
Requires 1 parameter:
1. The Full Version Tag (IE v1.4.2-alpha)

Returns alpha from the tag v1.4.2-alpha. The 'v' is optional, IE 1.4.2-alpha will also return alpha. If there is no build stage, an empty string is returned.

## Parameters Required For The Following Functions:

- DOCKER_DOMAIN - The domain to publish to ie: docker.myrepo.com
- IMAGE_PATH - The path where the image resides. IE mycompany
- IMAGE_NAME - The name of the image. IE apache

### BUILD_IMAGE
Requires 3 parameters:
1. The service name from the docker-compose file to build. IE CentOS8
2. The image tag. IE centos8
3. The Version Tag. IE v1.4.2-alpha

Following through with the example values, the build function would build the service 'CentOS8', tag the image automagically with the following tags: 

- docker.myrepo.com/mycompany/apache:centos8
- docker.myrepo.com/mycompany/apache:centos8-latest
- docker.myrepo.com/mycompany/apache:centos8-1
- docker.myrepo.com/mycompany/apache:centos8-1.4
- docker.myrepo.com/mycompany/apache:centos8-1.4.2

If an image tag is 'latest', it will tag as follows instead:

- docker.myrepo.com/mycompany/apache:latest
- docker.myrepo.com/mycompany/apache:1
- docker.myrepo.com/mycompany/apache:1.4
- docker.myrepo.com/mycompany/apache:1.4.2

If the DOCKER_DOMAIN is not declared, it will assume you are building for docker hub and will skip any tagging that includes the full repository name, ie:

- mycompany/apache:latest
- mycompany/apache:1
- mycompany/apache:1.4
- mycompany/apache:1.4.2

### PUBLISH_IMAGE
Requires 1 parameter:
1. The image tag. IE centos8
2. The Version Tag. IE v1.4.2-alpha

Following through with the example values, the publish function will publish the following images:

- docker.myrepo.com/mycompany/apache:centos8
- docker.myrepo.com/mycompany/apache:centos8-latest
- docker.myrepo.com/mycompany/apache:centos8-1
- docker.myrepo.com/mycompany/apache:centos8-1.4
- docker.myrepo.com/mycompany/apache:centos8-1.4.2

If an image tag is 'latest', it will publish as follows instead:

- docker.myrepo.com/mycompany/apache:latest
- docker.myrepo.com/mycompany/apache:1
- docker.myrepo.com/mycompany/apache:1.4
- docker.myrepo.com/mycompany/apache:1.4.2

If the DOCKER_DOMAIN is not declared, it will assume you are publishing for docker hub and will omit the domain name. It will publish to docker hub as follows:

- mycompany/apache:latest
- mycompany/apache:1
- mycompany/apache:1.4
- mycompany/apache:1.4.2

### BUILD_AND_PUBLISH_IMAGE 
Requires 2 parameters:
1. The service name from the docker-compose file to build. IE CentOS8
2. The image tag. IE centos8
3. The Version Tag. IE v1.4.2-alpha

This combines the Build and Publish functions into one.
