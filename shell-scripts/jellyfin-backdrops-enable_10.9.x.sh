#!/usr/bin/env bash

# COMPATIBILITY: JELLYFIN 10.8.X - 10.9.X
# REQUIRES GNU SED WHICH IS 'SED' ON LINUX AND 'GSED' ON BSD PLATFORMS

# PLUG THE FULL PATH TO YOUR "MAIN.JELLYFIN.BUNDLE.JS" FILE BELOW:
# EXAMPLE: /jellyfin/jellyfin-web/main.jellyfin.bundle.js
jellyfin_bundle_file="<full path to main.jellyfin.bundle.js>"

# ENABLE BACKDROPS BY DEFAULT FOR ALL USERS:
sed -E -i 's/enableBackdrops:function\(\)\{return P\}/enableBackdrops:function\(\)\{return _\}/' "$jellyfin_bundle_file"

# TO REVERT THIS CHANGE THEN RETURN THE '_' BACK TO 'P':
#sed -E -i 's/enableBackdrops:function\(\)\{return _\}/enableBackdrops:function\(\)\{return P\}/' "$jellyfin_bundle_file"

