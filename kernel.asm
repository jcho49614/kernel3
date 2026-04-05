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
	
	;shitton of "introductory phrases here"
	mov si, msg				;"entered kernel"
	call print_string
	call newline
	call print_ram			;"Ram amount"
	call print_himem		;"Is there himem?"
	call print_ascii		;"OS3 ASCII code"
	call os3_info			;"os3 information"
	
	.printloop:
		mov si, commandpromptstart
		call print_string
		mov si, input_buffer			;now will read in input buffer
		call read_string
		call process_output
		call newline
		jmp .printloop
	
	jmp $
	
msg: db 'ENTERED KERNEL' ,0
commandpromptstart: db 'SHELL16>> ' ,0

times 1536-($-$$) db 0