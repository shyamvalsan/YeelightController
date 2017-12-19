#!/bin/sh
# Simple script to control Yeelight over wifi

# The command is provided as input by the user to this script
command=$1

# IP of the Yeelight is discovered by running the configure-light.sh script (works for a single bulb as of now)
[ -f ip.list ] && ip=`cat ip.list` || echo "Please run configure-light.sh first if you haven't run it before in this network." 

case $command in
"on")
 printf "{\"id\":1,\"method\":\"set_power\",\"params\":[\"on\",\"smooth\",500]}\r\n" | nc -w1 $ip 55443
 ;;
"off")
 printf "{\"id\":1,\"method\":\"set_power\",\"params\":[\"off\",\"smooth\",500]}\r\n" | nc -w1 $ip 55443
 ;;
"color")
 color_hex=$(grep -i $2 colors | awk -F, '{print $2}') 
 color_int=$(printf '%d' $color_hex) 
 printf "{\"id\":1,\"method\":\"set_rgb\",\"params\":[$color_int,\"smooth\",500]}\r\n" | nc -w1 $ip 55443
 ;;
"disco")
 printf "{\"id\":1,\"method\":\"start_cf\",\"params\":[ 50, 0, \"100, 1, 255, 100, 100, 1, 32768, 100, 100, 1, 16711680, 100\"]}\r\n" | nc -w1 $ip 55443
 ;;
"sunrise")
 printf "{\"id\":1,\"method\":\"start_cf\",\"params\":[ 3, 1, \"50, 1, 16731392, 1, 360000, 2, 1700, 10, 540000, 2, 2700, 100\"}]\r\n" | nc -w1 $ip 55443
 ;;
"notify-blue")
 printf "{\"id\":1,\"method\":\"start_cf\",\"params\":[ 5, 0, \"100, 1, 255, 100, 100, 1, 255, 1\"]}\r\n" | nc -w1 $ip 55443
 ;;
"notify-green")
 printf "{\"id\":1,\"method\":\"start_cf\",\"params\":[ 5, 0, \"100, 1, 32768, 100, 100, 1, 32768, 1\"]}\r\n" | nc -w1 $ip 55443
 ;;
"notify-red")
 printf "{\"id\":1,\"method\":\"start_cf\",\"params\":[ 5, 0, \"100, 1, 16711680, 100, 100, 1, 16711680, 1\"]}\r\n" | nc -w1 $ip 55443
 ;;
 "dim")
 printf "{\"id\":1,\"method\":\"set_bright\",\"params\":[5]}\r\n" | nc -w1 $ip 55443
 ;;
"undim")
 printf "{\"id\":1,\"method\":\"set_bright\",\"params\":[100]}\r\n" | nc -w1 $ip 55443
 ;;
"brightness")
 level=$2
 printf "{\"id\":1,\"method\":\"set_bright\",\"params\":[$level]}\r\n" | nc -w1 $ip 55443
 ;;
*)
 printf "
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
    dim - dim light to brightness 5
    undim - reset light to brightness 100
    brightness <level> - set the brightness to <level> where <level> is an integer from 1 (dimmest) to 100 (brightest)
"
;;
esac
