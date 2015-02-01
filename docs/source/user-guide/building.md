# Building Documentation

Building documentation is done via the *build.bash* script.
This script has different build options:

    - build only Plone 3 docs
    - build only Plone 4 docs
    - build docs for Plone 3 and Plone 4

![Screenshot](img/mr.publisher_help.png)


## Usage

To make it a bit more easier to use, you can just call them via *make*

Building docs for Plone 3:

    make plone 3

Building docs for Plone 4:

    make Plone 4

Building docs for Plone 3 and Plone 4

    make build-all


## Result

The build script will always build the html version, the docset and the docset xml file.
If you want to build the docker container too, please check the [docker part](docker.md) of this  documentation.
