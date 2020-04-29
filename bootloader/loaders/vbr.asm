[bits 16]
[org 0x7C00]

imports:
	JMP start

	%include "modules-16bit/print.asm"
	%include "modules-16bit/idt_gdt.asm"
	%include "modules-16bit/a20.asm"

start:
	CLI
	set_gdt
	set_idt

	MOV ax, 0x3
	INT 0x10

	PUSH ax
	CALL a20_is_enabled
	POP ax

to_protected:
	MOV eax, cr0
	OR eax, 1
	MOV cr0, eax

	JMP clear_prefetch_queue
    NOP
    NOP

clear_prefetch_queue:
	JMP 0x8:to_long_mode

[bits 32]
	%include "modules-32bit/abilities.asm"
	%include "modules-32bit/pages.asm"
	%include "modules-32bit/gdt_64.asm"
to_long_mode:
	CALL cpuid_ok
	CALL long_mode_ok
	CALL init_pages

.enable_long_mode:
	MOV ecx, 0xC0000080
	RDMSR
	OR eax, 1 << 8
	WRMSR

	CALL enable_paging
	CALL enter_long

[bits 64]
	%include "modules-64bit/disk.asm"
load_kernel:
	MOV ax, gdt_64.data
    MOV ds, ax
    MOV es, ax
    MOV fs, ax
    MOV gs, ax
	
	; MOV rax, 0x2f592f412f4b2f4f
    ; MOV qword [0xb8000], rax
    ; HLT

	MOV eax, 0x05
	MOV cl, 1
	MOV rdi, 0x100000
	CALL disk_read

	JMP 0x100000
	NO_CPUID_ERROR DB 10, 'CPUID is not available', 13, 0