#!/usr/bin/env bash

# compatibility: jellyfin 10.8.x

# customize website title
NEWTITLE=NewTitleHere
sed -i "s/document.title=\"Jellyfin\"/document.title=\"$NEWTITLE\"/" main.jellyfin.bundle.js
sed -i "s/document.title=e||\"Jellyfin\"}/document.title=e||\"$NEWTITLE\"}/" main.jellyfin.bundle.js
sed -i "s/<title>Jellyfin/<title>$NEWTITLE/" index.html

