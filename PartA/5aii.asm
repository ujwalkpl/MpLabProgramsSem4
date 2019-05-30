;to display stack     d ss:40 80
assume cs:code,ds:data,ss:stack_seg
data segment
n db 5
res db ?
data ends

stack_seg segment 
  stack  dw 40 dup(0)
  stack_top label word
  stack_seg ends

  code segment
  start:
        mov ax,data
        mov ds,ax

        mov ax,stack_seg
        mov ss,ax

        lea sp,stack_top

        mov al,n
        call fact
        mov ah,4ch
        int 21h
        fact proc
        cmp al,00h
        je cal
        mov ah,00h
        push ax
        dec al
        call fact
        pop ax
        mul res
        mov res,al
        ret
        

        cal:
                mov res,01
                ret

       fact endp
       code ends
       end start

        cal:


