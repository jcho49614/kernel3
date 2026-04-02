;im not going to include org 0x7c00 because i wanna try the pointer thing

;used shit:
;ax: not used (used for setting ds)
;bx: not used
;cx: not used
;ds: used, 0x7c0
;si: used, whatever string


org 0 				;i commit to segment math
xor ax, ax
mov ax, 0x7c0
mov ds, ax			;i kinda dont wanna do this its going to be confusing
xor ax, ax
;finished intialization, now onto printing

mov ah, 0x0e

mov bx, 0x1234

mov si, the_secret
call newline
call print_loop

mov si, the_second_secret
call newline
call print_loop

mov si, the_third_secret
call newline
call print_loop

mov si, msg
call newline
call print_loop

call newline
call print_hex_code

mov bx, 0x5678

call newline
call print_hex_code

mov bx, 0x9ABC
call newline
call print_hex_code
;the fuck it works

the_secret: db 'This is the secret.' ,0

the_second_secret: db 'This is the new secret.' ,0

the_third_secret: db 'Hello world!' ,0

msg db 'testing the message method' ,0

print_loop:
	;REQUIREMENTS:
	;this requires SI for string. Nothing else, really

	pusha
	loop:
		mov al, [si]
		cmp al, 0
		je done

		mov ah, 0x0e	;will work! 0x7c0 as ds will probably make it okay
		int 0x10
		inc si
		jmp loop

	done:
	popa
	ret


print_hex_code:
	;REQUIREMENTS:
	;this requires ax and bx. bx is the true input, ax is the general purpose
	

	;this is gong to take forever
	;currently we're going to dedicate bx for hexcode.
	push bx

	;js something stupid to make like 0x
	push si
	mov si, print_0x
	call print_loop
	pop si
	;lesgoooo it works

	mov al, bh
	call print_hex_byte
	
	push ax
	mov ah, 0x0e
	mov al, ' '
	int 0x10
	pop ax
	
	;again something stupid
	push si
	mov si, print_0x
	call print_loop
	pop si

	mov al, bl
	call print_hex_byte
	pop bx
	ret

print_hex_byte:
	push ax

	shr al, 4
	call print_digit

	pop ax
	push ax
	and al, 0x0f
	call print_digit
	pop ax
	ret


print_digit:
	cmp al, 9
	jbe d
	add al, 7
d:
	add al, '0'
	mov ah, 0x0e
	int 0x10
	ret

print_0x:
	db '0x',0


newline:
	mov ah, 0x0e	;parantly need to do for all of it
	mov al, 0x0d
	int 0x10

	mov al, 0x0a
	int 0x10

	ret


times 510-($-$$) db 0
dw 0xaa55