#!/usr/bin/env bash

# COMPATIBILITY: JELLYFIN 10.10.X - 10.10.7
# REQUIRES GNU SED WHICH IS 'SED' ON LINUX AND 'GSED' ON BSD PLATFORMS

# PLUG THE FULL PATH TO YOUR "MAIN.JELLYFIN.BUNDLE.JS" FILE BELOW:
jellyfin_bundle_file="<full path to main.jellyfin.bundle.js>"
# EXAMPLE: /jellyfin/jellyfin-web/main.jellyfin.bundle.js

# ENABLE BACKDROPS BY DEFAULT FOR ALL USERS:
sed -E -i 's/enableBackdrops:function\(\)\{return R\}/enableBackdrops:function\(\)\{return E\}/' "$jellyfin_bundle_file"

# TO REVERT THIS CHANGE THEN RETURN THE 'E' BACK TO 'R':
#sed -E -i 's/enableBackdrops:function\(\)\{return E\}/enableBackdrops:function\(\)\{return R\}/' "$jellyfin_bundle_file"

