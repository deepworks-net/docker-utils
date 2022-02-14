#!/bin/sh

# Install updates:
apk -U upgrade --no-cache && rm -rf /var/cache/apk/*
