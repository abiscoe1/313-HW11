
	SECTION .data
inputBuffer:
	db      0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
bytesToProcess:
	dd      0x8
hexDigits:
	db      '0123456789ABCDEF'

	SECTION .bss
outputBuffer:
	resb 160        ; Reserve 160 bytes for output (2 chars per byte + newline)

	SECTION .text
	global _start

_start:
	xor edi, edi    ; outputBuffer index
	xor esi, esi    ; inputBuffer index
	xor eax, eax    ; accumulator and syscalls
	xor ecx, ecx    ; clear ecx
	xor edx, edx    ; clear edx

getNextByte:
	cmp esi, [bytesToProcess] ; Compare source index with bytesToProcess
	jge done	  	  ; If all bytes translated, jump to done

	mov ecx, inputBuffer ; Set ecx to point to the address of the current byte in inputBuffer
	mov al, [ecx + esi]  ; Load the byte from inputBuffer into eax

	call translateByte

	;; Add space between hex numbers
	mov al, 0x20
	mov [outputBuffer + edi], al
	inc edi

	;; Move to next byte
	inc esi
	jmp getNextByte
	
;;; Subroutine that does the translation
translateByte:
	;; Convert most significant 4 bits
	mov ah, al      ; Copy byte to ah
        shr ah, 4       ; Shift right by 4 bits
	and ah, 0x0F    ; Mask to keep only the lower 4 bits
	mov bl, ah
	mov al, [hexDigits + ebx]    ; Get corresponding hex character
	mov [outputBuffer + edi], al ; Store it in outputBuffer
	inc edi		     	     ; Move to the next position in outputBuffer

	;; Convert least significant 4 bits
	mov al, [ecx + esi] ; Load the byte from inputBuffer into eax
	and al, 0x0F	    ; Mask to get the low bits
	mov bl, al
	mov al, [hexDigits + ebx]    ; Get corresponding hex character
	mov [outputBuffer + edi], al ; Store it in outputBuffer
	inc edi		             ; Move to the next position in outputBuffer

	ret
	
done:
	;; Add a new line to the end of the output
	mov al, 0x0A
	mov [outputBuffer + edi], al
	inc edi
	mov [outputBuffer + edi], al
        inc edi

	;; Output the final string in outputBuffer
	mov edx, edi    ; Set edx to the length of the output
	mov eax, 4
	mov ebx, 1
	mov ecx, outputBuffer
	int 0x80        ; Print

	;; Exit the program
	mov eax, 1
	xor ebx, ebx
	int 0x80
