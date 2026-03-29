mov ah, 0x0e	;int 10/ah = 0eh --> scrolling teletype apparantly

loop:
	mov al, 'H'
	int 0x10	;interrupt command for writing on screen
	mov al, 'E'
	int 0x10
	mov al, 'L'
	int 0x10
	mov al, 'L'
	int 0x10
	mov al, 'O'
	int 0x10
	mov al, ' '
	int 0x10
	mov al, 'W'
	int 0x10
	mov al, 'O'
	int 0x10 
	mov al, 'R'
	int 0x10
	mov al, 'L'
	int 0x10
	mov al, 'D'
	int 0x10

	jmp loop


;dumb magic number shit

times 510-($-$$) db 0

dw 0xaa55