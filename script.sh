#!/bin/bash

PROG=$1
FUNC=$2

if [ $# -lt 1 ]; then
    echo "Error: Usage" > /dev/stderr
	echo "Usage: bash ./script.sh <program> [function]" > /dev/stderr
    exit 1
fi

if [ $# -lt 2 ]; then
	(nm -Am $PROG && objdump -d $PROG && objdump -s $PROG) 2> /dev/null || 
		printf "Error: Failed to dump '%s'\n" $PROG
	exit 0
fi

printf "const char %s[] =\n{\n" $FUNC
objdump -d $PROG |
awk -v RS= "/^[[:xdigit:]]+ <$FUNC>/" | tail -n +2 |
awk '{printf "\t0x%s, 0x%s, 0x%s, 0x%s,\n", $2,$3,$4,$5,$6,$7,$8,$9}'
echo "};"
