include irvine32.inc
.data
FRCX DWORD ?
FRCY DWORD ?
valid DWORD ?
Key DWORD ?
LastKey DWORD 0
State DWORD 0
Food_Numbers DWORD -1
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

InitializeFood_Number PROC
mov edx ,Food_Numbers
cmp edx,-1
jnz End_Function
mov edx,offset Grid
mov eax,sWidth
mov ebx ,sHeight
mul ebx
mov ecx,eax
l1:
mov ebx,[edx]
cmp ebx,Food_Number
jnz continueloop 
inc Food_Numbers
continueloop:
add edx,type Grid
loop l1
End_Function:
ret 
InitializeFood_Number ENDp
;-------------------------------Helper-------
TranslatePosition PROC X1:DWORD, X2:DWORD, Y1:DWORD, Y2:DWORD
	mov eax,X1
    mov esi,X2
	mov FRCX,0
	cmp esi,5
	jae Round_x
Continue:
	mov ebx,Y1
    mov edx,Y2
	mov FRCY,0
	cmp edx,5
	jae Round_Y
	jmp End_Function
Round_X:
	inc eax
	mov FRCX,1
	jmp Continue
Round_Y:
	inc edx
	mov FRCY,1
	End_Function:
	ret
TranslatePosition ENDP

ValidatePosition PROC X1:DWORD ,Y1:DWORD
	cmp X1,sWidth
	jne Next
	jmp Not_Valid
Next:
	cmp X1,0
	jae next2
	jmp Not_Valid
next2:
	cmp Y1,sHeight
	jne next3
	jmp Not_Valid
next3:
	cmp Y1,0
	jae next4
	jmp Not_Valid
next4:
	mov eax,X1
	mov ebx,sWidth
	mul ebx
	mov ebx,offset Grid
	add ebx,eax
	add ebx,Y1
	mov eax,[ebx]
	cmp eax,Wall_Number
	jz Not_Valid
	mov valid,1
	jmp End_Function
Not_Valid:
	mov valid,0
End_Function:
	ret 
ValidatePosition ENDP
GenerateRandomNumber PROC 
	push eax ;#1saves eax 
	call Randomize ;#5Generates the Seed 
	mov eax, 4 ;#5sets the range of the random numbers
	call RandomRange 
	mov RandomNumber , eax ;#?moves the random number to the Random Number Variable  .
	pop eax ;#1resotors eax
	ret
GenerateRandomNumber ENDP
;------------Pacman-Translations--------------
MovePacMan PROC
	mov edx,LastKey
	cmp edx,Key
	jz check
	jmp Begin
check:
	mov edx,PX2
	cmp edx,0
	jnz check1
	jmp Begin
check1:
	mov edx,PY2
	cmp edx,0
	jnz End_Function
	jmp Begin
Begin:
	push PX1
	push PX2
	push PY1
	push PY2

	cmp Key,1
	jz Move_up
	cmp Key,2
	jz Move_Right
	cmp Key,3
	jz Move_Down
	cmp Key,4
	jz Move_Left
	jmp Out_of_Range

Move_up:
	add PY2,1
	invoke TranslatePosition,PX1,PX2,PY1,PY2
	cmp FRCY,1
	jz next
	jmp check_Validation
next:
	sub ebx,1
	mov PY1,ebx
	mov PY2,0
	jmp check_Validation

Move_Right:
	add px2,1
	Invoke TranslatePosition,PX1,PX2,PY1,PY2
	cmp FRCX,1
	jz next1
	jmp check_Validation
next1:
	inc eax
	mov PX1,eax
	mov PX2,0
	jmp check_Validation
Move_Down:
	add PY2,1
	Invoke TranslatePosition,PX1,PX2,PY1,PY2
	cmp FRCY,1
	jz next2
	jmp check_Validation
next2:
	add ebx,1
	mov PY1,ebx
	mov PY2,0
	jmp check_Validation
Move_Left:
	add px2,1
	Invoke TranslatePosition,PX1,PX2,PY1,PY2
	cmp FRCX,1
	jz next3
	jmp check_Validation1
next3:
	dec eax
	mov PX1,eax
	mov PX2,0
	jmp check_Validation
check_Validation:
	INVOKE Validation,eax,ebx
	mov edx,valid
	cmp valid,1
	jz Finsh
	jmp Out_Of_Range
Out_Of_Range:
	pop EY2
	pop EY1
	pop EX2
	pop EX1
	jmp End_Function
Finsh:
	pop edx
	pop edx
	pop edx
	pop edx
	mov esi,PTX
	mov [esi],eax
	mov esi,PTY
	mov [esi],ebx
	jmp End_Function
End_Function:
	ret

MovePacMan ENDP
;------------Checkers-------------------------
CheckFood PROC X1:DWORD,Y1:DWORD
mov eax,X1
mov ebx,sWidth
mul ebx
add eax,Y1
mov edx,offset Grid 
add edx,eax
mov eax,[edx]
cmp eax,Food_Number
jz DECremnt
jmp End_Function
DECremnt:
dec Food_Numbers
mov eax,Empty_Number
mov ebx,edx
mov [ebx],eax
mov edx,Food_Numbers
cmp edx,0
jz Winner
jmp End_Function
Winner:
mov State,1
End_Function:
ret
CheckFood ENDP

CheckDeath PROC PX1:DWORD,PX2:DWORD,PY1:DWORD,PY2:DWORD,EX1:DWORD,EX2:DWORD,EY1:DWORD,EY2:DWORD
mov eax,PX1
CMP eax,EX1
JZ L1
RET
L1:
mov eax,PX2
CMP eax,EX2
JZ L2
RET
L2:
mov eax,PY1
CMP eax,EY1
JZ L3
RET
L3:
mov eax,PY2
CMP eax,EY2
JZ L4
RET
L4:
mov State,2
RET
CheckDeath ENDP

MegaCheckDeath PROC
invoke CheckDeath ,PX1,PX2,PY1,PY2,E1X1,E1X2,E1Y1,E1Y2
mov edx,State
cmp edx,2
JNE L1
ret
L1:
invoke CheckDeath ,PX1,PX2,PY1,PY2,E2X1,E2X2,E2Y1,E2Y2
mov edx,State
cmp edx,2
JNE L2
ret
L2:
invoke CheckDeath ,PX1,PX2,PY1,PY2,E3X1,E3X2,E3Y1,E3Y2
mov edx,State
cmp edx,2
JNE L3
ret
L3:
invoke CheckDeath ,PX1,PX2,PY1,PY2,E4X1,E4X2,E4Y1,E4Y2
MegaCheckDeath ENDP
;-------------------------AI------------------
AIMegaController PROC
invoke AIController ,E1X1 ,E1X2,E1Y1 ,E1Y2 ,E1TX ,E1TY
invoke AIController ,E2X1 ,E2X2,E2Y1 ,E2Y2 ,E2TX ,E2TY
invoke AIController ,E3X1 ,E3X2,E3Y1 ,E3Y2 ,E3TX ,E3TY
invoke AIController ,E4X1 ,E4X2,E4Y1 ,E4Y2 ,E4TX ,E4TY
AIMegaController ENDP

AIController PROC EX1:DWORD, EX2:DWORD, EY1:DWORD, EY2:DWORD, ETX: DWORD, ETY: DWORD
	Start:
	Invoke TranslatePosition ,EX1,EX2,EY1,EY2
	mov edx,FRCX
	cmp edx,1
	jz Next
Continue:
	mov edx,FRCY
	cmp edx,1
	jz Next2
Next:
	mov EX2,0
	jmp Continue
Next2:
	mov EY2,0

	call GenerateRandomNumber	
	cmp RandomNumber , 0
	Je MoveDown
	cmp RandomNumber , 1
	Je MoveRight
	cmp RandomNumber , 2
	Je MoveUp
	cmp RandomNumber , 3
	Je MoveLeft
	MoveDown: 
		Inc ebx
		jmp Cont
	MoveUp: 
		Dec ebx
		jmp Cont
	MoveRight
		inc eax
		jmp Cont
	MoveLeft
		dec eax
		jmp Cont
	Cont : 
	push eax
	push ebx
	invoke ValidatePosition eax, ebx 
	cmp valid,1
	je correct 
	jmp Start
	correct:
	pop ebx
	pop eax
	mov EX1,eax
	mov EY1,ebx
	mov edx,ETX
	mov [edx],eax
	mov edx,ETY
	mov [edx],ebx 
	ret
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
