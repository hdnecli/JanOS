[org 0x7C00]
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
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov [BOOT_DRIVE], dl

    mov si, msg_loading
    call print

    ; Disk reset
    mov ah, 0x00
    mov dl, [BOOT_DRIVE]
    int 0x13

    ; ES:BX = 0000:1000 -> Stage-2 load address
    mov bx, 0x1000

    ; CHS: cylinder=0, head=0, sector=2, count=4
    mov ah, 0x02        ; read sectors
    mov al, 0x04        ; 4 sector
    mov ch, 0x00        ; cylinder 0
    mov cl, 0x02        ; sector 2
    mov dh, 0x00        ; head 0
    mov dl, [BOOT_DRIVE]

    int 0x13
    jc disk_error

    jmp 0x0000:0x1000

disk_error:
    mov si, msg_error
    call print
    jmp $

BOOT_DRIVE db 0

msg_loading db "Stage-2 loading...", 0
msg_error   db "Disk read error!", 0

times 510 - ($ - $$) db 0
dw 0xAA55

