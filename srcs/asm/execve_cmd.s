    .align 4
    .global _main
    .text
_main:
    mov		x0, 0x622F           
    movk	x0, 0x6E69, lsl 16
    movk	x0, 0x732F, lsl 32
    movk	x0, 0x68, lsl #48 
    str		x0, [sp, -64]!
    mov		x0, sp
    mov		x1, 0x632D
    str		x1, [sp, 16]
    add		x1, sp, 16
    adr		x2, cmd 
    stp		x0, x1,  [sp, 32]
    stp		x2, xzr, [sp, 48]
    mov		x2, xzr	
    add		x1, sp, 32
    mov		x16, #59
    svc		#0

cmd:
    .asciz "(hostname > /dev/stdout) | cat -e"

