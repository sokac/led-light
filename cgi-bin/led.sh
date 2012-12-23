#!/bin/sh

function getParam(){
	local tmp=$(echo "&$1" | sed -n "s/.*&$2=\([^&]*\).*/\1/gp")
	if [ "$3" -eq "1" ]
	then
		tmp=$(printf "%d" $tmp)
	fi
	echo $tmp
}

if [ "$REQUEST_METHOD" = "POST" ]; then
	if [ "$CONTENT_LENGTH" -gt 0 ]; then
		read -n $CONTENT_LENGTH POST_DATA <&0
	fi
fi


echo Content-type: text/plain
echo ""

type=$(getParam $POST_DATA type)

case "$type" in
	"static")
		color=$(getParam $POST_DATA s-color)
		if [ ! ${#color} == 9 ]
		then
			echo "FAIL"
			exit
		fi
		printf "static;%d;%d;%d;\n" 0x${color:3:2} 0x${color:5:2} 0x${color:7:2} >> /tmp/commands.txt;;
	"dynamic")
		delay=$(getParam $POST_DATA d-delay 1)
		if [ $delay -gt 999 ]
		then
			echo "FAIL"
			exit
		elif [ ${#delay} == 0 ]
		then
			delay=0
		fi

		brightness=$(getParam $POST_DATA d-brightness 1)
		if [ $brightness -gt 255 ]
		then
			echo "FAIL"
			exit
		elif [ ${#brightness} == 0 ]
		then
			brightness=1
		fi

		echo "dynamic;$delay;$brightness;" >> /tmp/commands.txt;;
	"pulse")
		beats=$(getParam $POST_DATA p-beats 1)
		if [ $beats -gt 999 ]
		then
			echo "FAIL"
			exit
		elif [ $beats -lt 1 ]
		then
			echo "FAIL"
			exit
		elif [ ${#beats} == 0 ]
		then
			beats=1
		fi

		delay=$(getParam $POST_DATA p-delay 1)
		if [ $delay -gt 999 ]
		then
			echo "FAIL"
			exit
		elif [ ${#delay} == 0 ]
		then
			delay=0
		fi

		brightness=$(getParam $POST_DATA p-brightness 1)
		if [ $brightness -gt 255 ]
		then
			echo "FAIL"
			exit
		elif [ ${#brightness} == 0 ]
		then
			brightness=1
		fi

		echo "pulse;$beats;$delay;$brightness;" >> /tmp/commands.txt;;
esac

echo "OK"

# echo $(echo $POST_DATA | tr '=' ' ' | cut -d' ' -f2)';'
