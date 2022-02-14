## info.sh
A script to be run when creating a docker container to place a file with information about its creation. Requires the following parameters to be declared:
- BASE_IMAGE_NAME - The Base Image Name IE centos
- BASE_IMAGE_VERSION - The Base Image Version IE 7.9.2009
- IMAGE_NAME - The image name IE centos7
- IMAGE_VERSION - the image version IE 1.0.2
- HOMEDIR - the directory where the info file is installed IE /.myimage/
- MAINTAINER - the maintainer of the image
- THEEMAIL - the email of the maintainer of the image

### Directions:
Copy info.sh into your working directory. Run the script. That's it! Make sure the parameters are declared as ARGs in the docker file or those fields will be blank when creating the file(s)!

A folder is created at ${HOMEDIR} - Inside you will find information related to the image in a file named info.txt.
