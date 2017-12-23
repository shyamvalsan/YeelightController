# YeelightController
Simple shell utility to discover and control Yeelight Wifi Smart bulb

Please read the [blog post](https://shyamvalsan.com/blog/yeelightwifiraspberrypi/) for more details on this project.

## Install
Just copy the files in this repo to your linux machine, the utilities used by the code
are shell, awk, netcat, arp - all of which should be bundled with your OS.
## Run
 1. Plug in the yeelight smart bulb
 2. Turn on the light switch 
 3. Run ./configure-light.sh (if you already know the IP address of your smart bulb then write it to ip.list and skip to step 5)
 4. Wait till light-configure exits, confirm that it ended successfully (If not, try repeating steps 2 and 3) 
 5. Run ./light.sh -h for options on how to control the bulb 
```
light.sh [command] <color> -- utility to control Yeelight smart bulb over wifi

where command can have one of the following values:
    on - turn on the light
    off - turn off the light
    color <color> - set the color to <color> where <color> is a color (red/blue/green/white and so on)
    disco - turns on disco mode
    sunrise - turns on sunrise mode
    notify-blue - notification in blue color
    notify-green - notification in green color
    notify-red - notification in red color
    brightness <level> - set brightness to <level> where <level> is an integer from 1 (dimmest) to 100 (brightest)
    dim - dim brightness to level 10
    undim - reset brightness to level 100
```
## Demo
<a href="http://www.youtube.com/watch?feature=player_embedded&v=EqDKSsEf1HE
" target="_blank"><img src="http://img.youtube.com/vi/EqDKSsEf1HE/0.jpg" 
alt="Demo video of Yeelight smart light controller on Raspberry Pi" width="240" height="180" border="10" /></a>

## Enhancements 
 1. Update the colors file with color name and hex codes to use more colors
 2. Allow for control of multple smart bulbs in the same network   

## Troubleshooting
 1. In case configure-light.sh finds zero devices try running nmap and try again
 ```
 sudo nmap -sP 192.168.1.*
 ```
