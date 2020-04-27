%include "modules-16bit/print.asm"

%define FAST_A20_PORT 0x92

%define PS2_STAT_CMD_PORT 0x64
%define PS2_DATA_PORT 0x60

; PS2 commands
%define PS2_DISABLE_CMD 0xAD
%define PS2_ENABLE_CMD 0xAE
%define PS2_READ_CMD 0xD0
%define PS2_WRITE_CMD 0xD1

enable_a20:				; enable a20, return 0 in ax register if error occurs
	PUSHF

	CALL a20_is_enabled
	CMP ax, 0x01
	JE exit

	CALL a20_enable_bios
	CMP ax, 0x01
	JE exit

	CALL a20_enable_keyboard
	CALL a20_is_enabled
	CMP ax, 0x01
	JE exit

	CALL a20_enable_fast
	CALL a20_is_enabled
	CMP ax, 0x01
	JE exit

	MOV si, A20_ERROR
	CALL print

.exit:
	POPF
	RET

a20_enable_fast:
	IN al, FAST_A20_PORT
	OR al, 0x02
	OUT FAST_A20_PORT, al

a20_enable_keyboard:
	CLI

	CALL a20_wait_command
	MOV al, PS2_DISABLE_CMD
	OUT PS2_STAT_CMD_PORT, al

	CALL a20_wait_command
	MOV al, PS2_READ_CMD
	OUT PS2_STAT_CMD_PORT, al

	CALL a20_wait_data
	IN al, PS2_DATA_PORT
	PUSH ax

	CALL a20_wait_command
	MOV al, PS2_WRITE_CMD
	OUT PS2_STAT_CMD_PORT, al

	CALL a20_wait_command
	POP ax
	OR al, 0x02
	OUT PS2_DATA_PORT, al

	CALL a20_wait_command
	MOV al, PS2_ENABLE_CMD
	OUT PS2_STAT_CMD_PORT, al

	CALL a20_wait_command

	STI
	RET

a20_wait_data:
	IN al, PS2_STAT_CMD_PORT
	TEST al, 0x01		; If first bit set, controller ready to get data
	JZ a20_wait_data
	RET

a20_wait_command:
	IN al, PS2_STAT_CMD_PORT
	TEST al, 0x02		; Second bit must be clear before writing data
	JNZ a20_wait_command
	RET

a20_enable_bios:		; try to set the a20 bit. ret 1 on success else 0 in ax register
	PUSHF
	MOV ax, 0x2401
  	INT 0x15
	
	MOV ax, 0			
	JC exit				; carry flag set if there is error

	MOV ax, 0x01
.exit:
	POPF
	RET

a20_is_enabled:
check_a20:
	PUSHF
	PUSH es
	PUSH ds
	PUSH si
	PUSH di
	
	XOR ax, ax
	MOV ds, ax
	MOV di, ax

	MOV ax, 0xFFFF
	MOV es, ax
	MOV si, 0x0010

	MOV BYTE al, [ds:di]
	PUSH ax

	MOV BYTE al, [es:si]
	PUSH ax

	MOV BYTE [ds:di], 0x00
	MOV BYTE [es:si], 0xFF

	CMP BYTE [ds:di], 0xFF

	POP ax
	MOV BYTE [es:si], al

	POP ax
	MOV BYTE [ds:di], al

	MOV ax, 0		; A20 is not enabled
	je exit

	MOV ax, 0x01	; A20 already enabled
exit:
	POP di
	POP si
	POP ds
	POP es
	POPF
	RET

	A20_ERROR DB 'Unable To Enable The A20 Line', 13, 0