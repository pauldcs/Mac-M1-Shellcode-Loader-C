#!/bin/bash

PROGRAM=$1
FUNCTION=$2

if ! command -v otool > /dev/null; then
    >&2 echo "Error: otool not found"
    exit -1
fi
if ! command -v objdump > /dev/null; then
    >&2 echo "Error: objdump not found"
    exit -1
fi
if [ $# -eq 0 ] ; then
	>&2 echo "Error: Usage"
	>&2 echo "Usage: bash ./script.sh <program> [function]"
	exit -1
fi
if test -f "$PROGRAM"; then
	if [ $# -lt 2 ]; then
		(
			(
				otool -x $PROGRAM | tail -n +3 |
				awk '{printf "0x%x: 0x%8s 0x%8s 0x%8s 0x%8s\n", $1,$2,$3,$4,$5}'
			) && otool -xvX $PROGRAM
		) 2> /dev/null || 
			(>&2 printf "Error: %s: Failed to dump\n" $PROGRAM && exit 1)
		exit 0
	fi
	(
		(
			objdump -d $PROGRAM |
			awk -v RS= "/^[[:xdigit:]]+ <$FUNCTION>/" | tail -n +2 |
			awk '{printf "\"\\x%s\\x%s\\x%s\\x%s\"\t // %5s   %s %s %s %s\n", $2,$3,$4,$5,$6,$7,$8,$9,$10}'
		) 2> /dev/null
	)
	exit 0;
fi
>&2 printf "Error: %s: No such file\n" $PROGRAM
exit 127
