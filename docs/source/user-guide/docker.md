# Docker

## Building

To build a docker container just run:

    make docker

Which is just a wrapper around this command:

    ./build.bash --docker

This will build a docker container with documentation for Plone 3 and Plone 4

Please note, for docker builds we are using a slightly modified Sphinx configuration file, where GA and Opensearch settings are removed.



