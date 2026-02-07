# jellyfin-stuff

📧  [travisrunyard@gmail.com](mailto:travisrunyard@gmail.com)<br>
🔗 [travisflix.com](https://travisflix.com)<br>

## 📌 DESCRIPTION

[jellyfin-stuff](https://github.com/visualblind/jellyfin-stuff/) is a collection of shell scripts, html/css/js and other conf files which helps customize the Jellyfin web interface and accomplish other tasks not covered by any official plugins (ie. changing the site title or enabling the backdrop by default).

Scripts in this repo modify relevant Jellyfin front-end files (html, js, css, etc) directly as there is no other easy way to accomplish the objective without modifying source files and re-compiling the web interface yourself, so use at your own risk. I recommend you also check out BobHasNoSoul's [jellyfin-mods](https://github.com/BobHasNoSoul/jellyfin-mods) as it's a lot more extensive.

I have done my best to add descriptive comments in the shell scripts explaining what is being done if it is not obvious. If you couldn't tell, the script files are not meant to be ran by themselves, but rather serve as a reference source for modifying according to your needs then copy/pasting the one-liners into your terminal and running that way (I know I could have shebanged to something other than a shell or gave them a txt extension but we all prefer to do things our own way).

# 📑 INDEX

1. Customize the Site Title of the Jellyfin Web Interface
   
    1. [10.8.x](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/jellyfin-set-title_10.8.x.sh) | [10.9.x](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/jellyfin-set-title_10.9.x.sh) | [10.10.x](https://github.com/visualblind/jellyfin-stuff/blob/master/site-title.md) | [Universal](https://github.com/visualblind/jellyfin-stuff/blob/master/site-title.md) (recommended)

2. Enable Jellyfin Backdrops for All Users by Default
   
    1. [10.8.x - 10.9.x](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/jellyfin-backdrops-enable_10.9.x.sh) | [10.10.x](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/jellyfin-backdrops-enable_10.10.x.sh) | [10.11.x](https://github.com/visualblind/jellyfin-stuff/blob/master/force-enable-backdrops-10.11.x.md)
       
        ![enable-backDrops-by-default](https://i.ibb.co/8gDn1rBS/jellyfin-enable-Backdrops-function-return-E.png)

3. [Clean your External Subrip Subtitles](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/subtitle-cleaner.sh) (SRT) from Annoying Ads, Insecure Authors Seeking Praise, and Other Bullshit!
   
   **UPDATE**: If you need to also convert Windows line endings (CRLF) to Unix, check out [subtitle-fixes.sh](https://github.com/visualblind/jellyfin-stuff/blob/master/shell-scripts/subtitle-fixes.sh) instead.

<br>

>  💡 **TIP:** If you run a reverse proxy like NGINX/Caddy/Traefik in front of Jellyfin, you can do image caching on tmpfs aka `/dev/shm` to increase the image loading speed.

<br>

>  💡 **ANOTHER TIP:** If you're using Cloudflare with your Jellyfin system, you are violating the Cloudflare TOS (terms of service). The second sentence of the TOS below lays it out for you. *"Jerry You a Vehdy Bad, Bad, Man!"*<br><br>
> [Content Delivery Network (Free, Pro, or Business)](https://www.cloudflare.com/en-gb/service-specific-terms-application-services/#content-delivery-network-terms).
> 
> Cloudflare’s content delivery network (the “CDN”) Service can be used to cache and serve web pages and websites. <strong>Unless you are an Enterprise customer, Cloudflare offers specific Paid Services (e.g., the Developer Platform, Images, and Stream) that you must use in order to serve video and other large files via the CDN.</strong> Cloudflare reserves the right to disable or limit your access to or use of the CDN, or to limit your End Users’ access to certain of your resources through the CDN, if you use or are suspected of using the CDN without such Paid Services to serve video or a disproportionate percentage of pictures, audio files, or other large files. We will use reasonable efforts to provide you with notice of such action.

<br>

<img align="left" src="https://i.ibb.co/R2HwVMW/nginx-image-cache-hit.png">
Regarding the tmpfs image caching mentioned earlier, you can find the relevant NGINX config in <a href="https://github.com/visualblind/jellyfin-stuff/blob/master/nginx/website.conf#L126">website.conf</a> using the <code>proxy_cache</code> directives.
