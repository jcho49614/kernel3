[bits 16]
[org 0x8000]

jmp main


%include "gdt.asm"

switch_to_32_bit:
	cli						;turn off interrupts
	lgdt [gdt_descriptor]
	
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:init_pm

;32bit mode holy
[bits 32]

VIDEO_MEMORY equ 0xb8000
BEIGEONBLACK equ 0x70

init_pm:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, 0x90000
	mov esp, ebp
	call clear_screen_32
	
	call BEGIN_PM
	
print_string_protectedmode:
    pushad
    mov edx, VIDEO_MEMORY
    
.loop:
    mov al, [ebx]
    cmp al, 0
    je .done
    
    mov ah, BEIGEONBLACK
    mov [edx], ax
    
    inc ebx
    add edx, 2
    jmp .loop
    
.done:
    popad
    ret
	
clear_screen_32:
    pusha
    mov edx, 0xb8000
    mov ecx, 80 * 25    ; 80 columns x 25 rows
    mov ax, 0x0720      ; Space character with white on black
    
.clear_loop:
    mov [edx], ax
    add edx, 2
    loop .clear_loop
    
    popa
    ret

BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_protectedmode
	
	jmp $
	
MSG_REAL_MODE: db "Started in 16-bit Real Mode" ,0
MSG_PROT_MODE: db "32-BIT PROT MODE" ,0	

[bits 16]
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
		

	

	
msg: db 'ENTERED KERNEL' ,0
commandpromptstart: db 'SHELL16>> ' ,0

switch_flag: db 0   ;this is for switch to 32bit
times 1536-($-$$) db 0