# Enable Backdrops by Default for All Users (10.11.X)

In `main.jellyfin.bundle.js` simply search for:

```js
value:function(e){return void 0!==e?this.set("enableBackdrops",e.toString(),!1):(0,i.G4)(this.get("enableBackdrops",!1),!1)}},
```

And replace it with: 

```js
value:function(e){return void 0!==e?this.set("enableBackdrops",e.toString(),!1):(0,i.G4)(this.get("enableBackdrops",!1),!0)}},
```

Save the file and reload the cache on your clients to see your changes.


*** If you cannot find it (because of regex in search like in nano) try searching for `enableBackdrops:function`. This should give you the ability to find the string above ***

Source: [BobHasNoSoul](https://github.com/BobHasNoSoul/jellyfin-mods/)
