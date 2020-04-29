build: clean ./loaders/mbr.asm ./loaders/vbr.asm
	mkdir ./bin
	nasm -f bin -o ./bin/mbr.bin ./loaders/mbr.asm
	nasm -f bin -o ./bin/vbr.bin ./loaders/vbr.asm

clean:
	rm -rf bin $(wildcard ./bin/*.bin) drive.img