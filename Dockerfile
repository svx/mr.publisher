# We use Ubuntu, since docs.plone.org is running on it too
From ubuntu:14.04

MAINTAINER Sven Strack <sven@so36.net>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:nginx/stable && \
    apt-get update && \
    apt-get install -y --no-install-recommends nginx && \
    mkdir -p /var/www/43 && \
    mkdir -p /var/www/33 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV DEBIAN_FRONTEND newt

COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/mime.types /etc/nginx/mime.types
COPY docker/nginx/default /etc/nginx/sites-available/default
#COPY nginx/docker/index.html /var/www/43/index.html
COPY Plone4/build/html/docker/ /var/www/43/en
# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80


