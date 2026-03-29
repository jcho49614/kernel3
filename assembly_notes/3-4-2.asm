; this utilizes definitions by labels?
; the label is going to be "the_secret" with the value of "x".
; i also unintentially learned how to use orgs (default to 0x7c00), xor (initalizing), and ds shit too.


org 0x7c00
xor ax, ax		;ax = 0 initialization
mov ds, ax		;ds = 0 initialization

mov ah, 0x0e 	;scrolling teletype BIOS routine, "print character"

; method 1 to the madness: call the_secret by []

mov al, [the_secret]
int 0x10

mov al, [the_string]
int 0x10

mov al, 0x0D	;cursor to start of line
int 0x10
mov al, 0x0A	;new line
int 0x10


main:
	mov si, the_string	;moving the pointer to the string in memory to SI
	jmp string_loop

	second_main:

		mov si, the_second_string
		jmp second_string_loop

string_loop:
	mov al, [si]		;starting off strong, "al" is letter
	cmp al, 0 			; check if it's a 0
	je second_main				; go to done if equal

	int 0x10			; print if not
	inc si    			; increment si pointer to 1 value
	jmp string_loop 	; go back again

second_string_loop:
	mov al, [si]		;starting off strong, "al" is letter
	cmp al, 0 			; check if it's a 0
	je finally_done				; go to done if equal

	int 0x10			; print if not
	inc si    			; increment si pointer to 1 value
	jmp second_string_loop	; go back again


finally_done:
	jmp $

;only define things AFTER working code.

the_secret:		; this is the label
	db "x"		; "define byte" to "x". Just assigning "the_secret" to "x".

the_string:
	db 'Booting OS' ,0   ;this will only print 1 character.

the_second_string:
	db 'Holy shit it works' ,0 ;new string

times 510-($-$$) db 0
dw 0xaa55