#!/bin/bash
# current brightness value
BNOW=$(xrandr --verbose | grep 'Brightness' | awk '{printf("%f\n"), $2}')
INC=1
OUTPUT='eDP-1' # xrandr output

# usage
# ./brightness [get[%]] # returns current value
# ./brightness set [1] # set to value
# ./brightness inc [.1] # increase by given step
# ./brightness dec [.1] # decrease by given step
# WARNING: you CAN get the brightness value to 0, meaning 
#    you won't be able to see shit to get back to normal!

if [ -z "$1" ] || [ $1 = 'get' ] || [ $1 = 'get%' ]; then
	if [ $1 = 'get%' ]; then
		echo "$( bc <<< "$BNOW * 100" | awk '{printf("%d"), $1}')"%	
	else
		echo $BNOW
	fi
	exit
else
	if [ -z "$2" ]; then
		INC=0.1
	else
		INC=$2
	fi

	if [ $1 = 'inc' ]; then
		BNEW="$( bc <<<"$BNOW + $INC" )"
		xrandr --output $OUTPUT --brightness $BNEW
	fi
	if [ $1 = 'dec' ]; then
		BNEW="$( bc <<<"$BNOW - $INC" )"
		xrandr --output $OUTPUT --brightness $BNEW
	fi
	if [ $1 = 'set' ]; then
		if [ -z "$2" ]; then
			# set value to 1
			xrandr --output $OUTPUT --brightness 1.0
		else
			# set value to $2
			xrandr --output $OUTPUT --brightness $2
		fi
	fi

fi

