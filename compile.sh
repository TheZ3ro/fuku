#!/bin/bash

# Author: @Th3Zer0
#
# This file is released under Public Domain.
# Feel Free. Be Free. ;)

PNAME=fuku
DESTINATION="/opt/$PNAME"
HOME=`pwd`

if (( EUID == 0 )); then
	USCITA=0
	if [ $(dpkg -s python-gi | grep -c "install ok") -ne "1" ]; then
		echo "Impossibile trovare il programma: python-gi."
		USCITA=1
	fi

	if [ $(dpkg -s gir1.2-gtk-3.0 | grep -c "install ok") -ne "1" ]; then
		echo "Impossibile trovare il programma: gir1.2-gtk-3.0."
		USCITA=1
	fi
	
	if [ $(dpkg -s gir1.2-webkit-3.0 | grep -c "install ok") -ne "1" ]; then
		echo "Impossibile trovare il programma: gir1.2-webkit-3.0."
		USCITA=1
	fi
	
	if [ ! -e /usr/bin/pyinstaller ]; then
		echo "Impossibile trovare il programma: pyinstaller."
		USCITA=1
	fi	

	if [ ! -e /usr/bin/debmod ]; then
		echo "Impossibile trovare il programma: debmod."
		USCITA=1
	fi	

	if [ "$USCITA" = '1' ]; then
		exit 1
	fi

	mkdir "$DESTINATION-temp"
	pyinstaller ./core/pywebview.py -F --buildpath="$DESTINATION-temp" --out="$DESTINATION-temp"
	cp "$DESTINATION-temp/dist/pywebview" ./core/
	
	NAMESPACE="$DESTINATION-deb"

	mkdir -p `echo $NAMESPACE/DEBIAN`
	mkdir -p `echo $NAMESPACE/$DESTINATION/demo`

	cd $HOME/dist/DEBIAN
	cp -r ./ `echo $NAMESPACE/DEBIAN`
	cd $HOME/core
	cp -r ./ `echo $NAMESPACE/$DESTINATION`
	cd $HOME
	cp -r ./demo `echo $NAMESPACE/$DESTINATION`
	chmod -R 777 `echo $NAMESPACE/$DESTINATION`
	debmod -b $NAMESPACE
	mv `echo $NAMESPACE.deb` ./

	rm -rf "$DESTINATION-temp"

	rm *.log
else
	echo "Please, run $0 as root"
	exit 1
fi

exit
