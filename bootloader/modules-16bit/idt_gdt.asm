
%macro set_gdt 0
	lgdt [gdt_pointer]
%endmacro

%macro set_idt 0
	lidt [idt]
%endmacro

gdt_pointer:
	DW gdt_end - gdt - 1
	DD gdt

idt:
	DW 2048			; size of the interrupt table
	DD 0			; location of interrupt table	 

gdt:
.null:
	DQ 0			; null gdt entry
.code:
	DW 0xFFFF 		; lower limit addr
	DW 0x0000		; lower base addr
	DB 0x00			; middle base addr
	DB 0b10011010	; access byte
	DB 0b11001111	; first half flags second upper limit addr
	DW 0x0000		; upper base addr
.data:
	DW 0xFFFF 		; lower limit addr
	DW 0x0000		; lower base addr
	DB 0x00			; middle base addr
	DB 0b10010010	; access byte
	DB 0b11001111	; first half flags second upper limit addr
	DW 0x0000		; upper base addr
gdt_end: