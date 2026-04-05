;commands for 16bit assembly
;just lets test the echo function

function_os3_16:
	;enter os3 protected mode here.
	pusha
	mov si, os3dialogue_1
	call print_string
	call newline
	popa
	jmp switch_to_32_bit			;permanent jump
	
	
function_debug_16:
	;enter debug info here
	pusha
	mov si, debugdialogue_1
	call print_string
	call newline
	popa
	ret
	
function_shutdown_16:
	;enter shutdown info here
	cli
	mov al, 0xfe
	out 0x64, al
	mov si, shutdown_command
	call print_string
	hlt

function_nothing_16:
	;enter "no command info" here
	pusha
	mov si, nothingdialogue_1
	call print_string
	call newline
	popa
	ret
	
	
;-------------------------------------
;for the plethora of commands here

os3_command: db 'os3' ,0
debug_command: db 'debug' ,0
shutdown_command: db 'shutdown' ,0

os3dialogue_1: db 'Shifting to Protected Mode...' ,0

debugdialogue_1: db 'Enter debug mode here' ,0

shutdowndialogue_1: db 'PANIC: SHUTDOWN FAILED. HALTING...' ,0

nothingdialogue_1: db 'Command does not exist' ,0