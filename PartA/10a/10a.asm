assume cs:code, ds:data
data segment
        fname   db      "textf.txt"
        buff    db      100 dup(0)

        errmsg  db 0ah,0dh,"file not found$"
        closmsg db  0ah,0dh,"file closed successfully$"

data ends
code segment
start:
        mov ax,data
        mov ds,ax

        mov ah,3dh ;open file
        lea dx,fname
        mov al,0 ;read
        int 21h
        jnc next

        lea dx,errmsg
        mov ah,9
        int 21h
        jmp finish

next:
        mov bx,ax
        mov ah,3fh ;read file
        mov cx,100d
        lea dx,buff
        int 21h

        mov cx,100d
        lea si,buff

repeat:
        mov dl,[si]
        mov ah,2
        int 21h
        inc si
        loop repeat

        mov ah,3eh ;close file
        int 21h

	jc finish
	lea dx,closmsg
	mov ah,9
	int 21h

finish:
        mov ah,4ch
        int 21h
code ends
end start
