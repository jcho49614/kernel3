org 0x7c00

cli
xor ax, ax
mov ss, ax
mov sp, 0x7c00
sti

mov ax, cs
mov ds, ax
mov es, ax

%include "standardlibrary.asm"

mov si, msg1
call print_string
call newline

mov si, msg2
call print_string
call newline

mov bx, 0x1234
call print_hex
call newspace

mov bx, 0x5678
call print_hex
call newspace

mov bx, 0x9abc
call print_hex
call newspace


;---------------------------------
msg1: db 'hello, world!' ,0
msg2: db 'testing the print function' ,0

times 510-($-$$) db 0
dw 0xaa55