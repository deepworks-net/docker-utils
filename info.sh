#!/bin/sh

# MAINTAINER = The Author Of The Image
# HOMEDIR = The directory where the branding is placed
# THEEMAIL = Email address for the image info

#echo "${HOMEDIR}"

# Set default vars.
THEFILE="${HOMEDIR}/info.txt";

# Make the Directory
mkdir -p "${HOMEDIR}";

# Build/Append the file
#
# 'Requires' the following parameters:
# BASE_IMAGE_NAME - The Base Image Name IE centos
# BASE_IMAGE_VERSION - The Base Image Version Tag IE 7.9.2009
# IMAGE_NAME - The image name IE centos7
# IMAGE_VERSION - the image version tag IE 1.0.2
#
echo "==========================================

Image: ${IMAGE_NAME}:${IMAGE_VERSION}
Author: ${MAINTAINER}
Email: ${THEEMAIL}
Base Image: ${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}
Build Date: $(TZ=America/New_York date)

==========================================" >>${THEFILE};
