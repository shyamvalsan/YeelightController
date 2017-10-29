# YeelightController
Simple shell utility to discover and control Yeelight Wifi Smart bulb

Please read the blog post for more details on this project.

## Install
Just copy the files in this repo to your linux machine, the utilities used by the code
are shell, awk, netcat, arp - all of which should be bundled with your OS.
## Run
 1. Plug in the yeelight smart bulb
 2. Turn on the light switch 
 3. Run ./light-configure.sh 
 4. Wait till light-configure exits, confirm that it ended successfully. If not try repeating steps 2 and 3 
 5. Run ./light.sh -h for options on how to control the bulb 
## Enhancements 
 1. Update the colors file with color name and hex codes to use more colors
 2. Allow for control of multple smart bulbs in the same network   
