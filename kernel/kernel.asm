[bits 64]

section .text
	align 4						; multiboot header
	dd 0x1BADB002            	; magic
	dd 0x00                  	; flags
	dd - (0x1BADB002 + 0x00)	; chksum	

	global start
	extern main

start:
	CLI
	MOV esp, stack_start
	CALL main
	HLT

section .bss
	resb 8192
stack_start: