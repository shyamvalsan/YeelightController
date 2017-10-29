# YeelightController
Simple shell utility to discover and control Yeelight Wifi Smart bulb

Please read the blog post for more details on this project.

## Install
Just copy the files in this repo to your linux machine, the utilities used by the code
are shell, awk, netcat, arp - all of which should be bundled with your OS.
## Run
 1. Plug in the yeelight smart bulb. 
 2. Run ./light-configure.
 2. Plug in the yeelight smart bulb.
 3. Wait till light-configure exits, confirm that it got a success. If not try repeating steps 1 and 2.
 4. Run ./light.sh -h for options on how to control the bulb. 
## Enhancements 
 1. Update the colors file with color name and hex codes to use more colors.
 2. Allow for control of multple smart bulbs in the same network.   
