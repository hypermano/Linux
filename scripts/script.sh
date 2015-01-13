#!/bin/bash
#set -x
for X in $@; do
	RES=$(grep -R --include "*.java" --include "*.properties" -F $X ~/src/duda/)
	if [ -z "$RES" ]; then
		echo "Deprecated $X";
	fi
done