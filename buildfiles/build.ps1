nasm "../bootloader.asm" -f bin -o "../binaryfiles/bin1.bin"
nasm "../kernel.asm" -f bin -o "../binaryfiles/bin2.bin"
cmd /c copy /b bin1.bin + bin2.bin "../os.img"
qemu-system-i386 -hda "../os.img"