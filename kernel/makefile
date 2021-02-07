export CC := g++
export CPPFLAGS := -std=gnu++2a -nostdlib -ffreestanding -march=x86-64 -Wall -Werror -pedantic-errors
export CPPFLAGS_NL := $(CPPFLAGS) -c

LFLAGS := -Ttext 0x100000 --oformat binary
NASM_FLAGS := -f elf64

LIBDIR := ./lib
LIBS :=

LIB_PATHS := $(addprefix $(LIBDIR)/, ${LIBS})

.PHONY: all $(LIB_PATHS) 
all: link

asm: kernel.asm
	nasm -f elf64 kernel.asm -o entry.o

$(LIB_PATHS):
	$(MAKE) --directory=$@	

link: asm $(LIB_PATHS)
	$(CC) $(CPPFLAGS_NL) main.cpp -o main.o
	ld $(LFLAGS) -T kernel.ld -o kernel entry.o main.o $(foreach lib, $(LIB_PATHS), $(lib)/$(notdir $(lib)).o)

clean:
	rm -rf *.o
