%macro set_gdt 0
	lgdt [GDT_POINTER]
%endmacro

%macro set_idt 0
	lidt [IDT_POINTER]
%endmacro

GDT_POINTER:
	DW gdt_end - gdt_start - 1
	DD gdt_start

IDT_POINTER:
	DW 2048			; size of the interrupt table
	DD 0			; location of interrupt table	 

gdt_start:
.null:
	DQ 0			; null gdt entry
.code:
	DW 0xFFFF 		; lower limit addr
	DW 0x0000		; lower base addr
	DB 0x00			; middle base addr
	DB 0x9A			; access byte
	DB 0xCF			; first half flags second upper limit addr
	DB 0x00			; upper base addr
.data:
	DW 0xFFFF 		; lower limit addr
	DW 0x0000		; lower base addr
	DB 0x00			; middle base addr
	DB 0x92			; access byte
	DB 0xCF			; first half flags second upper limit addr
	DB 0x00			; upper base addr
gdt_end: