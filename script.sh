#!/bin/bash

FUNCTION=$2
PROGRAM=$1

if [ $# -lt 1 ]; then
    >&2 echo "Error: Usage"
	>&2 echo "Usage: bash ./script.sh <program> [function]"
    exit -1
fi

if test -f "$PROGRAM"; then
	if [ $# -lt 2 ]; then
		(
			nm -Am $PROGRAM &&
			objdump -d $PROGRAM &&
			objdump -s $PROGRAM
		) 2> /dev/null || 
			(>&2 printf "Error: %s: Failed to dump\n" $PROGRAM && exit 1)
		exit 0
	fi
	printf "const char %s[] =\n{\n" $FUNCTION
	(
		(
			objdump -d $PROGRAM |
			awk -v RS= "/^[[:xdigit:]]+ <$FUNCTION>/" | tail -n +2 |
			awk '{printf "\t0x%s, 0x%s, 0x%s, 0x%s,\n", $2,$3,$4,$5,$6,$7,$8,$9}'
		) 2> /dev/null
	) | tee >(SIZE=$(wc -w); echo "Shellcode size:" $SIZE)

	echo "};"
	exit 0;
fi

>&2 printf "Error: %s: No such file\n" $PROGRAM
exit 127
