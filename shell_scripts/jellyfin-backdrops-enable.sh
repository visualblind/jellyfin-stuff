#!/usr/bin/env bash

# compatibility: jellyfin 10.8.x

# enable backdrops by default for all users
sed -E -i 's/enableBackdrops\:function\(\)\{return P\}/enableBackdrops\:function\(\)\{return \_\}/' main.jellyfin.bundle.js

# if you wish to revert this change then change the _ back to P like this:
# 's/enableBackdrops\:function\(\)\{return \_\}/enableBackdrops\:function\(\)\{return P\}/'

