include irvine32.inc
.data
Key DWORD ?
LastKey DWORD ?
State DWORD ?
Grid DWORD ?
sWidth DWORD ?
sHeight DWORD ?
PX1 DWORD ?
PX2 DWORD ?
PY1 DWORD ?
PY2 DWORD ?
DPX DWORD ?
DPY DWORD ?
E1X1 DWORD ?
E1X2 DWORD ?
E1Y1 DWORD ?
E1Y2 DWORD ?
E2X1 DWORD ?
E2X2 DWORD ?
E2Y1 DWORD ?
E2Y2 DWORD ?
E3X1 DWORD ?
E3X2 DWORD ?
E3Y1 DWORD ?
E3Y2 DWORD ?
E4X1 DWORD ?
E4X2 DWORD ?
E4Y1 DWORD ?
E4Y2 DWORD ?
PTX DWORD ?
PTY DWORD ?
E1TX DWORD ?
E1TY DWORD ?
E2TX DWORD ?
E2TY DWORD ?
E3TX DWORD ?
E3TY DWORD ?
E4TX DWORD ?
E4TY DWORD ?
RandomNumber Dword ?
Empty_Number = 0
Wall_Number = 1
Food_Number = 2
.code
;-----------------------------------------------------------------------
;------------------------Data-Initialzers-------------------------------
InitializeStateData PROC pKey:DWORD, pState:PTR DWORD
	mov EAX, pKey
	mov Key, EAX
	mov EAX, pState
	mov State, EAX
	ret
InitializeStateData ENDP
InitializeGridData PROC pGrid:PTR DWORD, pWidth:DWORD, pHeight:DWORD
	mov EAX, pGrid
	mov Grid, EAX
	mov EAX, pWidth
	mov sWidth, EAX
	mov EAX, pHeight
	mov sHeight, EAX
	ret
InitializeGridData ENDP
InitializePlayerData PROC pPX1:DWORD, pPX2:DWORD, pPY1:DWORD, pPY2:DWORD, pPTX:PTR DWORD, pPTY:PTR DWORD
	mov EAX, pPX1
	mov PX1, EAX
	mov EAX, pPX2
	mov PX2, EAX
	mov EAX, pPY1
	mov PY1, EAX
	mov EAX, pPY2
	mov PY2, EAX
	mov EAX, pPTX
	mov PTX, EAX
	mov EAX, pPTY
	mov PTY, EAX
	ret
InitializePlayerData ENDP
InitializeEnemyData PROC pEnemyNumber:DWORD, pEX1:DWORD, pEX2:DWORD, pEY1:DWORD, pEY2:DWORD, pETX:PTR DWORD, pETY:PTR DWORD
	cmp pEnemyNumber, 1
	jne I1
		mov EAX, pEX1
		mov E1X1, EAX
		mov EAX, pEX2
		mov E1X2, EAX
		mov EAX, pEY1
		mov E1Y1, EAX
		mov EAX, pEY2
		mov E1Y2, EAX
		mov EAX, pETX
		mov E1TX, EAX
		mov EAX, pETY
		mov E1TY, EAX
		ret
	I1:
	cmp pEnemyNumber, 2
	jne I2
		mov EAX, pEX1
		mov E2X1, EAX
		mov EAX, pEX2
		mov E2X2, EAX
		mov EAX, pEY1
		mov E2Y1, EAX
		mov EAX, pEY2
		mov E2Y2, EAX
		mov EAX, pETX
		mov E2TX, EAX
		mov EAX, pETY
		mov E2TY, EAX
		ret
	I2:
	cmp pEnemyNumber, 3
	jne I3
		mov EAX, pEX1
		mov E3X1, EAX
		mov EAX, pEX2
		mov E3X2, EAX
		mov EAX, pEY1
		mov E3Y1, EAX
		mov EAX, pEY2
		mov E3Y2, EAX
		mov EAX, pETX
		mov E3TX, EAX
		mov EAX, pETY
		mov E3TY, EAX
		ret
	I3:
	mov EAX, pEX1
	mov E4X1, EAX
	mov EAX, pEX2
	mov E4X2, EAX
	mov EAX, pEY1
	mov E4Y1, EAX
	mov EAX, pEY2
	mov E4Y2, EAX
	mov EAX, pETX
	mov E4TX, EAX
	mov EAX, pETY
	mov E4TY, EAX
	ret
InitializeEnemyData ENDP
;-------------------------------Helper-------
TranslatePosition PROC X1:DWORD, X2:DWORD, Y1:DWORD, Y2:DWORD

TranslatePosition ENDP

ValidatePosition PROC X1:DWORD, X2:DWORD, Y1:DWORD, Y2:DWORD
	
ValidatePosition ENDP
GenerateRandomNumber PROC Range:Dword
	call Randomize ; Generates the Seed 
	mov eax, Range ; sets the range of the random numbers
	call RandomRange 
	inc eax
	mov RandomNumber , eax ; moves the random number to the Random Number Variable  
GenerateRandomNumber ENDP
;------------Pacman-Translations--------------
MovePacMan PROC

MovePacMan ENDP
;------------Checkers-------------------------
CheckFood PROC

CheckFood ENDP

CheckDeath PROC

CheckDeath ENDP
;-------------------------AI------------------
AIMegaController PROC

AIMegaController ENDP

AIController PROC EX1:DWORD, EX2:DWORD, EY1:DWORD, EY2:DWORD, ETX: DWORD, ETY, DWORD

AIController ENDP
;----------------------------------------------
;----------------------------------------------
DebugFunction PROC param:DWORD
	mov eax, param
	imul eax, 2
	ret
DebugFunction ENDP

DllMain PROC hInstance:DWORD, fdwReason:DWORD, lpReserved:DWORD 
	mov eax, 1
	ret 				
DllMain ENDP
END DllMain
