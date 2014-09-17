#!/bin/bash
if [[ $# -ne 0 ]] ; then
	sed -n -e $1'{p;q}' | sed -r -e 's/^\s+//g' -e 's/(\s|\t)+/ /g' | cut -d' ' -f$2 | tr '\r\n' ' ' | xclip -selection c
fi