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