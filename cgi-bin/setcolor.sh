#!/bin/sh
echo $(echo $QUERY_STRING | tr '=' ' ' | cut -d' ' -f2)';' > /tmp/serijskiport.txt
#echo -n $(echo $QUERY_STRING | tr '=' ' ' | cut -d' ' -f2)';' > /dev/ttyACM0
