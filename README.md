# YeelightController
Simple shell utility to discover and control Yeelight Wifi Smart bulb

Please read the [blog post](https://shyamvalsan.com/blog/yeelightwifiraspberrypi/) for more details on this project.

## Install
Just copy the files in this repo to your linux machine, the utilities used by the code
are shell, awk, netcat, arp - all of which should be bundled with your OS.
## Run
 1. Plug in the yeelight smart bulb
 2. Turn on the light switch 
 3. Run ./light-configure.sh 
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
```
## Enhancements 
 1. Update the colors file with color name and hex codes to use more colors
 2. Allow for control of multple smart bulbs in the same network   
