run: local
	qemu-system-x86_64 -drive format=raw,file=drive.img -D ./qemu.log -d cpu_reset

local:
	docker stop cmp || true && docker rm cmp || true
	docker build -t compilable .
	docker run -d --name cmp compilable:latest
	docker cp cmp:/src/drive.img drive.img
	docker stop cmp

bochs: local
	rm -rf drive.img.locks
	bochs

clean:
	$(MAKE) -C ./bootloader clean 
	$(MAKE) -C ./kernel clean 
	rm -rf drive.img

subdir:
	$(MAKE) -C ./bootloader build 
	$(MAKE) -C ./kernel build 

build: subdir
	dd if=/dev/zero of=drive.img bs=512 count=200
	dd if=./bootloader/bin/mbr.bin of=drive.img seek=0 count=1 conv=notrunc
	dd if=./bootloader/bin/vbr.bin of=drive.img seek=1 count=2 conv=notrunc
	dd if=./kernel/kernel of=drive.img seek=5 count=1 conv=notrunc