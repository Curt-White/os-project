build: clean ./loaders/mbr.asm ./loaders/vbr.asm
	mkdir ./bin
	nasm -f bin -o ./bin/mbr.bin ./loaders/mbr.asm
	nasm -f bin -o ./bin/vbr.bin ./loaders/vbr.asm

clean:
	rm -rf bin $(wildcard ./bin/*.bin) drive.img

bochs: load
	rm -rf drive.img.locks && bochs -q

run: load
	qemu-system-x86_64 -drive format=raw,file=drive.img -D qemu.log -d cpu_reset

load: build
	dd if=/dev/zero of=drive.img bs=512 count=200
	dd if=./bin/mbr.bin of=drive.img seek=0 count=1 conv=notrunc
	dd if=./bin/vbr.bin of=drive.img seek=1 count=2 conv=notrunc