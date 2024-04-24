#!/usr/bin/env bash

HEALTHURL='https://jellyfin_instance/health'

if [ $(curl -sI "$HEALTHURL" | head -n 1 | cut -d ' ' -f 2) -ne 200 ]
then
	docker restart jellyfin
fi

