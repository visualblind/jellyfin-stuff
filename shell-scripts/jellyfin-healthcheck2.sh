#!/usr/bin/env bash

HEALTHURL='https://travisflix.com/health'

if [[ $(curl -s "$HEALTHURL") != "Healthy" ]]
then
	echo "Not Healthy"
else
	echo "Healthy"
fi

