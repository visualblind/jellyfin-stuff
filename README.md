# jellyfin-stuff

Author: [Travis Runyard](mailto:travisrunyard@gmail.com)<br>
Website: [travisflix.com](https://travisflix.com)<br>

## DESCRIPTION

**jellyfin-stuff** is a collection of shell scripts, CSS and Nginx configuration files that helps to customize the Jellyfin front-end and accomplish any other tasks not covered by the official plugins (ie. [change the site title](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/jellyfin-set-title.sh)).


Be aware scripts in this repo modify relevant Jellyfin front-end files (html, js, css, etc) directly as there is no other easy way to accomplish the objective so use at your own risk ([force enabling backdrops on by default](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/jellyfin-backdrops-enable.sh) for example). I have done my best to add descriptive comments explaining what is being done if it is not obvious.


> **TIP:** If you run an NGINX reverse proxy in front of Jellyfin, you can do image caching on tmpfs (/dev/shm) to increase the image loading speed. You can find the relevant config in [website.conf](https://github.com/visualblind/jellyfin-stuff/blob/master/nginx/website.conf#L126) using the `proxy_cache` directives.<p>![nginx-image-cache-hit](https://i.ibb.co/R2HwVMW/nginx-image-cache-hit.png)</p>

