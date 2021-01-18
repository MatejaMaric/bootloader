boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin
all: boot.bin
	truncate boot.bin -s 1200k
	mkisofs -o boot.iso -b boot.bin ./
	dd if=boot.bin of=boot.flp bs=512 count=2880
clean:
	rm boot.bin 
	rm boot.iso
	rm boot.flp
run: boot.bin
	qemu-system-x86_64 boot.bin
