#!/bin/bash

# Author: @Th3Zer0
#
# This file is released under Public Domain.
# Feel Free. Be Free. ;)

PNAME=fuku
DESTINATION="/opt/$PNAME"

if (( EUID == 0 )); then
	chmod a+x ./uninstall.sh
	cd ./core
	cp -r ./ $DESTINATION
	cd ..
	cp -r ./demo $DESTINATION
	cp -r ./uninstall.sh $DESTINATION
	chmod -R 777 $DESTINATION
	cd $DESTINATION

	if [ ! -e "/usr/bin/$PNAME" ]; then
		ln -s "$DESTINATION/$PNAME" /usr/bin/
		ln -s "$DESTINATION/demo/$PNAME-demo" /usr/bin/
	fi
else
	echo "Please, run $0 as root"
	exit 1
fi

exit
