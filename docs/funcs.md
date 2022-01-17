## funcs.sh
Contains 3 functions: BUILD_IMAGE, PUBLISH_IMAGE and BUILD_AND_PUBLISH_IMAGE. All functions require the following variables to be declared and set:

- DOCKER_DOMAIN - The domain to publish to ie: docker.myrepo.com
- IMAGE_PATH - The path where the image resides. IE mycompany
- IMAGE_NAME - The name of the image. IE apache
- BASEVER - The Major version of the image. IE 1
- BASEVER_WHOLE - The Minor version of the image. IE 1.0
- BASEVER_FULL - The Full version of the image. IE 1.0.0

### BUILD_IMAGE
Requires 2 parameters:
1. The service name from the docker-compose file to build. IE CentOS8
2. The image tag. IE centos8

Following through with the example values, the build function would build the service 'CentOS8', tag the image automagically with the following tags: 

- docker.myrepo.com/mycompany/apache:centos8
- docker.myrepo.com/mycompany/apache:centos8-latest
- docker.myrepo.com/mycompany/apache:centos8-1
- docker.myrepo.com/mycompany/apache:centos8-1.0
- docker.myrepo.com/mycompany/apache:centos8-1.0.0

If an image tag is 'latest', it will tag as follows instead:

- docker.myrepo.com/mycompany/apache:latest
- docker.myrepo.com/mycompany/apache:1
- docker.myrepo.com/mycompany/apache:1.0
- docker.myrepo.com/mycompany/apache:1.0.0

### PUBLISH_IMAGE
Requires 1 parameter:
1. The image tag. IE centos8

Following through with the example values, the publish function will publish the following images:

- docker.myrepo.com/mycompany/apache:centos8
- docker.myrepo.com/mycompany/apache:centos8-latest
- docker.myrepo.com/mycompany/apache:centos8-1
- docker.myrepo.com/mycompany/apache:centos8-1.0
- docker.myrepo.com/mycompany/apache:centos8-1.0.0

If an image tag is 'latest', it will publish as follows instead:

- docker.myrepo.com/mycompany/apache:latest
- docker.myrepo.com/mycompany/apache:1
- docker.myrepo.com/mycompany/apache:1.0
- docker.myrepo.com/mycompany/apache:1.0.0

### BUILD_AND_PUBLISH_IMAGE 
Requires 2 parameters:
1. The service name from the docker-compose file to build. IE CentOS8
2. The image tag. IE centos8

This combines the Build and Publish functions into one.
