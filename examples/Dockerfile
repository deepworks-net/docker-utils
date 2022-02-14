# Declare Vars - These are required and need to be passed in/set via Environmental Variable!
ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION

# Pull the base image
FROM ${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION} AS base
#Set The WorkDir
WORKDIR /tmp/
ARG IMAGE_NAME
ARG IMAGE_VERSION
ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION
ARG MAINTAINER
ARG THEEMAIL
ARG HOMEDIR
# Copy Scripts
COPY configure.sh info.sh ./
# Run the Scripts
RUN ./info.sh && ./configure.sh && rm ./configure.sh && rm ./info.sh

# Add all changes to scratch image
FROM scratch AS final
# Declare Vars - These are meant to be passed in/set via Environmental Variable!
ARG IMAGE_NAME
ARG IMAGE_VERSION
ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION
ARG MAINTAINER
ARG THEEMAIL

# Set the WorkDir
WORKDIR /

# Copy all files
COPY --from=base / /

# Set Metadata
LABEL maintainer="${MAINTAINER}" \
        osimage="${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}" \
        baseimage="${IMAGE_NAME}:${IMAGE_VERSION}" \
        image="${IMAGE_NAME}" \
        version="${IMAGE_VERSION}" \
        email="${THEEMAIL}"

# Set locales
#ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV MAINTAINER "${MAINTAINER}"

# No Healthcheck for this base image
HEALTHCHECK NONE