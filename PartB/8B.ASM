;8b) Display FIRE and HELP alternatively n number of times on seven segment display interface
;assume cs:code,ds:data

data segment
        pa equ 20A0h
        pb equ 20A1h
        pc equ 20A2h
        cr equ 20A3h

        fire db 71h,9fh,0f5h,61h               ; F I r E 71h 9fh f5h 61h
        help db 0d1h,61h,0e3h,31h               ; H E L P 91h 61h e3h 31h
						; H E r E 91h 61h f5h 61h

data ends

code segment
start:
        mov ax,data
        mov ds,ax

	mov dx,cr
	mov al,80h ; port B output ,port C upper and lower Output
        out dx,al

rpt:
        mov cx,04h
        lea si,fire
next_char:
        mov al,[si]
        call disp
        inc si
        loop next_char

        call delay

        mov cx,04h
next:   mov al,[si]
        call disp
        inc si
        loop next

        call delay

        mov ah,06h
        mov dl,0ffh
        int 21h
        jz rpt
        mov ah,4ch
        int 21h

        disp proc
        push cx	
        mov cx,8	; to send 8 bits one by one


next_bit:
        mov dx,pb	; through port B
        out dx,al
        push ax
        mov al,0ffh	; since shift register is a synchronous circuit, needed a trigger ff to 00  
        mov dx,pc
        out dx,al
        mov al,00h
        out dx,al
        pop ax
        ror al,1
        loop next_bit
        pop cx
        ret
        disp endp

delay proc
        mov bx,02fffh
    l2: mov di,0ffffh
    l1: dec di
        jnz l1
        dec bx
        jnz l2
        ret
delay endp

code ends
end start
