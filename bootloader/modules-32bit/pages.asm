init_pages:
	MOV edi, 0x1000			; start the tables at this mem location
	MOV cr3, edi			; cr3 reg holds the location of page tables

	XOR eax, eax
	MOV ecx, 4096
	REP STOSD				; set the next 4096 bytes to 0

	MOV edi, cr3			; set the location back to the start of table

							; 3 at end bc page table entries have read, write, and present flags
	MOV DWORD [edi], 0x2003	; in PML4T set the location of the PDPT table
	ADD edi, 0x1000
	MOV DWORD [edi], 0x3003 ; in PDPT set first entry to a PDT table
	ADD edi, 0x1000
	MOV DWORD [edi], 0x4003 ; in PDT table set first entry to a PT table 
	ADD edi, 0x1000			; now edi is at start of PT table

	MOV ebx, 0x00000003		; offset to use so that all entries have read, write, and present flags set
	MOV ecx, 512			; 512 entries in the PT table

.make_entry:				; initialize an entire PT table mapped 1-1 to first 2mb of memory
	MOV DWORD [edi], ebx
	ADD ebx, 0x1000
	ADD edi, 8
	LOOP init_pages.make_entry

.enable_paging:				; enable the pagin bit in control register 4
	MOV eax, cr4
	OR eax, 1 << 5
	MOV cr4, eax


	RET