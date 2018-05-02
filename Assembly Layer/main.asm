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


;This Function scan the whole grid to count the Food_Number on the grid
;At First it is intialized by -1 at .data
;then it is called at PacMan_Movements Function.
InitializeFood_Number PROC
mov edx ,Food_Numbers
cmp edx,-1
jnz End_Function
mov Food_Numbers, 0
mov esi,Grid
mov eax,sWidth
mov ebx ,sHeight
mul ebx
mov ecx,eax
l1:
mov ebx,[esi]
cmp ebx,Food_Number
jnz continueloop 
inc Food_Numbers
continueloop:
add esi,type Grid
loop l1
End_Function:
mov ebx, Food_Numbers
ret 
InitializeFood_Number ENDp
;-------------------------------Helper-------

;This Function rounds 2 numbers each one of them consists of 2 parts real & fraction.
;Returns these two numbers in the EAX,EBX respectively.
TranslatePosition PROC X1:DWORD, X2:DWORD, Y1:DWORD, Y2:DWORD
	mov eax,X1
    mov esi,X2
	mov FRCX,0
	cmp esi,5
	jge Round_x
Continue:
	mov ebx,Y1
    mov edx,Y2
	mov FRCY,0
	cmp edx,5
	jge Round_Y
	jmp End_Function
Round_X:
	inc eax
	mov FRCX,1
	jmp Continue
Round_Y:
	inc ebx
	mov FRCY,1
	End_Function:
	ret
TranslatePosition ENDP

;This Function Check the validation of the index on the Grid.
;Returns Bool variable called Valid 1 ---> is valid, 0 ----> not valid.
ValidatePosition PROC X1:DWORD ,Y1:DWORD
	Push eax
	mov eax,X1
	cmp eax,sWidth
	jne Next
	jmp Not_Valid
Next:
	mov edi,X1
	cmp edi,0
	jge next2
	jmp Not_Valid
next2:
	mov edi,Y1
	cmp edi,sHeight
	jne next3
	jmp Not_Valid
next3:
	cmp Y1,0
	jge next4
	jmp Not_Valid
next4:
	mov eax,Y1
	mov ebx,sWidth
	mul ebx
	add eax,X1
	imul eax, 4
	mov ebx,Grid
	add ebx,eax
	mov eax,[ebx]
	cmp eax,Wall_Number
	jz Not_Valid
	mov valid,1
	jmp End_Function
Not_Valid:
	mov valid,0
End_Function:
	pop eax
	ret 
ValidatePosition ENDP


;Generate Random number from range 0-3.
;Returns the generated number in the Data member called RandomNumber.
GenerateRandomNumber PROC 
	push eax ;#1saves eax 
	call Randomize ;#5Generates the Seed 
	mov eax, 4 ;#5sets the range of the random numbers
	call RandomRange 
	mov RandomNumber , eax ;#?moves the random number to the Random Number Variable  .
	pop eax ;#1resotors eax
	ret
GenerateRandomNumber ENDP
;------------Checkers-------------------------

;Checks if the current index on the grid has Food or not.
;If PacMan ate all the Food on the Grid the State is changed to winner.
CheckFood PROC X1:DWORD, X2:DWORD, Y1:DWORD, Y2:DWORD
call InitializeFood_Number
invoke TranslatePosition, X1, X2, Y1, Y2
mov X1, eax
mov Y1, ebx
mov eax,Y1
mov ebx,sWidth
mul ebx
add eax,X1
imul eax, 4
mov ebx,Grid
add ebx,eax
mov eax,[ebx]
cmp eax,Food_Number
jz DECremnt
jmp End_Function
DECremnt:
dec Food_Numbers
mov eax,Empty_Number
mov [ebx],eax
mov edx,Food_Numbers
cmp edx,0
jz Winner
jmp End_Function
Winner:
mov ESI, State
mov DWORD PTR[ESI],1
End_Function:
ret
CheckFood ENDP

;Checks the enemy move with the PacMan Move if they are equal the State is Changed to Loser ---> 2.
CheckDeath PROC PPX1:DWORD,PPX2:DWORD,PPY1:DWORD,PPY2:DWORD,EEX1:DWORD,EEX2:DWORD,EEY1:DWORD,EEY2:DWORD
mov eax,PPX1
CMP eax,EEX1
JZ L1
RET
L1:
mov eax,PPX2
CMP eax,EEX2
JZ L2
RET
L2:
mov eax,PPY1
CMP eax,EEY1
JZ L3
RET
L3:
mov eax,PPY2
CMP eax,EEY2
JZ L4
RET
L4:
mov [State],2
RET
CheckDeath ENDP

;Calls the CheckDeath function for all Enemies.
MegaCheckDeath PROC
invoke CheckDeath ,PX1,PX2,PY1,PY2,E1X1,E1X2,E1Y1,E1Y2
mov ESI, State
mov edx,[ESI]
cmp edx,2
JNE L1
ret
L1:
invoke CheckDeath ,PX1,PX2,PY1,PY2,E2X1,E2X2,E2Y1,E2Y2
mov ESI, State
mov edx,[ESI]
cmp edx,2
JNE L2
ret
L2:
invoke CheckDeath ,PX1,PX2,PY1,PY2,E3X1,E3X2,E3Y1,E3Y2
mov ESI, State
mov edx,[ESI]
cmp edx,2
JNE L3
ret
L3:
invoke CheckDeath ,PX1,PX2,PY1,PY2,E4X1,E4X2,E4Y1,E4Y2
ret
MegaCheckDeath ENDP
;------------Pacman-Translations--------------

;Moves PacMan in the 4 Directions.
;UP ---> 1.
;Right ---> 2.
;Down ----> 3.
;Left ----> 4.
MovePacMan PROC
	mov edx,LastKey
	cmp edx,Key
	jz check
	jmp Begin
check:
	mov edx,PX2
	cmp edx,0
	jnz End_Function
	mov edx,PY2
	cmp edx,0
	jnz End_Function
Begin:
	push PX1
	push PX2
	push PY1
	push PY2
	mov edx,Key
	mov LastKey,edx
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
	invoke TranslatePosition,PX1,PX2,PY1,PY2
	sub EBX,1
	mov ESI, PTX
	mov EAX, [ESI]
	mov PX1, EAX
	mov PY1, EBX
	jmp check_Validation
Move_Right:
	Invoke TranslatePosition,PX1,PX2,PY1,PY2
	add EAX, 1
	mov ESI, PTY
	mov EBX, [ESI]
	mov PY1, EBX
	mov PX1, EAX
	jmp check_Validation
Move_Down:
	Invoke TranslatePosition,PX1,PX2,PY1,PY2
	add EBX, 1
	mov ESI, PTX
	mov EAX, [ESI]
	mov PX1, EAX
	mov PY1, EBX
	jmp check_Validation
Move_Left:
	Invoke TranslatePosition,PX1,PX2,PY1,PY2
	sub EAX,1
	mov ESI, PTY
	mov EBX, [ESI]
	mov PY1, EBX
	mov PX1, EAX
	jmp check_Validation
check_Validation:
	INVOKE ValidatePosition,eax,ebx
	mov edx,valid
	cmp valid,1
	jz Finsh
	jmp Out_Of_Range
Out_Of_Range:
	pop Esi
	mov PY2,esi
	pop Esi
	mov PY1,esi
	pop Esi
	mov PX2,esi
	pop Esi
	mov PX1,esi
	jmp End_Function
Finsh:
	pop edx
	pop edx
	pop edx
	pop edx
	mov eax, PX1
	mov ebx, PY1
	mov esi,PTX
	mov [esi],eax
	mov esi,PTY
	mov [esi],ebx
	;invoke CheckFood,PX1,PY1
	;call MegaCheckDeath
	jmp End_Function
End_Function:
	ret

MovePacMan ENDP
;-------------------------AI------------------

;Calls GenerateRandomNumber Function and checks for validation then moves the Enemies on the new index on the Grid.
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
	jmp Begin
Next:
	mov EX2,0
	jmp Continue
Next2:
	mov EY2,0
Begin:
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
	MoveRight:
		inc eax
		jmp Cont
	MoveLeft:
		dec eax
		jmp Cont
	Cont : 
	push eax
	push ebx
	invoke ValidatePosition ,eax, ebx 
	pop ebx
	pop eax
	cmp valid,1
	je correct 
	jmp Start
	correct:
	mov EX1,eax
	mov EY1,ebx
	mov edx,ETX
	mov [edx],eax
	mov edx,ETY
	mov [edx],ebx 
	ret
AIController ENDP

;Calls the AIController Function for all enemies.
AIMegaController PROC
invoke AIController ,E1X1 ,E1X2,E1Y1 ,E1Y2 ,E1TX ,E1TY
invoke AIController ,E2X1 ,E2X2,E2Y1 ,E2Y2 ,E2TX ,E2TY
invoke AIController ,E3X1 ,E3X2,E3Y1 ,E3Y2 ,E3TX ,E3TY
invoke AIController ,E4X1 ,E4X2,E4Y1 ,E4Y2 ,E4TX ,E4TY
AIMegaController ENDP

;----------------------------------------------
;----------------------------------------------
DebugF PROC param:DWORD
	ret
DebugF ENDP

DebugFunction PROC param:DWORD
	mov eax, param
	invoke DebugF, param
	imul eax, 2
	ret
DebugFunction ENDP

DllMain PROC hInstance:DWORD, fdwReason:DWORD, lpReserved:DWORD 
	mov eax, 1
	ret 				
DllMain ENDP
END DllMain