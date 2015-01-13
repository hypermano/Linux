#!/bin/bash
declare -a ARR1
declare -a ARR2

DATE=$1

if [ -z "$DATE" ] ; then
	DATE=$(date -d 'yesterday' +%d/%m);
else
	case $DATE in
		*/*)
		;;
		*)
		DATE=$(date -d "$DATE days ago" +%d/%m)
		;;
	esac
fi

echo "[Since $DATE]"

TRUNK_FILE=TRUNK_$RANDOM$RANDOM$RANDOM
FREEZE_FILE=FREEZE_$RANDOM$RANDOM$RANDOM
git log trunk --format=%s --after $DATE --committer emmanuel | sort -u > $TRUNK_FILE
git log freeze --format=%s --after $DATE --committer emmanuel | sort -u > $FREEZE_FILE

readarray ARR1 < $TRUNK_FILE
readarray ARR2 < $FREEZE_FILE

declare -A MAP1
declare -A MAP2

# populate the commits of each branch
for X in "${ARR1[@]}"; do MAP1[$(echo "$X" | md5sum | tr ' -' '0')]="$X"; done 
for X in "${ARR2[@]}"; do MAP2[$(echo "$X" | md5sum | tr ' -' '0')]="$X"; done

# calculate the difference
for X in "${ARR1[@]}"; do unset MAP2[$(echo "$X" | md5sum | tr ' -' '0')]; done 
for X in "${ARR2[@]}"; do unset MAP1[$(echo "$X" | md5sum | tr ' -' '0')]; done 

echo ""

if [ ${#MAP1[@]} == 0 ]; then
	printf "\033[1;32m%s\033[0m\n" "Freeze Good";
else
	echo "Missing Commits on Freeze:"
	echo "=========================="
	for X in "${!MAP1[@]}"; do 
		printf "%s " "-"; 
		printf "\033[1;31m%s\033[0m" "${MAP1["$X"]}"; 
	done
fi

echo ""

if [ ${#MAP2[@]} == 0 ]; then
	printf "\033[1;32m%s\033[0m\n" "Trunk Good"
else
	echo "Missing Commits on Trunk:"
	echo "========================="
	for X in "${!MAP2[@]}"; do 
		printf "%s " "-"; 
		printf "\033[1;31m%s\033[0m" "${MAP2["$X"]}"; 
	done
fi

rm $TRUNK_FILE
rm $FREEZE_FILE

export ARR1