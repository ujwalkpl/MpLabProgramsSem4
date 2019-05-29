assume cs:code,ds:data
data segment
        str1 db 'madam'
        n dw n-str1
        str2 db 5 dup(?)
        msg1 db "Palindrome$"
        msg2 db "not Palindrome$"
        data ends
     code segment

      start:
        mov ax,data
        mov ds,ax
        mov es,ax

        mov cx,n
        lea si,n
        dec si
        lea di,str2

       nextchar:
         mov al,[si]
         mov [di],al
         dec si
         inc di
         loop nextchar

        lea si,str1
        lea di,str2
        cld

        mov cx,n
        rep cmpsb
        jnz unsuccess
        lea dx,msg1
        jmp disp

       unsuccess:
          lea dx,msg2

       disp:
          mov ah,9h
          int 21h
          mov ah,07h
          int 21h
          mov ah,4ch
          int 21h
          code ends
          end start
