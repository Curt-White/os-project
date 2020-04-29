build: main.c kernel.asm
	nasm -f elf64 kernel.asm -o setup.o
	gcc -m64 -c main.c -o main.o
	ld -m elf32_x86_64 -T kernel.ld -o kernel main.o setup.o