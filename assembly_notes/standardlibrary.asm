;I'm not going to even touch segment manipulation
;this is only going to have the bare minimum printing functions
;nothing else



;FUNCTION NUMBER 1: PRINT FUNCTION
;required registers: si, ax (will be pushed so not really)
;prints any string given

print_string:
	pusha					;push everything for safety
	mov ah, 0x0e			;teletype
	loop:
		mov al, [si]		;first byte
		cmp al, 0			;check if null
		je stop_printing	;stop printing if null
		int 0x10			;interrupt 0x10
		inc si
		jmp loop
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