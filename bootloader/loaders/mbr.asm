[bits 16]
[org 0x0600]

%define PTBL_LEN 4

setup:
	CLI					; Disable Interrupts
	XOR ax, ax			; init segment registers
	MOV es, ax
	MOV ds, ax
	MOV ss, ax
	MOV sp, 0x7C00

	MOV cx, 128
	MOV si, 0x7C00		; current location of MBR
	MOV di, 0x0600		; new location of MBR
	CLD 				; clear so string copied from low to high address
	REP movsd
	STI

	JMP 0x0000:check
check:	
	MOV BYTE [DRIVEID], dl	; Save the drive id from dl register
	MOV cx, PTBL_LEN
	MOV bx, DSKPRT1

check_loop:
	CMP BYTE [bx], 0x80		; check if the active partition bit is set
	JZ load
	ADD bx, 0x10
	DEC cx
	JNZ check_loop
failed:
	MOV si, FAILED
	CALL print
poll_restart:
	MOV si, PRSSKEY
	CALL print

	MOV ah, 0
	INT 0x16
	CMP al, 0x00		; check if a key was pressed
	JZ end
restart:
	DB 0x00EA 			; form restart instruction
    DW 0x0000 
    DW 0xFFFF 
load:
	MOV [ACTIVPT], WORD bx 

	MOV ah, 0x00			; reset the disk system
	INT 0x13
	CMP al, 0x00
	JNZ error

	MOV ah, 0x02	; function number, read sectors
	MOV al, 0x02	; number of sectors to read
	MOV ch, 0x00	; cylinder number
	MOV dh, 0x00	; read/write head number
	MOV cl, 0x02	; sector
	MOV bx, 0x7C00 	; where to load into mem
	MOV BYTE dl, [DRIVEID]
	INT 0x13

	JC error	; cary flag is set if disk error
	JMP 0x0000:0x7C00
	JMP end
error:
	MOV si, DISKERR
	CALL print
	JMP poll_restart

end:
	%include "modules-16bit/print.asm"

	SUCCESS DB 10, 'This Has Succeeded', 13, 0
	FAILED 	DB 10, 'No Active Partitions Available', 13, 0
	DISKERR DB 10, 'A Disk Error Occured', 13, 0
	PRSSKEY DB 10, 'Press Any Key To Restart', 13, 0
	DRIVEID DB 0
	ACTIVPT DB 0 

	times 440-($-$$) DB 0	; Pad remainder of boot sector with 0s
	
	DISKSIG DD 0
	RESERVD DW 0

	DSKPRT1 DB 0x80
			times 15 DB 0 ; DONT FORGET TO CHANGE THIS BACK TO OTHER FORMAT
	DSKPRT2 times 16 DB 0
	DSKPRT3 times 16 DB 0
	DSKPRT4 times 16 DB 0

	dw 0xAA55		; The standard PC boot signature
