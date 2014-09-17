#!/bin/bash
if [[ $# -ne 0 ]] ; then
	mv "$1" ~/.trash
	echo $1 deleted
fi
