org 0x7c00

cli
xor ax, ax
mov ss, ax
mov sp, 0x7c00
sti

mov ax, cs
mov ds, ax
mov es, ax

jmp main

;-----------------------------------------
;just some libraries
%include "standardlibrary.asm"
msg1: db 'hello, world!' ,0
msg2: db 'testing the print function' ,0
;-----------------------------------------

main:
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
	
	jmp $


;---------------------------------

times 510-($-$$) db 0
dw 0xaa55