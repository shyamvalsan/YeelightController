#!/usr/bin/env bash
# Simple script to control Yeelight over wi-fi

# Color values
read -r -d '' colors << EOF
amber;#FFBF00
blue;#0000FF
cyan;#00FFFF
dandelion;#F0E130
emerald;#50C878
flamingo;#FC8EAC
green;#00FF00
honeydew;#F0FFF0
indigo;#4B0082
jade;#00A86B
khaki;#C3B091
lavender;#E6E6FA
magenta;#FF00FF
navy;#000080
olive;#808000
purple;#800080
quartz;#51484F
red;#FF0000
silver;#C0C0C0
teal;#008080
ultramarine;#3F00FF
violet;#EE82EE
white;#FFFFFF
xanadu;#738678
yellow;#FFFF00
zinnwaldite;#2C1608
EOF

# Bulb groups, each can be one or a range of IP addresses, or a lot of groups
read -r -d '' bulbs << EOF
@room;192.168.88.51-54
@kitchen;192.168.88.57-59
@bathroom;192.168.88.55
@monitor;192.168.88.51
@stand;192.168.88.52
@tv;192.168.88.53 192.168.88.54
@all;192.168.88.51-54 192.168.88.55 192.168.88.57-59
EOF

print_help() {
  cat << EOF

Usage: $(basename "$0") <ip|@alias> <command> -- utility to control Yeelight smart bulb(s) over wi-fi

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
[brightness] <level> - from 1 (dimmest) to 100 (brightest), key is optional

<color>: $(tr '\n' ' ' <<< "$colors" | sed 's/;#[0-9A-Fa-f]*//g' | sed 's/ $//' | sed 's/ /, /g' | fold -w 75 -s)
<alias>: $(cut -d ';' -f1 <<< "$bulbs" | tr '\n' ' ' | sed 's/ $//' | sed 's/ /, /g' | fold -w 75 -s)

Examples: $(basename "$0") 192.168.1.1 on -- turn on the single bulb
          $(basename "$0") 192.168.1.1-2 192.168.1.4 color red -- give three bulbs the color red
          $(basename "$0") 192.168.1.1 192.168.1.3 50 -- set the brightness of two bulbs to 50%
          $(basename "$0") 192.168.1.2 4100 -- set the bulb's white temperature to 4100
          $(basename "$0") @room notify-blue -- notify via the room bulbs with blue color

EOF
  exit 0
}

# Convert the bulbs string to an associative array
declare -A bulb_groups
while IFS=';' read -r key value; do
  bulb_groups[$key]=$value
done <<< "$bulbs"

# The array of IP addresses
ips=()

# Add the argument to the array of IP addresses
add_arg_to_ips() {
  local arg=$1
  # If the argument is a IP range, replace it with the corresponding IPs
  if [[ "$arg" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-[0-9]+$ ]]; then
    IFS='-' read -r ip range <<< "$arg"
    IFS='.' read -r i1 i2 i3 i4 <<< "$ip"
    for i in $(seq "$i4" 1 "$range"); do
      ips+=("$i1.$i2.$i3.$i")
    done
  # If the group IP is a single IP address, add it to the array
  elif [[ "$arg" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    ips+=("$arg")
  else
    # Otherwise, set the parameter variable or param if command is not empty
    if [ -z "$command" ]; then
      command="$arg"
    else
      param="$arg"
    fi
  fi
}

# Iterate over all arguments
for arg in "$@"; do
 # If the argument is an alias or a group name, replace it with the corresponding IPs
  if [[ ${bulb_groups[$arg]} ]]; then
    IFS=' ' read -r -a group_ips <<< "${bulb_groups[$arg]}"
    for group_ip in "${group_ips[@]}"; do
      add_arg_to_ips "$group_ip"
    done
  # If the argument is IP or the address range, add all IPs in the range to the array  
    else add_arg_to_ips "$arg"
  fi
done

case "$command" in
  ""|"help"|"--help"|"-h")
  print_help
  ;;
esac

send_command() {
  printf '{"id": 1, "method":"%s", "params":[%s]}\r\n' "$2" "$3" | nc -w 1 "$1" 55443 &
}

color_to_int() {
  color_hex=$(grep "$1" <<< "$colors" | cut -d';' -f2 | sed 's/#/0x/')
  printf '%d' "$color_hex"
}

# If the command is a known color name, assume the 'color' command
if grep -qi "^$command" <<< "$colors" ; then
  color=$command
  command="color"
else
  color=$param
fi

# If the command is a number, assume the 't' or 'brightness' commands
if grep -qE '^[0-9]+$' <<< "$command" 2>/dev/null; then
  num=$command
  # If 1 <= command <= 100, assume the 'brightness' command else assume the 't' command
  [ "$command" -ge 1 ] && [ "$command" -le 1699 ] && command="brightness" || command="t"
else
  num=$param
fi

# Iterate over all IPs provided as arguments
for ip in "${ips[@]}"; do
  case $command in
    "on"|"off")
      send_command "$ip" set_power '"'"$command"'","smooth",500'
      ;;
    "color")
      send_command "$ip" set_scene '"color", '"$(color_to_int "$color")"', 100'
      ;;
    't')
      if [[ "$num" -ge 1700 && "$num" -le 6500 ]]; then
        send_command "$ip" set_ct_abx ''"$num"', "smooth", 500'
      else
        echo -e "\nColor temperature must be between 1700 and 6500"
        print_help
      fi
    ;;
    "disco")
      send_command "$ip" start_cf '50, 0, "100, 1, 255, 100, 100, 1, 32768, 100, 100, 1, 16711680, 100"'
      ;;
    "sunrise")
      send_command "$ip" start_cf '3, 1, "50, 1, 16731392, 1, 360000, 2, 1700, 10, 540000, 2, 2700, 100"'
      ;;
    "notify-"*)
      color=$(color_to_int "${command#notify-}")
      send_command "$ip" start_cf '5, 0, "100, 1, '"$color"', 100, 100, 1, '"$color"', 1"'
      ;;
    "dim")
      send_command "$ip" set_bright 5
      ;;
    "undim")
      send_command "$ip" set_bright 100
      ;;
    "brightness")
      if [[ "$num" -ge 1 && "$num" -le 100 ]]; then
        send_command "$ip" set_bright "$num"
      else
        echo -e "\nBrightness must be between 1 and 100"
        print_help
      fi
    ;;
    *)
      print_help
    ;;
  esac
done