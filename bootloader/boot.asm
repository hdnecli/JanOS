[org 0x7c00]
jmp start

print:
	mov ah, 0x0e
	.loop:
		lodsb
		cmp al, 0
		je .done
		int 0x10
		jmp .loop
	.done:
		ret

start:
	mov si, msg
	call print
	jmp $

msg db "Bootloader Working!", 0

times 510 - ($ - $$) db 0
dw 0xAA55
