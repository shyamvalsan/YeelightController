#!/bin/sh
# Script to discover the IP address of a Yeelight wifi bulb in the network (works for one bulb as of now)
# The script avoids the SSDP discovery by filtering out arp output for a MAC address matching the
# Yeelight manufacturer ID and then verifying it's the right one by confirming that  port 55443 is open

echo "Configuration started"
ip=$(arp -n | tail -n+2 | awk '{print $1","$3}' | grep -i ",34:ce" | awk -F, '{print $1}' | head -n 1)
bulbs=$(echo $ip | awk '{print NF}')
echo "$bulbs device(s) detected with MAC address match"
echo "Checking if port 55443 is open"
x=1

# Only pick the first IP for now - if multiple bulbs exist, use awk to cycle through
candidate_ip=$(echo $ip | awk '{print $1}')
verified_ip=$(netcat -zvw1 $candidate_ip 55443 2>&1 | grep "succeeded" | awk '{print $3}')
  
echo $verified_ip > ip.list
echo "$verified_ip added to ip.list"
echo "Configuration completed"
