$rootDir = (Get-Item "..").FullName

nasm -i "$rootDir/" "../bootloader.asm" -f bin -o "../binaryfiles/bin1.bin"

nasm -i "$rootDir/" "../kernel.asm" -f bin -o "../binaryfiles/bin2.bin"

cmd /c "copy /b ..\binaryfiles\bin1.bin + ..\binaryfiles\bin2.bin ..\os.img"

qemu-system-i386 -hda "../os.img"