org 0x7c00	;set calc normal
xor ax, ax 	;init
mov ds, ax 	;init
mov bp, 0x8000 	;base of stack a little above where BIOS loads boot sector, so it won't overwrite shit
mov sp, bp 		;boot sector so it won't overwrite

push 'A'
push 'B'
push 'C'	;this prints.

mov ah, 0x0e ;SET ax TO TELETYPE!

pop bx		;pop 16 bits, so pop to bx whole thing
mov al, bl	;move 8 bit char here
int 0x10	;print al

;also cx is a loop counter for some reason

loop:
	pop bx
	cmp bx, 0
	je done

	mov ah, 0x0e
	mov al, bl
	int 0x10
	jmp loop


done:

;originally in the book it wants me to change address
;but i'm not doing that bec it fucked up last time

jmp $

times 510-($-$$) db 0
dw 0xaa55