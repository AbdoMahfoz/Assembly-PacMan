include irvine32.inc

.data
;put your static data
.code

;Write your functions here
;Do not forget to modify main.def file accordingly 


; DllMain is required for any DLL
DllMain PROC hInstance:DWORD, fdwReason:DWORD, lpReserved:DWORD 

mov eax, 1		; Return true to caller. 
ret 				
DllMain ENDP

END DllMain
