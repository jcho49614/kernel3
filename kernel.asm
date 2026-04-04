[bits 16]
[org 0x8000]

jmp main

%include "standardlibrary.asm"

main:
	;js some stupid intialization
	mov ax, 0x0000
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00
	mov si, msg
	call print_string
	call newline
	
	call print_ram
	
	call print_ascii
	
	call read_string
	
	jmp $
	
msg: db 'ENTERED KERNEL' ,0

times 512-($-$$) db 0