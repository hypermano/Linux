#!/bin/bash
source $HOME/.keychain/${HOSTNAME}-sh
if { wget -q --spider http://www.google.com &> /dev/null; } then
	cd ~/src/duda;
	if [ $? == 0 ]; then
		git fetch -q;
	fi
fi;
