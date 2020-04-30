%define PRIM_ATA_IO_BASE_PORT 0x01F0
%define ATA_READ_CMD 0x20

disk_read:
	PUSHFQ
	AND rax, 0x0FFFFFFF
	PUSH rax
	PUSH rbx
	PUSH rcx
	PUSH rdx
	PUSH rdi

	MOV rbx, rax

	MOV edx, PRIM_ATA_IO_BASE_PORT + 6	; Load port = Drive/Head register
	SHR eax, 24							; bits 0-3 contain LBA address bits 24-27
	OR al, 0b10100000					; these bits are always set
	OR al, 0b01000000					; set the bit to use LBA instead of CHS
	OUT dx, al

	MOV edx, PRIM_ATA_IO_BASE_PORT + 2 	; load port = sector count
	MOV al, cl
	OUT dx, al

	MOV edx, PRIM_ATA_IO_BASE_PORT + 3	; bits 0-7 of the LBA
	MOV eax, ebx
	OUT dx, al

	MOV edx, PRIM_ATA_IO_BASE_PORT + 4	; bits 8-15 of the LBA
	MOV eax, ebx
	SHR eax, 8
	OUT dx, al

	MOV edx, PRIM_ATA_IO_BASE_PORT + 5	; bits 16-23 of the LBA
	MOV eax, ebx
	SHR eax, 16
	OUT dx, al

	MOV edx, PRIM_ATA_IO_BASE_PORT + 7	; command port
	MOV al, ATA_READ_CMD
	OUT dx, al

.poll:
	IN al, dx							; status register
	TEST al, 0x08
	JZ disk_read.poll

	MOV rax, 256						; one block, 512 bytes (256 words)
	XOR bx, bx
	MOV bl, cl
	MUL bx								; rax (size of sector) * cl (number of sectors)

	MOV rcx, rax
	MOV rdx, PRIM_ATA_IO_BASE_PORT
	REP INSW

	POP rdi
	POP rdx
	POP rcx
	POP rbx
	POP rax
	POPFQ


	RET

