#!/usr/bin/env bash

# compatibility: jellyfin 10.9.x

# customize website title
NEWTITLE=NewSiteTitle
sed -i "s/document.title=\"Jellyfin\"/document.title=\"$NEWTITLE\"/" 73233.bce0f70761dae6c47906.chunk.js
sed -i "s/document.title=e||\"Jellyfin\"}/document.title=e||\"$NEWTITLE\"}/" 73233.bce0f70761dae6c47906.chunk.js
sed -i "s/<title>Jellyfin/<title>$NEWTITLE/" index.html
