# Customize the Site Title of the Jellyfin Web Interface

**Compatibility:** Jellyfin independent

This info is targeted at the Jellyfin 10.10.x versions, however there is no technical reason that it could not be applied to every Jellyfin version ever made since it relies solely on JS.

Replace all instances of the string **YOURNAME** with whatever you want to display in your sites title:

```javascript
<script>document.addEventListener("DOMContentLoaded",(function(){document.title="YOURNAME";new MutationObserver((function(t){t.forEach((function(t){"childList"===t.type&&"YOURNAME"!==document.title&&(document.title="YOURNAME")}))})).observe(document.querySelector("title"),{childList:!0}),Object.defineProperty(document,"title",{set:function(){return"YOURNAME"},get:function(){return"YOURNAME"}})}))</script>
```

Find the Jellyfin index.html file (in the docker version the default location is `/jellyfin/jellyfin-web/index.html`) and paste the javascript right after the following string:

```javascript
<script defer="defer" src="runtime.bundle.js?0f9d6486af79af0b5be2"></script>
```

And before the following string:

```javascript
<script defer="defer" src="node_modules.%40jellyfin.sdk.bundle.js?0f9d6486af79af0b5be2"></script>
```

It does not matter a lot where exactly you paste the actual javascript as long as it's between the html `<head>` and `</head>`.

You should also modify the html title inbetween the `<title>` and `</title>` html tags otherwise you might observe some weirdness. Not really sure, don't really care, just change it though.

For instance: `<title>Jellyfin</title>` should become `<title>Your Modified Name</title>`.

Once that is all done, restart the Jellyfin server and if you're using any sort of cache inbetween you and Jellyfin make sure that is cleared. If you still don't see any results, double and triple check that cache and use incognito mode in your browser or at least use the hard-refresh hotkey rather than standard refresh.
