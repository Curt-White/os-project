run: build
	qemu-system-x86_64 -drive format=raw,file=drive.img

bochs: build
	rm -rf drive.img.locks
	bochs -q

subdir:
	cd ./bootloader $(MAKE)
	cd ./kernel $(MAKE)

build: subdir
	dd if=/dev/zero of=drive.img bs=512 count=200
	dd if=./bootloader/bin/mbr.bin of=drive.img seek=0 count=1 conv=notrunc
	dd if=./bootloader/bin/vbr.bin of=drive.img seek=1 count=2 conv=notrunc
	dd if=./kernel/kernel of=../drive.img seek=5 count=1 conv=notrunc