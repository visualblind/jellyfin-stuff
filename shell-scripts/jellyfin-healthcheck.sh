#!/usr/bin/env bash

# Enter URI to your Jellyfin health service (typically at /health)
HEALTHURL='http://localhost:8096/health'

##### METHOD 1 #####
if [[ $(curl -s "$HEALTHURL") != "Healthy" ]]
then
	echo "Not Healthy"
else
	echo "Healthy"
fi

#### METHOD 2 #####
if [ $(curl -sI "$HEALTHURL" | head -n 1 | cut -d ' ' -f 2) -ne 200 ]
then
	docker restart jellyfin
fi
