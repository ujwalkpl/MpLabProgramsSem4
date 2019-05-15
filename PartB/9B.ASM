;9b) Display n character message on seven segment display in a rolling fashion.
;In this program a seven segment display is used 
;Working of seven segment display :
;Port B can send just one bit So the upper most bit is sent When u do out dx,al 
;when a clock pulse is given to the seven segment display the shift register shifts one bit to left
;so after shifting it 8 times the first character F will be in the first display
;then a delay is given so that the character stays there for some time
;The shifting of bits cant be seen because there is no delay in the loop
;All the leds wont be on simultaneously on but since the rate of change of frames is more than 25 our eye perceives it as one frame


assume cs:code,ds:data

data segment
        pa equ 20A0h
        pb equ 20A1h
        pc equ 20A2h
        cr equ 20A3h

        msg db 0ffh,71h,9fh,0f5h,61h,0ffh, 0d1h,61h,0e3h,31h,0ffh, 0d1h,61h,0f5h,61h		; F I r E blank H E L P blank H E r E		

	


data ends

code segment
start:
        mov ax,data
        mov ds,ax

	mov dx,cr
	mov al,80h ; port A output port B output port C output
        out dx, al

rpt:
        mov cx,15d 
        lea si,msg

next_char:
        mov al,[si]
        call disp

        call delay ; delay is called to give a rolling effect

        inc si
        loop next_char

        mov ah,06h
        mov dl,0ffh
        int 21h
        jz rpt

        mov ah,4ch
        int 21h

disp proc
        push cx
        mov cx,8

next_bit:
        mov dx,pb
        out dx,al
        push ax
        mov al,0ffh
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
