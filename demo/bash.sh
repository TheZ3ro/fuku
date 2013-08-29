#!/bin/bash

#
#  bash.sh
#  
#  Author: thezero <silvethebest@yahoo.it>
#  Start date: 27/08/2013  
#

function jsonval {
	temp=`echo $1 | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w "$2"` # 
	echo ${temp##*|}
}

../core/server.js `pwd`/pref.json | \
while read CMD; do
	echo $CMD
	if [[ $CMD == "END" ]]; then	
		exit
    fi
    if [[ ! $CMD == \#* ]]; then	
		ping -c `jsonval $CMD count` `jsonval $CMD ip` 
    fi
    # do what you want with the string :D
done
