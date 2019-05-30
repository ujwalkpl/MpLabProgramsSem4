;3b) Rotate the stepper motor clockwise/anticlockwise or in both directions by x degrees [x will be specified at the
;time of experiment].

assume cs:code,ds:data
data segment
pa equ 20a0h
pb equ 20a1h
pc equ 20a2h
cr equ 20a3h
data ends



code segment
start:
mov ax,data
mov ds,ax
mov dx,cr
mov al,80h;port a is output
out dx,al
mov cx,64h  ; 180 degree rotation 180/1.8 = 100 in hexadecimal = 64h
mov al,77h  ; to help in the rotation using ror/rol the lower four bits are copied to upper bits
mov dx,pa
rotclk:
out dx,al
rol al,1 ;change this to ror al,1 for anticlockwise rotation
call delay
loop rotclk
mov ah,4ch
int 21h
delay proc
mov bx,02fffh
l2:mov di,0ffffh
l1:dec di
jnz l1
dec bx
jnz l2
delay endp
code ends
end start


