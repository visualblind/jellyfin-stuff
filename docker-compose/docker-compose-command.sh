#!/usr/bin/env bash

# Just showing an example of using docker compose syntax

docker compose -f ~/docker-compose/docker-compose2.yml up -d --no-recreate

# Using the --no-recreate switch can be seen as a way to doing a sanity check or dry run as the container
# needs to be removed manually or else it will not be re-created (happens on accident sometimes if not careful)

