# jellyfin-stuff

Author: [Travis Runyard](travisrunyard@gmail.com)<br>
Updated: 02-28-2024


## DESCRIPTION

**jellyfin-stuff** is a collection of various shell scripts, css and nginx configuration files which help to customize the Jellyfin front-end interface and automate any other tasks not covered by the official plugins.


Be aware scripts in this repo modify relevant Jellyfin front-end files (html, js, css, etc) directly as there is no other easy way to accomplish the objective so use at your own risk ([force enabling backdrops on by default](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/jellyfin-backdrops-enable.sh) for example). I have done my best to add descriptive comments explaining what is being done if it is not obvious.


?> TIP: If you run an NGINX reverse proxy in front of Jellyfin, you can do image caching on tmpfs (/dev/shm) to increase the image loading speed. You can find the relevant config in [nginx.conf](https://github.com/visualblind/jellyfin-stuff/blob/master/nginx/nginx.conf) and [website.conf](https://github.com/visualblind/jellyfin-stuff/blob/master/nginx/website.conf) using the proxy_cache directives.

