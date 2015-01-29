#!/bin/bash
# test if i can get the version
VERSION=$(cat version.txt)

docker build -t plonedocs-"$VERSION" .
