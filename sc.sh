#!/bin/bash
PROG="bin.macho"

av.str.1

objdump -d $PROG |
awk -v RS= "/^[[:xdigit:]]+ <_main>/" | 
tail -n +2 |
awk '{printf "0x%s, 0x%s, 0x%s, 0x%s\n", $2,$3,$4,$5}'
printf "\n"
objdump -d $PROG |
awk -v RS= "/^[[:xdigit:]]+ <sh>/" | 
tail -n +2 |
awk '{printf "0x%s, 0x%s, 0x%s, 0x%s\n", $2,$3,$4,$5}'
