run: build
	qemu-system-i386 -drive format=raw,file=drive.img

debug: build
	qemu-system-i386 -drive format=raw,file=drive.img -d cpu_reset -D ./qemu.log -no-reboot

clean:
	rm -rf bin $(wildcard ./bin/*.bin) drive.img

build: clean ./loaders/mbr.asm ./loaders/vbr.asm
	mkdir ./bin
	nasm -f bin -o ./bin/mbr.bin ./loaders/mbr.asm
	nasm -f bin -o ./bin/vbr.bin ./loaders/vbr.asm

	dd if=/dev/zero of=drive.img bs=1024 count=1440
	dd if=./bin/mbr.bin of=drive.img seek=0 count=1 conv=notrunc
	dd if=./bin/vbr.bin of=drive.img seek=1 count=1 conv=notrunc