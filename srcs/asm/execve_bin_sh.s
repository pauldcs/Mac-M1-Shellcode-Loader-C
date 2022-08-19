    .global _main
    .align	2
	.text

_main:
    adr    x0, sh 
    mov    x1, xzr
    mov    x2, xzr
    mov    x16, #59 
    svc    0
sh:    
    .ascii "/bin/sh\0"
