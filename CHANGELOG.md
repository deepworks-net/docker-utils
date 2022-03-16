# Docker Utility Scripts Technical Change Log

#### (03/15/2022) 0.2.2-beta:
- [funcs.sh](funcs.sh):
    - Added MSYS_NO_PATHCONV=1 env var when loading variables to prevent Windows from converting the path to the C:

#### (02/13/2022) 0.2.1-beta:
- [info.sh](info.sh)
    - Included funcs.sh to fix info file issues.

#### (02/13/2022) 0.2.0-beta:
- [docs/](docs)
    - Updated [funcs.md](docs/funcs.md)
    - Updated [info.md](docs/info.md)
- [examples/](examples)
    - Added examples for some different build scenarios
    - Added examples for some different publish scenarios
    - Added example [docker-compose.yml](examples/docker-compose.yml) file
    - Added example [Dockerfile](examples/Dockerfile) file
    - Added example [.env](examples/.env) file
- [funcs.sh](funcs.sh):
    - Made building/tagging/publishing to Docker Hub the default behavior
    - Added function GET_ENV_VARS that will load variables into the environment from a file
    - Added VALID_TAG_PATTERN regex pattern to check a tag against to determine if the format is valid
    - Added IS_VALID_TAG function to test against the VALID_TAG_PATTERN to see if a tag is valid or not
    - Added EXTRACT_FROM_TAG function to pull out substrings based on capture group for valid tags
    - Added GET_BUILD_PREFIX function to get the build prefix of a tag (if it exists)
    - Added GET_MAJOR_VERSION function to get the Major Version Number of a tag (if it exists)
    - Added GET_MINOR_VERSION function to get the Minor Version Number of a tag (if it exists)
    - Added GET_PATCH_VERSION function to get the Patch Version Number of a tag (if it exists)
    - Added GET_BUILD_STAGE function to get the Build Stage of a tag (if it exists)
    - Added TAG_IMAGE function to perform the 'docker tag' command
    - Added new PUBLISH_IMAGE function to perform the 'docker publish' command
    - Added GET_TAG_N_PUBLISH function to perform the 'docker tag' or 'docker publish' commands and accounting for DOCKER_UTILS_DEBUG Settings
    - Added EVAL_LINE function to either evaluate a statement or just echo it (accounting for DOCKER_UTILS_DEBUG Settings)
    - Changed tagging behavior to automatically determine and tag and image when building/publishing
    - Added numerous Environmental and CLI settings for building images
    - Removed BUILD_IMAGE, PUBLISH_IMAGE (Old Version), and BUILD_AND_PUBLISH_IMAGE functions
- [info.sh](info.sh)
    - Changed THEAUTHOR variable references to MAINTAINER
    - Changed THEDIRECTORY variable references to HOMEDIR
- Changed image_name variable references to IMAGE_NAME
- Changed image_version variable references to IMAGE_VERSION
- Changed base_image_name variable references to BASE_IMAGE_NAME
- Changed base_image_version variable references to BASE_IMAGE_VERSION

#### (01/21/2022) 0.1.2-beta:
- Added support for Docker Hub

#### (01/19/2022) 0.1.1-beta:
- Added functions to parse a 'version' tag to get the Major.Minor.Build-Stage Values
- Updated Build and Publish functions to utilize the 'new' version tag.
- Added support for Docker Hub

#### (01/17/2022) 0.0.7-beta:
- Initial Release
