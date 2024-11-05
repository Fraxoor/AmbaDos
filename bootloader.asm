BITS 16              ; Ini buat ngasih tahu assembler kalau kita pake 16-bit mode
ORG 0x7C00           ; Memory address tempat BIOS ngeload bootloader (512 byte pertama di disk)

start:
    cli              ; Nonaktifin interrupt
    mov ax, 0x07C0   ; Setup stack
    add ax, 288      ; 288 paragraf dari 0x07C00
    mov ss, ax
    mov sp, 0xFFFF

    sti              ; Aktifin lagi interrupt

    mov si, msg
    call print_string

    ; Nge-load kernel dari disk
    mov ah, 0x02     ; BIOS function buat baca dari disk
    mov al, 1        ; Baca 1 sektor
    mov ch, 0        ; Cylinder 0
    mov dh, 0        ; Head 0
    mov cl, 2        ; Sector 2 (sektor setelah boot sector)
    mov bx, 0x1000   ; Tempat ngeload kernel (di memory 0x1000)
    int 0x13         ; Panggil BIOS

    jmp 0x1000:0000  ; Pindahin kontrol ke kernel di 0x1000

print_string:
    mov ah, 0x0E     ; BIOS teletype function buat print karakter
.repeat:
    lodsb            ; Load next byte dari [SI] ke AL
    or al, al        ; Cek akhir string
    jz .done
    int 0x10         ; Panggil BIOS
    jmp .repeat
.done:
    ret

msg db "Hello from bootloader!", 0

times 510-($-$$) db 0 ; Isi sisa 512 byte
dw 0xAA55             ; Boot signature
