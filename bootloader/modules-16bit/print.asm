%ifndef LIB_PRINT
%define LIB_PRINT

print:
	mov ah, 0Eh         ;Set function

.run:
	lodsb               ;Get the char
	cmp al, 0x00           ;0 has a HEX code of 0x48 so its not 0x00
	je .done            ;Jump to done if ending code is found
	int 10h             ;Else print
	jmp .run            ; and jump back to .run

.done:
	ret                 ;Return

print_hex:
  PUSHF
  PUSH si
  PUSH cx
  PUSH bx
  PUSH dx

  MOV cl, 12
  MOV bx, HEX_OUT
  ADD bx, 3
hex_loop:
  MOV dx, ax
  SHR dx, cl
  AND dx, 0x0F
  ADD dx, "0"
  CMP dx, "9"
  JNG hex_is_num
  ADD dx, 7

hex_is_num:
  MOV [bx], dx
  INC bx
  SUB cl, 4
  JNB hex_loop

  MOV si, HEX_OUT
  CALL print

  POP dx
  POP bx
  POP cx
  POP si
  POPF

  RET

HEX_OUT: db 10, '0x0000', 13, 0

%endif