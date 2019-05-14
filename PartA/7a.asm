assume cs:code,ds:data
Data segment
         Fibo db 10 dup(?)
         N db 08h
Data ends

Code segment
Start:
         mov ax,data
         mov ds,ax

         lea si, Fibo
         mov al,00h
         mov [si],al
         inc si
         mov bl,01h
         mov [si],bl
         inc si
         mov cl,n
         sub cl,2
         mov ch,00

    next_number:
                   add al,bl
                   mov [si],al
                   inc si
                   xchg al,bl
                   loop next_number

         mov ah,4ch
         int 21h
code ends
end start
