#!/usr/bin/env bash

HEALTHURL='https://jellyfin_instance/health'

if [[ $(curl -s "$HEALTHURL") != "Healthy" ]]
then
	echo "Not Healthy"
else
	echo "Healthy"
fi

