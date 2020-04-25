[bits 16]
[org 0x7C00]

%include "modules-16bit/print.asm"
%include "modules-16bit/idt_gdt.asm"
%include "modules-16bit/a20.asm"

start:
	set_gdt
	set_idt

	PUSH ax
	CALL a20_is_enabled
	POP ax

; to_protected:
	CLI
	MOV eax, cr0
	OR eax, 1
	MOV cr0, eax
	STI

	JMP clear_prefetch_queue
    NOP
    NOP

clear_prefetch_queue:

[bits 32]
JMP $
