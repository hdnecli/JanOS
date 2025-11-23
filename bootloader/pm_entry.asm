[org 0x1000]
[bits 16]

jmp start

; ---------------- REAL MODE PRINT ----------------
rm_print:
    mov ah, 0x0e
.rm_loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .rm_loop
.done:
    ret


; -------------------------------------------------
;                 STAGE-2 REAL MODE
; -------------------------------------------------
start:
    mov si, msg_stage2_rm
    call rm_print

    cli

    ; A20 ENABLE
    in   al, 0x92
    or   al, 00000010b
    out  0x92, al

    ; -------- GDT descriptor set (MUST BE PHYSICAL ADDR) --------
    lgdt [gdt_descriptor]

    ; enter protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; FAR JUMP → new CS=0x08
    jmp 0x08:pm_entry32


; -------------------------------------------------
;        32-BIT PROTECTED MODE SECTION
; -------------------------------------------------
[bits 32]
pm_entry32:
    mov ax, 0x10     ; data selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000

    mov esi, msg_pm
    mov edi, 0xb8000

print_pm:
    lodsb
    test al, al
    jz halt
    mov [edi], al
    mov byte [edi+1], 0x0F
    add edi, 2
    jmp print_pm

halt:
    jmp halt


; -------------------------------------------------
;                     GDT TABLE
; -------------------------------------------------
gdt_start:
    dq 0x0000000000000000        ; null
    dq 0x00CF9A000000FFFF        ; code
    dq 0x00CF92000000FFFF        ; data
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start                 ; BASE = PHYSICAL address (0x1000 + offset)


; -------------------------------------------------
msg_stage2_rm db " [Stage-2 real mode OK] ",0
msg_pm         db " >> Now in Protected Mode! << ",0

