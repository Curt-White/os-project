build: main.c kernel.asm
	nasm -f elf64 kernel.asm -o setup.o
	gcc -ffreestanding -march=x86-64  -c main.c -o main.o
	ld -Ttext 0x100000 --oformat binary -T kernel.ld -o kernel setup.o main.o

clean:
	rm -rf *.o