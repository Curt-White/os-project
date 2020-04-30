gdt_64:                 
.null: equ $ - gdt_64
    DW 0xFFFF           
    DW 0                
    DB 0                
    DB 0                
    DB 1                
    DB 0                
.code: equ $ - gdt_64
    DW 0                
    DW 0                
    DB 0                
    DB 10011010b        
    DB 10101111b        
    DB 0                
.data: equ $ - gdt_64
    DW 0                
    DW 0                
    DB 0                
    DB 10010010b        
    DB 00000000b        
    DB 0                
.pointer:           
    DW $ - gdt_64 - 1    
    DQ gdt_64            