;I'm not going to even touch segment manipulation
;this is only going to have the bare minimum printing functions
;nothing else

%include "16bitcommands.asm"

;FUNCTION NUMBER 1: PRINT FUNCTION
;required registers: si, ax (will be pushed so not really)
;prints any string given


print_string:
	pusha					;push everything for safety
	mov ah, 0x0e			;teletype
	print_loop:
		mov al, [si]		;first byte
		cmp al, 0			;check if null
		je stop_printing	;stop printing if null
		int 0x10			;interrupt 0x10
		inc si
		jmp print_loop
	stop_printing: 
		popa
		ret		;just return if stop printing
	

;FUNCTION NUMBER 2: PRINT HEX FUNCTION
;required registers: ax, bx
;prints any hexcode in byte size

print_hex:
	push bx 				;save original bx FUNCTION
	push si					;just for "0x"
	mov si, hex_prfx
	call print_string
	pop si
	
	mov al, bh				;higher byte
	call print_hex_byte		;call print byte
	
;	push si
;	mov si, hex_prfx		;just print 0x again
;	call print_string
;	pop si
	
	mov al, bl				;lower byte
	call print_hex_byte		;call print byte
	pop bx
	ret
	
hex_prfx:
	db '0x' ,0				;temporary message

print_hex_byte:
	push ax					;put ax in stack
	shr al, 4				;upper nibble downwards
	call print_hex_digit		;print digit
	pop ax					;give original value back
	push ax					;save og value again
	and al, 0x0f			;remove upper nibble completely
	call print_hex_digit		;call print digit
	pop ax					;return ax back to nomral
	ret						;return
	
print_hex_digit:
	;the nibble is in al.
	cmp al, 9				;compare 0-9, A-F
	jbe d
	add al, 7				;this is just for converting letter to letter
d:
	add al, '0'				;makes digits to their characters
	mov ah, 0x0e
	int 0x10
	ret
	
	
	
;FUNCTION 3: Newline. Uses ax.

newline:
	push ax

	mov ah, 0x0e	;parantly need to do for all of it
	mov al, 0x0d
	int 0x10

	mov al, 0x0a
	int 0x10
	
	pop ax
	ret
	
newspace:
	push ax
	mov ah, 0x0e
	mov al, ' '
	int 0x10
	pop ax
	ret
	
	

;Function 4: fricking reading char.

read_char:
	mov ah, 0x00		;wait for keypress
	; the alternatives are:
	; 0x01: check if key is pressed, 0x02: get shift/ctrl/alt status
	int 0x16
	ret
	
read_string:
	push cx
	push si
	xor cx, cx			;make cx 0
	.loop:
		call read_char
		cmp al, 0x0d	;enter key
		je .done
		cmp al, 0x08	;backspace
		je .backspace
		
		mov [si], al	;add al to si
		inc si			;fucking genius way of getting si to push back
		inc cx			;increase count
		mov ah, 0x0e	;echo al
		int 0x10
		jmp .loop
	
	.backspace:
		cmp cx, 0
		je .loop
		dec si			;decrease si
		dec cx			;decrease cx
		mov ah, 0x0e	;teletype mode
		mov al, 0x08	;delete
		int 0x10		
		mov al, ' '		;overwrite with space
		int 0x10
		mov al, 0x08	;go back fucking again
		int 0x10
		jmp .loop
		
	.done:
		mov cx, 0
		mov byte [si], 0
		call newline
		pop si
		pop cx
		ret
		
		
;function 5 i think just printing cool ascii

print_ascii:
	mov si, ascii1
	call print_string
	call newline
	mov si, ascii2
	call print_string
	call newline
	mov si, ascii3
	call print_string
	call newline
	mov si, ascii4
	call print_string
	call newline
	ret

ascii1: db '  ____   ____ _____ ' ,0
ascii2: db ' / __ \ / ___|___ / ' ,0
ascii3: db '| |  | |\___ \ |_ \ ' ,0
ascii4: db ' \____/ |____/___/' ,0


print_ram:
	pusha
	int 0x12						;interrupt 0x12 gives conventional memory count
	call print_base10				;it just moves to ax for some reason
	
	mov si, ram1
	call print_string
	call newline
	popa
	ret
	
ram1: db 'KB RAM OK' ,0

print_base10:
	;this is like stressful to implmement
	;ax = answer, dx = remainder, bx = divisor
	pusha
	xor dx, dx			;zero out the remainder
	mov cx, dx
	mov bx, 10			;number to divide by
	.loop:
		xor dx, dx		;constant initialization
		div bx			;check if ax is zero
		cmp ax, 0		;if ax is zero, we jmp to something
		inc cx
		add dx, '0'
		push dx
		cmp ax, 0
		je .print
		jmp .loop
	.print:
		pop dx				;pop a digit
		mov al, dl			;mov to al
		mov ah, 0x0e		;teletype
		int 0x10
		loop .print			;keep looping until cx runs out
		
	;im going to check for himem cuz why the fuck not
	;int 0x15	
	popa
	ret
	
print_himem:
	pusha
	mov ah, 0x88
	int 0x15
	cmp ax, 0
	jg .himem
	
	mov si, himemmessage2
	call print_string
	call newline
	
	jmp .end
	
	.himem:
		mov si, himemmessage1
		call print_string
		call newline
		
	.end:
		popa
		ret
			
himemmessage1: db 'HIMEM: DETECTED' ,0
himemmessage2: db 'HIMEM: UNDETECTED' ,0	

os3_info:
	pusha
	mov si, infomessage0
	call print_string
	call newline
	mov si, infomessage1
	call print_string
	call newline
	mov si, infomessage2
	call print_string
	call newline
	mov si, infomessage3
	call print_string
	call newline
	mov si, infomessage4
	call print_string
	call newline
	popa
	ret

infomessage0: db '****************************************************************************' ,0
infomessage1: db '| OS3 v0.0.1 Dev Beta                                                      |' ,0
infomessage2: db '| A 16/32bit operating system by jcho49614                                 |' ,0
infomessage3: db '| Visit https://github.com/jcho49614/kernel3 for more details and updates. |' ,0
infomessage4: db '****************************************************************************' ,0

;COMMAND INPUT
;FORMAT: WORD1
;THAT IS ALWAYS THE FORMAT
;THERE CANNOT BE MORE

;LIST OF COMMANDS:
;OS3: Enters 32bit Real mode
;Debug: prints the entirety of debug logs
;Shutdown: shutdowns the 16bit mode

process_output:
	;first read the value on input_buffer
	;then match it to di.
	
	mov si, input_buffer
	
	;COMMAND 1: "os3"
	mov di, os3_command
	call strcmp
	jc .is_os3
	
	mov di, debug_command
	call strcmp
	jc .is_debug
	
	mov di, shutdown_command
	call strcmp
	jc .is_shutdown
	
	call function_nothing_16
	ret

	.is_os3:
		call function_os3_16
		ret
	.is_debug:
		call function_debug_16
		ret
	.is_shutdown:
		call function_shutdown_16
		ret
		

strcmp:
	push si
	push di
	push ax
	push bx
	
	.loop:
		mov al, [si]
		mov bl, [di]
		cmp al, bl
		jne .not_equal
	
		cmp al, 0
		je .equal						;its "done" and flag stays 0. That means its the command
		
		inc si
		inc di
		jmp .loop
		
		.not_equal:
			clc							;clear carry flag
			jmp .done
			
		.equal:
			stc							;set carry flag
		
		.done:
			pop bx
			pop ax
			pop di
			pop si
			ret
			
input_buffer: times 64 db 0				;always should be at the end, this is input buffer