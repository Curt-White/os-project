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
	JMP to_long_mode

[bits 32]
%include "modules-32bit/abilities.asm"
%include "modules-32bit/pages.asm"

to_long_mode:
	CALL cpuid_ok
	CALL long_mode_ok
	CALL init_pages

NO_CPUID_ERROR DB 10, 'CPUID is not available', 13, 0
JMP $