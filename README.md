pimatic-xiaomi-mitv2
=======================
This is a plugin for the [Xiaomi MiTV2](http://www.mi.com/en/mitv) (and possibly other Xiaomi boxes/TVs).

They are smart tv's which are network capable. This plugin is designed to perform some basic actions, hopefully eventually you'll be able to Netflix & Chill with this :-)

###Adding plugin

```json
{
	"plugin" : "xiaomi-mitv2",
    "debug": false
}
```

###Adding a TV

```json
{
	"id": "lounge-tv",
    "class": "MiTV2Device",
    "name": "Lounge TV",
    "ip": "192.168.1.xxx"
}
```
ip: the IP of the mitv box. Reccommended to set static.<br/>
