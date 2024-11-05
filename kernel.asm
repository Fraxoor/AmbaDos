[BITS 16]
[ORG 0x1000]          ; Kernel kita di-load di 0x1000

start:
    mov si, kernel_msg
    call print_string
    cli
    hlt

print_string:
    mov ah, 0x0E
.repeat:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .repeat
.done:
    ret

kernel_msg db "Hello from kernel!", 0
