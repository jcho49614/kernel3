[bits 16]				;force it to 16bit mode
[org 0x7c00]			;organize to 0x7c00 so no segemnt math


;whole bunch of initialization
cli
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00
sti

mov [boot_drive], dl

mov ax, 0003h
int 10h							;resets the display

jmp load_kernel

%include "bootloaderlibrary.asm"		;plan optimization later, 512kbs might require a different standardlibrary

load_kernel:
	mov ah, 0x02				;read mode
	mov al, 3				;2 sectors for kernel
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, [boot_drive]		;whatever drive I set it up as
	mov bx, 0x8000
	int 0x13
	jc disk_error
	
	mov si, ok_msg
	call print_string
	call newline
	
	jmp 0x8000			;jump to kernel now. kernel.asm located on 0x8000
	
disk_error:
	;i wanna make a "error code disk hang" error but I need prints
	pusha
	mov si, err_msg
	call print_string
	call newline
	popa
	jmp $
	
ok_msg: db 'DISK LOAD OK' ,0
err_msg: db 'DISK LOAD ERROR' ,0
boot_drive: db 0

;basic neccessities



times 510-($-$$) db 0
dw 0xaa55