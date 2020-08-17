[org 0x7c00]

;main code-----------------------------------------------------

mov bp, 0x8000
mov sp, bp

mov si, msg
call print

mov bx, 0x9000	;where to load (ES:BX)
mov dh, 0x02	
mov dl, [boot_drive]
call disk_load

mov dx, [0x9000]
call print_hex

mov dx, [0x9200]
call print_hex

;hang--------------------------
cli
jmp $

;functions-----------------------------------------------------

;print-------------------------------------------
print:
pusha
mov ah, 0x0e	;teletype output
a:
mov al, [si]	;char to print
cmp al, 0x0
je b
int 0x10
inc si
jmp a
b:
popa
ret

;print_hex---------------------------------------
print_hex:
pusha
;manipulate hex_out----------
mov bx, dx
shr bx, 12
and bx, 0x000f
mov bx, [hex + bx]
mov [hex_out + 2], bl

mov bx, dx
shr bx, 8
and bx, 0x000f 
mov bx, [hex + bx]
mov [hex_out + 3], bl

mov bx, dx
shr bx, 4
and bx, 0x000f
mov bx, [hex + bx]
mov [hex_out + 4], bl

mov bx, dx
shr bx, 0
and bx, 0x000f
mov bx, [hex + bx]
mov [hex_out + 5], bl
;end of manipulation---------
mov si, hex_out
call print
popa
ret

;load to memory------------------------------------------------
disk_load:
pusha
push dx		;save to cmp later
;dh-num_sec, dl-floppy/hdd/cd
mov ah, 0x02	;read sectors from drive
mov al, dh		;number of sectors to read
mov dh, 0x00	;head
mov ch, 0x00	;cylinder
mov cl, 0x02	;sector (second sector)
int 0x13

jc disk_err
pop dx
cmp dh, al
jne disk_err

popa
ret

disk_err:
mov si, lerr
call print
mov dx, ax
call print_hex
cli
jmp $

;data----------------------------------------------------------
msg: db "Data loaded from boot drive:", 0x0a, 0x0d, 0x0
hex_out: db "0x0000", 0x0a, 0x0d, 0x0
hex: db "0123456789ABCDEF"
lerr: db "Error: INT 13H -> AX: ", 0x0
boot_drive: db 0x80	;floppy-iso(0x00) or hdd-qemu(0x80)

;boot number---------------------------------------------------
times 510-($-$$) db 0
dw 0xaa55

;other sectors-------------------------------------------------
times 256 dw 0xb10c
times 256 dw 0xcafe
