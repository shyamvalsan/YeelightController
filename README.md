# YeelightController

Simple shell utility to discover and control Yeelight Wifi Smart bulb

## Install

Just copy the files in this repo to your linux machine, the utilities used by the code
are shell, awk, netcat, arp - all of which should be bundled with your OS.

## Run

1.  Plug in the yeelight smart bulb(s)
2.  Turn on the light switch
3.  Run ./light.sh -h for options on how to control the bulb(s)

```
Usage: ./light.sh <ip|@alias> <command> -- utility to control Yeelight smart bulb(s) over wi-fi

the 'ip' can be a single value, several values, or ranges of IP addresses,
the '@alias' can be an alias of a bulb or a group of the bulbs,
the 'command' can have one of the following values:

on - turn on the light
off - turn off the light
[color] <color> - set the color to <color>, key is optional
[t] <number> - set the white light temperature to 1700..6500, key is optional
disco - turns on disco mode
sunrise - turns on sunrise mode
notify-<color> - notification in <color>
dim - dim light to brightness 5
undim - reset light to brightness 100
[brightness] <level> - set the brightness to <level> from 1 (dimmest) to 100 (brightest), key is optional

<color>: amber, blue, cyan, dandelion, emerald, flamingo, green, honeydew, indigo, jade, khaki, lavender,
magenta, navy, olive, purple, quartz, red, silver, teal, ultramarine, violet, white, xanadu,
yellow, zinnwaldite
<alias>: available aliases

Examples: ./light.sh 192.168.1.1 on -- turn on the single bulb
          ./light.sh 192.168.1.1-2 192.168.1.4 color red -- give three bulbs the color red
          ./light.sh 192.168.1.1 192.168.1.3 50 -- set the brightness of two bulbs to 50%
          ./light.sh 192.168.1.2 4100 -- set the bulb's white temperature to 4100
          ./light.sh @alias notify-blue -- notify the alias bulbs with blue color
```

## Demo

<a href="http://www.youtube.com/watch?feature=player_embedded&v=EqDKSsEf1HE
" target="_blank"><img src="http://img.youtube.com/vi/EqDKSsEf1HE/0.jpg" 
alt="Demo video of Yeelight smart light controller on Raspberry Pi" width="240" height="180" border="10" /></a>
