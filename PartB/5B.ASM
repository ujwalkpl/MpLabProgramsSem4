assume cs:code, ds:data

data segment
sine	db 0, 11d, 22d, 33d, 43d, 54d, 63d, 72d, 81d, 90d, 97d, 104d, 109d, 115d, 119d, 122d
	db 125d, 126d, 127d, 126d, 122d, 119d, 115d, 109d, 104d, 97d, 90d, 81d, 72d, 63d
        db 54d, 43d, 33d,  22d, 11d
        pa    equ 20a0h
        cr    equ 20a3h
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	
	mov dx, cr 
	mov al, 80h
	out dx, al
	
repeat:	mov dx, pa
	lea si, sine
	mov cx, 36d
next:	mov al, [si]
	add al, 128d
	out dx,al
	inc si
	loop next
	
	mov cx,36d
	lea si, sine
next1:	mov al,128d
	mov ah, [si]
	sub al, ah
	out dx, al
	inc si
	loop next1
	jmp repeat
	
code ends
end start
