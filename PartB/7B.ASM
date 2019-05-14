disp_msg macro msg
        lea dx,msg
        mov ah,9
        int 21h
        endm

disp macro			;macro to display the key pressed
        lea bx,table1
        xlat
        mov dl,al
        mov ah,2
        int 21h
        endm

initialize macro word
        mov al,word
        mov dx,20a3h
        out dx,al
        endm

assume ds:data,cs:code

data segment
        cw db 90h
        ops db 3 dup(?)
        table1 db '0123456789.+-'
        msg1 db "not supported$"
data ends

code segment
start:
        mov ax,data
        mov ds,ax
        initialize cw

        call readkp		; to read first operand
        call delay		; to eliminate switch debouncing problem
        mov ops,al
        disp			; to display the key pressed
       
        call readkp		; to read operator
        call delay
        mov ops+1,al
        disp

        call readkp		; to read second operand
        call delay
        mov ops+2,al
        disp
        
        mov dl,'='		; to display =
        mov ah,2		
        int 21h
        cmp ops+1,0bh           ; to check whether to add
        jne next                ; no, then try subtract
        mov al,ops		; yes, then take one operand to al 
        add al,ops+2		; add second operand
        daa                     ; we are designing BCD calculator, isnt it?
        mov cl,4		
        mov ah,0
        shl ax,cl
        shr al,cl
        add ax,3030h		; could use AAM
        mov dl,ah
        mov ah,2
        push ax
        int 21h
        pop ax
        mov dl,al
        mov ah,2
        int 21h
        jmp finish

next:
        mov al,ops+1	
        cmp al,0ch      ; to subtract the operands?
        jne disp_err
        mov al,ops
        sub al,ops+2
        cmp al,09
        jle noneed

        neg al
	mov dl,'-'	; shows negative answer
	mov ah,2
	push ax
	int 21h
	pop ax

noneed:        
        add al,30h
        mov dl,al
        mov ah,2
        int 21h
        jmp finish

disp_err:
        disp_msg msg1		; add or subtract only

finish: mov ah,4ch
        int 21h


readkp proc		; procedure which returns scan code of the key pressed
try_again:
        mov bl,01
        mov bh,03
        mov cl,00

next_row:
        mov al,bl
        mov dx,20a2h
        out dx,al
        mov dx,20a0h
        in al,dx
        cmp al,00h
        jne scode
        add cl,08h
        rol bl,1
        dec bh
        jnz next_row
        jmp try_again

scode:
        ror al,1
        jc return
        inc cl
        jmp scode

return: mov al,cl
        ret
readkp endp


delay proc
        mov si,03fffh
   l2:  mov di,0ffffh
   l1:  dec di
        jnz l1
        dec si
        jnz l2
        ret
delay endp

code ends
end start
