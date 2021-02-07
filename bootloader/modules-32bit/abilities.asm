cpuid_ok:
	PUSH edx
	PUSHFD

	POP eax
	MOV edx, eax		; save a copy of the flags register
	XOR eax, 1 << 21

	PUSH eax			; put back in flags register and then put back in ecx register
	POPFD
	PUSHFD
	POP eax

	CMP eax, edx		; if bit did not set in flags then no cpuid
	JNE cpuid_ok.not_avail

	MOV eax, 1
	JMP cpuid_ok.exit

.not_avail:
	MOV eax, 0
.exit:
	PUSH edx
	POPFD
	POP edx

	RET

long_mode_ok:
	MOV eax, 0x80000000
	CPUID
	CMP eax, 0x80000001
	JB long_mode_ok.not_avail

	MOV eax, 0x80000001
	CPUID
	TEST edx, 1 << 29
	JZ long_mode_ok.not_avail

	MOV al, 1
.not_avail:
	MOV al, 0
.exit:
	RET