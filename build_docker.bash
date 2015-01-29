#!/bin/bash
# test if i can get the version
VERSION=$(cat version)

docker build -t plonedocs-"$VERSION" .
