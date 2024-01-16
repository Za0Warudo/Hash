;+ AUTHOR: 
;+ Za0Warudo, Vinicius Gomes 
;+ 
;+ EMAIL: 
;+ viniciusgomes24@usp.br
;+
;+ DATE:
;+ 01/12/2024
;+
;+ DESCRIPTION: 
;+ Implementation of a hash function using assembly syntax x86-64. Based in EP(Exercicio problema)
;+ from Tecnicas de Progracao from IME-USP.
;+


global _start 

section .data 
	
	;++ File Descriptors 
	stdin: equ 0
	stdout: equ 1	
	;++ The magic vector 
	vector: db 122, 77, 153, 59, 173, 107, 19, 104, 123, 183, 75, 10,114, 236, 106, 83, 117, 16, 189, 211, 51, 231, 143, 118, 248, 148, 218,245, 24, 61, 66, 73, 205, 185, 134, 215, 35, 213, 41, 0, 174, 240, 177,195, 193, 39, 50, 138, 161, 151, 89, 38, 176, 45, 42, 27, 159, 225, 36,64, 133, 168, 22, 247, 52, 216, 142, 100, 207, 234, 125, 229, 175, 79,220, 156, 91, 110, 30, 147, 95, 191, 96, 78, 34, 251, 255, 181, 33, 221,139, 119, 197, 63, 40, 121, 204, 4, 246, 109, 88, 146, 102, 235, 223,214, 92, 224, 242, 170, 243, 154, 101, 239, 190, 15, 249, 203, 162, 164,199, 113, 179, 8, 90, 141, 62, 171, 232, 163, 26, 67, 167, 222, 86, 87,71, 11, 226, 165, 209, 144, 94, 20, 219, 53, 49, 21, 160, 115, 145, 17,187, 244, 13, 29, 25, 57, 217, 194, 74, 200, 23, 182, 238, 128, 103,140, 56, 252, 12, 135, 178, 152, 84, 111, 126, 47, 132, 99, 105, 237,186, 37, 130, 72, 210, 157, 184, 3, 1, 44, 69, 172, 65, 7, 198, 206,212, 166, 98, 192, 28, 5, 155, 136, 241, 208, 131, 124, 80, 116, 127,202, 201, 58, 149, 108, 97, 60, 48, 14, 93, 81, 158, 137, 2, 227, 253,68, 43, 120, 228, 169, 112, 54, 250, 129, 46, 188, 196, 85, 150, 6, 254, 180, 233, 230, 31, 76, 55, 18, 9, 32, 82, 70

section .bss
	
	;++ Buffer 
	buf: resb 1000000
	buf_size: equ 1000000  
	;++ New block vector 
	new_block: resb 16
	;++ Step3 vector 
	hash: resb 48 
	;++ Final hash in hex  
	hex: resb 33 
	
section .text

_start:
 
	;++ Read Buffer
	mov rax, 0 
	mov rdi, stdin
	mov rsi, buf 
	mov rdx, buf_size
	syscall 

	;++ Remove line feed
	dec rax  
	
	;++ Move parameters 
	mov rdi, buf 
	mov rsi, rax 

	;++ Step1 Call 
	call step1 

	;++ Step2 call 
	call step2 

	;++ Step3 call 
	call step3 

	;++ Step4 call 
	call step4 

	;++ Print hex 
	mov rax, 1 
	mov rdi, stdout
	mov rsi, hex
	mov rdx, 33
	syscall 

	;++ Exit 
	mov rax, 60
	xor rdi, rdi
	syscall 	
	
;++++;
step1: 
	;++ void step1(char* string , size_t size) 
	;++ 	Verify string size:  
	;++		case1: If already divible by 16, then Return.
	;++ 	case2: Else fill string with (16-remeinder) until new string size
	;++ 	be multiple of 16 then Return. 

	;++ Compute the remainder 
	mov rax, rsi 
	xor rdx, rdx 
	mov rbx, 16 
	div rbx 
 	
	;++ Prepare for cmp and Filling if necessary 
	sub rbx, rdx   	
	mov rax, rbx
	xor rcx, rcx 

	;++ Test
	cmp rbx, 16 

	jl .loop 

	ret  
.loop:
		
	;++ Fill 
	dec rbx

	cmp rbx, 0   

	jl .done 
	
	;++ Fill  top to bottom  
	lea rcx, [rdi+rsi]
	lea rcx, [rcx+rbx]
	mov byte [rcx], al   	

	jmp .loop 

.done:
	;++ Old_size + Fill_size 
	add rsi, rax  

	ret

;++++;
step2: 
	;++ int step2(char* string, size_t sizeS)
	;++ 	Add a new block of 16 bytes to the string. The new block
	;++ 	is made by an algorithm and a magic vector  
	;++ 	return new vector size divided by 16, and update size. 
	
	;++ Counter 
	xor rcx, rcx 

.loop: 
	;++ Fill with zeros new_block

	cmp rcx, 16 

	je .done 

	mov byte [new_block+rcx], 0 
	inc rcx 
	
	jmp .loop 	

.done: 

	;++ Compute N 
	mov rax, rsi  
	xor rdx, rdx 
	mov rcx, 16 
	div rcx

	;++ Save multiple 	
	mov r8, rax

	;++ New value 
	xor rcx, rcx 
 
	;++ i counter 
	xor r9, r9	
	 
.iloop:
	
	cmp r9, r8 
		
	je .idone
			
	;++ j counter 
	xor r10, r10 

.jloop:

	cmp r10, 16 

	je .jdone 
		
	;++ Algorithm
	lea rax, [rdi+8*r9]
	lea rax, [rax+8*r9]
	lea rax, [rax+r10]
	xor rbx, rbx 
	mov bl, [rax] 
	xor bl, cl 
	mov bl, [vector+rbx] 
	xor bl, [new_block+r10]
	mov cl, bl
	mov byte [new_block+r10], bl 
	
	inc r10 

	jmp .jloop

.jdone:

	inc r9 

	jmp .iloop

.idone:	
	
	xor rcx, rcx 
	xor rax, rax 
.cloop:
	;++ Concar New Block 	
	cmp rcx, 16 

	je .cdone 

	mov al, [new_block+rcx] 
	lea r10, [rdi+rsi]
	lea r10, [r10+rcx]
	mov byte [r10], al 

	inc rcx
 
	jmp .cloop
.cdone:
	
	;++ Update size, and ret value 
	add rsi, 16
	inc r8  
	mov rax, r8   
	ret 	
 	

;++++; 
step3: 
	;++ char* step3(char* string, size_t size)
	;++ 	Using an algorithm converts the string vector in a condensed 48 bytes
	;++ 	Hash vector. 
	 
	mov r8, rax 
	xor rcx, rcx 

.loop: 
	;++ Fill with zeros the hash vector 
	cmp rcx, 48 
	
	je .done 

	mov byte [hash+rcx], 0 	
	inc rcx 

	jmp .loop 
.done: 

	;++ i counter 
	xor r9, r9 

.iloop: 
	
	cmp r9, r8 
	
	je .idone
	
	;++ j counter 
	xor r10, r10
.jloopI:

	cmp r10, 16 

	je .jdoneI
	
	;++ Algorithm
	lea rax, [rdi+8*r9]
	lea rax, [rax+8*r9]
	lea rax, [rax+r10]	
	xor rbx, rbx 
	mov bl, [rax]
	mov byte [hash+16+r10], bl 
	xor bl, [hash+r10] 
	mov byte [hash+32+r10], bl 	

	inc r10 	
	jmp .jloopI 
 
.jdoneI:	
	;++ Temp
	xor rcx, rcx 

	xor r10, r10 
.jloopII: 

	cmp r10, 18 

	je .jdoneII 

	;++ k counter 
	xor r11, r11 

.kloop: 
	
	cmp r11, 48 
	
	je .kdone 
	
	xor rax, rax 
	mov al , [hash+r11] 
	xor al, [vector+rcx] 
	mov cl, al  
	mov byte [hash+r11], al 	

	inc r11 
	jmp .kloop 

.kdone: 
	add rcx, r10
	mov rax, rcx 
	xor rdx,rdx 
	mov rcx, 256 
	div rcx 

	mov rcx, rdx  
	
	inc r10 
	jmp .jloopII	 

.jdoneII: 

	inc r9
	jmp .iloop
.idone: 
	mov rdi, hash

	ret 

;++++; 
step4:
	;++ char* step4(char* string)
	;++ 	Converts string the first 16 bytes of string in a hex hash
	;++ 	Return hex hash pointer. 

	xor rcx, rcx 
	
.loop:
	;++ Compute value in hexa base 
	cmp rcx, 16 
	
	je .done 
	xor rax, rax 
	mov al , [hash+rcx] 
	xor rdx, rdx 
	mov rbx, 16
	div rbx
	
	lea rbx, [2*rcx] 
	
	;++ Convert the multiple to string form
	call convert
	
	inc rbx 
	
	mov rax, rdx
	
	;++ Convert the remainder to string form 
	call convert  	

	inc rcx
	jmp .loop 	

.done: 
	mov byte [hex+32] , 0x0A 
	ret 


convert:
	;++ void convert(int N, int counter)
	;++ 	Converts the int N to it's correspodent as char, and add this char to
	;++ 	Counter position in hex hash vector.

	cmp rax, 10 
	
	jge .me10 	

.lt10: 
	;++ use ascii
	add rax, 48 
	mov byte [hex+rbx], al 
	
	jmp .done
.me10: 
	
	add rax, 87 
	mov byte [hex+rbx], al 
	
.done:

	ret 
