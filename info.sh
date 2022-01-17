#!/bin/sh

# THEAUTHOR = The Author Of The Image
# THEDIRECTORY = The directory where the branding is placed
# THEEMAIL = Email address for the image info

# Set default vars.
THEFILE="${THEDIRECTORY}/info.txt";

# Make the Directory
mkdir -p ${THEDIRECTORY};

# Build/Append the file
#
# 'Requires' the following parameters:
# base_image_name - The Base Image Name IE centos
# base_image_version - The Base Image Version IE 7.9.2009
# image_name - The image name IE centos7
# image_version - the image version IE 1.0.2
#
echo "==========================================

Image: ${image_name}:${image_version}
Author: ${THEAUTHOR}
Email: ${THEEMAIL}
Base Image: ${base_image_name}:${base_image_version}
Build Date: $(TZ=America/New_York date)

==========================================" >>${THEFILE};
