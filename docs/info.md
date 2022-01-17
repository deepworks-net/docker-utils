## info.sh
A script to be run when creating a docker container to place a file with information about its creation. Requires the following parameters to be declared:
- base_image_name - The Base Image Name IE centos
- base_image_version - The Base Image Version IE 7.9.2009
- image_name - The image name IE centos7
- image_version - the image version IE 1.0.2
- THEDIRECTORY - the directory where the info file is installed IE /.myimage/
- THEAUTHOR - the author of the image
- THEEMAIL - the email of the author of the image

### Directions:
Copy info.sh into your working directory. Run the script. That's it! Make sure the parameters are declared as ARGs in the docker file or those fields will be blank when creating the file(s)!

A folder is created at ${THEDIRECTORY} - Inside you will find information related to the image in a file named info.txt.
