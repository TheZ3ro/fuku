#!/bin/bash

# Author: @Th3Zer0
#
# This file is released under Public Domain.
# Feel Free. Be Free. ;)

PNAME=fuku

if (( EUID == 0 )); then
	
	if [ -h "/usr/bin/$PNAME" ]; then
		rm -f /usr/bin/$PNAME
		rm -f /usr/bin/$PNAME-demo
	fi
	
	rm -rf /opt/$PNAME
	
else
	echo "Please, run $0 as root"
	exit 1
fi

exit
