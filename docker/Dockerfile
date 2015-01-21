# We use Ubuntu, since docs.plone.org is running on it too
From ubuntu:14.04

MAINTAINER Sven Strack <sven@so36.net>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends python-software-properties && \
    add-apt-repository ppa:nginx/stable && \
    apt-get update && \
    apt-get install nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV DEBIAN_FRONTEND newt

# Define default command.
CMD ["nginx"]
# # Expose ports.
EXPOSE 80


