;10b) Move the elevator to the first request floor and bring it back to ground floor in elevator interface. The
;elevator need not respond to the intermediate requests in both directions

assume cs:code,ds:data

data segment
        pa equ 20A0h
        pb equ 20A1h
        pc equ 20A2h
        cr equ 20A3h
data ends

code segment
start:
	mov ax,data	
	mov ds,ax
	
	mov al, 82h		; port A output, port B input,port C output
	mov dx,cr
	out dx,al

	mov dx,pa	
	mov al,00h		; clear all requests, make elevator stand at first LED
	out dx,al
	mov al,0f0h		; enable requests
	out dx,al        
	
	mov dx, pb		; to read request

	
scan_again:
	in al, dx		
	and al,0fh		; masking MS 4 bits
	cmp al,0fh		; any request?
	je scan_again		; no, then please give one
	mov cl,01		; up to this LED the elevator should move

rot_again:
	ror al,1		; checking for floor from which the request has come
	jc next			; If there is carry, then there is no request
	jmp start_mov		; CF = 0, identified the floor from which the request is made
		
next:	add cl,03h
	jmp rot_again
		



start_mov:
	mov dx,pa	
        mov al,0f0h              ; f in MS nibble says, don’t clear the request

next_led:
	out dx,al		; at last elevator started moving
	call delay
	inc al
	dec cl
	jnz next_led	
	call delay		; wait for some time to pick passenger
	call delay
	dec al	
	and al,0fh		; now clear the request, but keep led number intact

come_down:
	out dx,al
	call delay
	dec al
	cmp al,00h	  	; reached ground floor?
	jge come_down     	; no, then come down still
	
	mov ah,4ch 
	int 21h

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
