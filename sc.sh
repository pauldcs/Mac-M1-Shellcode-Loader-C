#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Error: Usage" > /dev/stderr
	echo "Usage: sh ./sc.sh <binary.macho> <function>" > /dev/stderr
    exit 1
fi

PROG=$1
FUNC=$2

objdump -d $PROG |
awk -v RS= "/^[[:xdigit:]]+ <$FUNC>/" | 
tail -n +2 |
awk '{printf "\"\\x%s\\x%s\\x%s\\x%s\" // %s%5s %s\n", $2,$3,$4,$5,$6,$7,$8}'
