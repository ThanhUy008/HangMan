.data 
	mang_nguoi_choi: .space 12000
	mang_ten: .space 10000
	mang_diem: .space 4000
	mang_luot_choi: .space 4000
	mang_address_nguoichoi: .space 4000
	so_nguoi_choi: .word 0
	mang_nguoi_choi_length: .word 0
	length_mang_ten: .word 0
	DrawTake1: .asciiz "\n _________\n|/       |\n|\n|\n|\n|\n|\t\t"
	DrawTake2: .asciiz " _________\n|/       |\n|        O\n|\n|\n|\n|\t\t"
	DrawTake3: .asciiz " _________\n|/       |\n|        O\n|        |\n|\n|\n|\t\t"
	DrawTake4: .asciiz " _________\n|/       |\n|        O\n|       /|\n|\n|\n|\t\t"
	DrawTake5: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       \n|\n|\t\t "
	DrawTake6: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       /\n|\n|\t\t"
	DrawTake7: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       / \\ \n|\n|\t\t"
	TB2: .asciiz "GAME OVER !!!"
	TB1: .asciiz "\nEnter n : "
	TB5: .asciiz "\n YOU WIN \n"
	TB3: .asciiz "\n NEW GAME\n"
	fin: .asciiz "dethi.txt"
	TB4: .asciiz "\n"
	onedethi: .space 1024
	lengthdethi: .word 1
	savechar: .byte '\0'
	endchar: .byte '*'
	endline: .byte '\0'
	charspacing: .byte '-'
	
	addressspaceing: .byte '\0'
	DrawDeThi: .space 1024
	temp: .word 1
	nguoichoi: .asciiz "nguoichoi.txt"
	arraytennguoichoi: .space 1000
	onetennguoichoi: .space 10
	arraydiem: .space 4000
	arraysolanchoi: .space 4000
	arraystempolanchoi: .space 100
	arraytempdiem: .space 100
	lengthoftemp: .word 1
	arraytennguoichoilength: .space 4000
	arraytennguoichoiaddress: .space 4000
	numberofplayer: .word 1
	curr_player: .space 11 #ten toi da 10 ki tu
	curr_player_name_length: .word 0
        curr_player_score: .word 0
	curr_player_try: .word 0 
	input_name_player: .asciiz "\n Enter your name:\n"
        messPlayerChoice: .asciiz "\n Nhap 0 de tra loi voi 1 ki tu, 1 de tra loi toan bo\n"
	messOneChar:	.asciiz "\n Nhap  ki tu ban muon doan\n"
	messString:	.asciiz "\n Nhap  chuoi ban muon tra loi\n"
	answByOneChar: .space 2
	answByString: .space 100
	answStringLength: .word 0
	maxRanNum: .word 0
	arrayRanNum: .space 100

	arrayNumOfCharExisted: .space 400
	arrayNumOfCharExistedLength: .word 0
.text
	.globl main
main:



	#Read Player File here : 
	# $a0: address of filename variable
# $a1: address of char array to be stored
# $v0: array size
	la $a0,nguoichoi
	la $a1,mang_nguoi_choi
        jal read_player
	sw $v0,mang_nguoi_choi_length

# store player infomation from original content to corresponding arrays
# $a0 address of file content
# $a1 size of that char array
# $v0 number of player extracted
	la $a0,mang_nguoi_choi
	lw $a1,mang_nguoi_choi_length
	jal extract_player
	sw $v0,so_nguoi_choi
	sw $v1,length_mang_ten

GameStart:
	
	jal _input_name
	sw $v1,curr_player_name_length

        li $t6,0 #try time

	li $t7,0 #score
	li $t9,0
GameNew:

	li $v0,4
	la $a0,TB3
	syscall
	

	jal _ReadDeThi
	add $t7,$t7,$t9 #tang score
	
	li $t9,0
	
	addi $t6,$t6,1
	lw $t8,lengthdethi #flag
	
	li $t2,-1
	sw $t2,arrayNumOfCharExisted
	li $t3,1
	li $t2,1 
	sw $t3,arrayNumOfCharExistedLength
	li $t0,0
GameLoop:
	#draw hangman 
	move $a1,$t2
	jal _DrawHangMan
GameLoop.LoopOpenWordByCharBegin:
	
	la $s1,arrayNumOfCharExisted
	lw $t3,arrayNumOfCharExistedLength
	
GameLoop.LoopOpenWordByChar:
	lw $a1,($s1)
	beq $a1,-3,_noIncreaseScore
	beq $a1,-2,_addFullScore
	beq $a1,-1,_noIncreaseScore
	 j _IncreaseScore
_addFullScore:
	add $t9,$zero,$t8
	
	jal _DrawWord
	
	la $a0,DrawDeThi
	li $v0,4
	syscall

	li $v0,4
	la $a0,TB5
	syscall

	j GameNew

_noIncreaseScore:
	j _Draw
_IncreaseScore:
	addi $t9,$t9,1

_Draw:
	jal _DrawWord
	addi $s1,$s1,4
	addi $t0,$t0,1
	blt $t0,$t3,GameLoop.LoopOpenWordByChar
	
	la $a0,DrawDeThi
	li $v0,4
	syscall
	#endl
	li $v0,4
	la $a0,TB4
	syscall

	li $t0,0

	beq $t9,$t8,GameNew #if endgame


ContinuePlay:
	
	jal _input_from_player
	beq $v1,1,GameLoop.CheckWord
	beq $v1,2,GameLoop.CheckString

GameLoop.CheckWord:
	
	lw $s7,arrayNumOfCharExisted
	bne $s7,-3,GameLoop
	#bnez $t0,GameLoop
	
	addi $t2,$t2,1  #guess wrong
	blt $t2,7,GameLoop
	j GameLoop.EndGame

GameLoop.CheckString:
	lw $t4,lengthdethi
	beq $t4,$v0,_createFullLength
	sw $v0,arrayNumOfCharExisted
	li $v0,1
	sw $v0,arrayNumOfCharExistedLength
	addi $t2,$t2,1
	blt $t2,7,GameLoop
	j GameLoop.EndGame

_createFullLength:
	li $t3,-2
	sw $t3,arrayNumOfCharExisted
	li $t5,1
	sw $t5,arrayNumOfCharExistedLength
	
	j GameLoop

GameLoop.EndGame:
	

	sw $t7,curr_player_score
	sw $t6,curr_player_try
	li $a1,7
	jal _DrawHangMan

	li $v0,4
	la $a0,TB2
	syscall
	
	#Add curr_score,curr_try in mang_diem, mang_luot_choi
	lw $t2,so_nguoi_choi
	li $t1,4
	mul $t3,$t1,$t2
	la $t4,curr_player
	la $s1,mang_address_nguoichoi
	la $s2,mang_diem
	la $s3,mang_luot_choi
	la $s4,mang_ten
	add $s1,$s1,$t3
	add $s2,$s2,$t3
	add $s3,$s3,$t3
	
	lw $t4,curr_player_score
	sw $t4,($s2)
	lw $t4,curr_player_try
	sw $t4,($s3)
	
#add curr_name in mang_ten	
	
	lw $t3,length_mang_ten
	add $s4,$s4,$t3
	addi $s4,$s4,1	
	sw $s4,($s1) #save new curr_name address in mang_address
	lw $t3,curr_player_name_length
	li $t0,0
loopadd:
	lb $t2,($t4)
	sb $t2,($s4)
	addi $s4,$s4,1
	addi $t4,$t4,1
	addi $t0,$t0,1
	blt $t0,$t3,loopadd

	#tang so nguoi choi
	lw $t2,so_nguoi_choi
	addi $t2,$t2,1
	sw $t2,so_nguoi_choi
	#sort
	move $a0,$t2
	la $a1,mang_diem
	la $a2,mang_address_nguoichoi
	la $a3,mang_luot_choi
	jal _sort_players_descending

	#tTODO : Print first ten name	
	
	
	li $v0,10
	syscall

	

#a0 = length arr
#a1 = array int
#a2 = array name address
#a3 = array try times
	
	#ket thuc
	li $v0,10
	syscall



###########################################Funtion:
_ReadNguoiChoiFile:
		addi $sp,$sp,-64
		sw $ra,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
		sw $t2,12 ($sp)
		sw $t3,16($sp)
		sw $t4,20($sp)
		sw $s0,24($sp)
		sw $s1,28($sp)
		sw $s2,32($sp)
		sw $s3,36($sp)
		sw $s4,40($sp)
		sw $s5,44($sp)
		sw $s6,48($sp)
		sw $t8,52($sp)
		sw $t9,56($sp)
		sw $t7,60($sp)
		sw $t6,64($sp)
	li   $v0, 13       # system call for open file
	la   $a0, nguoichoi      # input file name
	li   $a1, 0        # flag for reading
	li   $a2, 0        # mode is ignored
	syscall            # open a file 
	move $s0, $v0      # save the file descriptor 

	li $t4,0 #count number of player
	la $s1,arraytennguoichoi
	la $s2,arraydiem
	la $s3,arraytennguoichoilength
	la $s5,arraytennguoichoiaddress
	la $s6,arraysolanchoi
_ReadNguoiChoiFile.OuterLoop:
	li $t2,0 #count length of name
	la $s4,onetennguoichoi #temp string
	sw $s1,($s5)
_ReadNguoiChoiFile.InnerLoop:
	move $a0,$s0
	li $v0,14
	la $a1,savechar
	li $a2,1
	syscall #read 1 byte

	beqz $v0,_ReadNguoiChoiFile.EndLoop #check if eof
	
	lb $t1,savechar
	lb $t3,charspacing
	beq $t1,$t3,_ReadNguoiChoiFile.EnterScore #check if reach score
		

	#lw $t3,endchar
	#beq $t1,$t3,EndInnerLoop #check if end of string name
	
	sb $t1,($s4) #if still name, load it into temp string
	addi $s4,$s4,1 #tempstring[i++]	
	addi $t2,$t2,1 #count lenght ++

	j _ReadNguoiChoiFile.InnerLoop


_ReadNguoiChoiFile.EndInnerLoop:
	#addi $t2,$t2,1 #for the '\0'
	sw $t2,($s3) #luu do dai ten nguoi choi
	
	addi $s3,$s3,4 #tang dia chi $s3
	
	addi $t4,$t4,1 #tang so luong nguoi choi
	
	addi $s5,$s5,4	#tang address 
	
	la $a0,arraystempolanchoi
	move $a1,$t6
	jal str_to_int
	sw $v0,($s6)
	addi $s6,$s6,4
	#  atoi($t7) , length = $t6
		

	move $a0,$s1
	la $a1,onetennguoichoi
	move $a3,$s3
	move $a2,$t2
	jal _Loadplayerinplayerlist
	
	addi $t2,$t2,1 #for the '/0'
	#add $s3,$s3,4 #tang dia chi address
	add $s1,$s1,$t2 #tang dia chi array

	j _ReadNguoiChoiFile.OuterLoop
_ReadNguoiChoiFile.EndLoop:

	j _ReadNguoiChoiFile.KetThuc
_ReadNguoiChoiFile.EnterScore:
##################3#Wait for atoi
	la $t7,arraytempdiem
	li $t6,0
_ReadNguoiChoiFile.EnterScoreLoop:
	move $a0,$s0
	li $v0,14
	la $a1,savechar
	li $a2,1
	syscall #read 1 byte
	
	#beqz $v0,_ReadNguoiChoiFile.EndInnerLoop #check if eof

	lb $t9,savechar
	lb $t8,charspacing
	
	beq $t9,$t8,_ReadNguoiChoiFile.EnterTryTimes
	
	#lb $t8,endchar
	#beq $t9,$t8,_ReadNguoiChoiFile.EndInnerLoop
	
	sb $t9,($t7) 
	addi $t7,$t7,1
	addi $t6,$t6,1
	j _ReadNguoiChoiFile.EnterScoreLoop

_ReadNguoiChoiFile.EnterTryTimes:
	
	#  atoi($t7) , length = $t6
	la $a0,arraytempdiem
	move $a1,$t6
	jal str_to_int
	
	sw $v0,($s2)
	addi $s2,$s2,4
	la $t7,arraystempolanchoi
	li $t6,0
_ReadNguoiChoiFile.EnterTryTimesLoop:
	move $a0,$s0
	li $v0,14
	la $a1,savechar
	li $a2,1
	syscall #read 1 byte
	
	beqz $v0,_ReadNguoiChoiFile.EndInnerLoop #check if eof

	lb $t9,savechar
	#lb $t8,charspacing
	
	#beq $t9,$t8,_ReadNguoiChoiFile.EnterTryTimes
	
	lb $t8,endchar
	beq $t9,$t8,_ReadNguoiChoiFile.EndInnerLoop
	
	sb $t9,($t7) 
	addi $t7,$t7,1
	addi $t6,$t6,1
	j _ReadNguoiChoiFile.EnterTryTimesLoop

_ReadNguoiChoiFile.KetThuc:

		sw $t4,numberofplayer

		lw $ra,0($sp)
		lw $t0,4($sp)
		lw $t1,8 ($sp)
		lw $t2,12 ($sp)
		lw $t3,16($sp)
		lw $t4,20($sp)
		lw $s0,24($sp)
		lw $s1,28($sp)
		lw $s2,32($sp)
		lw $s3,36($sp)
		lw $s4,40($sp)
		lw $s5,44($sp)
		lw $s6,48($sp)
		lw $t8,52($sp)
		lw $t9,56($sp)
		lw $t7,60($sp)
		addi $sp,$sp,60
		jr $ra




_Loadplayerinplayerlist:
	
		addi $sp,$sp,-32
		sw $ra,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
		sw $s0,12 ($sp)
		sw $s1,16($sp)
		sw $t2,20($sp)
		sw $s2,24($sp)
		sw $t3,28($sp)

		lb $t3,endline
		move $s0,$a0 #array nguoi choi
		move $s1,$a1 #temp string
		move $t1,$a2 #length string
		#move $s2,$a3 #array address
		li $t0,0
		
		
_Loadplayerinplayerlist.Loop:
		lb $t2,($s1)
		sb $t2,($s0)
		addi $s1,$s1,1
		addi $s0,$s0,1
		addi $t0,$t0,1
		blt $t0,$t1,_Loadplayerinplayerlist.Loop
	
		
		

		sb $t3,($s0) #add endline
		addi $s0,$s0,1
		#sw $t1,($s2) #add address
		
		lw $ra,0($sp)
		lw $t0,4($sp)
		lw $t1,8 ($sp)
		lw $s0,12 ($sp)
		lw $s1,16($sp)
		lw $t2,20($sp)
		lw $s2,24($sp)
		lw $t3,28($sp)
		
		addi $sp,$sp,32
		jr $ra









#Funtion to draw hang man
#input : an interger N in $a1 as the number of wrong guess
#output: draw hangman on the screen
_DrawHangMan:
		addi $sp,$sp,-32
		sw $ra,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
		sw $s0,12 ($sp)
		sw $s1,16($sp)
		sw $a0,20($sp)
		move $t0,$a1 #save n in t0
		
		beq $t0,1,_DrawHangMan.DrawTake1
		beq $t0,2,_DrawHangMan.DrawTake2
		beq $t0,3,_DrawHangMan.DrawTake3
		beq $t0,4,_DrawHangMan.DrawTake4
		beq $t0,5,_DrawHangMan.DrawTake5
		beq $t0,6,_DrawHangMan.DrawTake6
		beq $t0,7,_DrawHangMan.DrawTake7
		
_DrawHangMan.DrawTake1:
		li $v0,4
		la $a0,DrawTake1
		syscall
		j _DrawHangMan.End
_DrawHangMan.DrawTake2:
		li $v0,4
		la $a0,DrawTake2
		syscall
		j _DrawHangMan.End
_DrawHangMan.DrawTake3:
		li $v0,4
		la $a0,DrawTake3
		syscall
		j _DrawHangMan.End
_DrawHangMan.DrawTake4:
		li $v0,4
		la $a0,DrawTake4
		syscall
		j _DrawHangMan.End
_DrawHangMan.DrawTake5:
		li $v0,4
		la $a0,DrawTake5
		syscall
		j _DrawHangMan.End
_DrawHangMan.DrawTake6:
		li $v0,4
		la $a0,DrawTake6
		syscall
		j _DrawHangMan.End
_DrawHangMan.DrawTake7:
		li $v0,4
		la $a0,DrawTake7
		syscall
	
_DrawHangMan.End:
		lw $ra,0($sp)
		lw $t0,4($sp)
		lw $t1,8 ($sp)
		lw $s0,12 ($sp)
		lw $s1,16($sp)
		lw $a0,20($sp)
		
		addi $sp,$sp,32
		jr $ra
##Read Dethi

# $a1 have the random number
#return length of de thi in lengthdethi
#return array of char dethi in onedethi
_ReadDeThi:
		addi $sp,$sp,-48
		sw $ra,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
		sw $t2,12 ($sp)
		sw $t3,16($sp)
		sw $t4,20($sp)
		sw $t5,24($sp)
		sw $s0,28($sp)
		sw $s1,32($sp)
		sw $t6,36($sp)
		sw $t7,40($sp)
		sw $t8,44($sp)
		sw $t9,48($sp)
		
		#move $t3,$a1 #save n in t0
		
	li   $v0, 13       # system call for open file
	la   $a0, fin      # input file name
	li   $a1, 0        # flag for reading
	li   $a2, 0        # mode is ignored
	syscall            # open a file 
	move $s0, $v0      # save the file descriptor 
	
#get max num:
	la $s1,arrayRanNum
	li $t6,0 #length
_ReadDeThi.GetMaxNum:
	move $a0,$s0
	li $v0,14
	la $a1,savechar
	li $a2,1
	syscall #read 1 byte
	
	#beqz $v0,_ReadNguoiChoiFile.EndInnerLoop #check if eof

	lb $t9,savechar
	lb $t8,charspacing
	
	beq $t9,$t8,_ReadDeThi.ConvertMaxNum #end num
	
	#lb $t8,endchar
	#beq $t9,$t8,_ReadNguoiChoiFile.EndInnerLoop
	
	sb $t9,($s1) 
	addi $s1,$s1,1
	addi $t6,$t6,1
	j _ReadDeThi.GetMaxNum

_ReadDeThi.ConvertMaxNum:
	la $a0,arrayRanNum
	move $a1,$t6
	jal str_to_int
	
	sw $v0,maxRanNum
	
#ran num
	li $v0,42
	lw $a1,maxRanNum
	syscall
	add $a0,$a0,1
	move $t3,$a0

	li $t4,0
_ReadDeThi.OuterLoop:


	li $t2,0 #count length
	la $s1,onedethi
_ReadDeThi.InnerLoop:
	
	move $a0,$s0
	li $v0,14
	la $a1,savechar
	li $a2,1
	syscall
	#check if end of file
	beqz $v0,_ReadDeThi.EndLoop
	#check if end of word
	lb $t0,savechar 
	lb $t1,endchar
	beq $t0,$t1,_ReadDeThi.EndLoop
#save char to array:
	addi $t2,$t2,1 #length++
	sb $t0,($s1) #a[i++] = $t0 (savechar)
	addi $s1,$s1,1
	j _ReadDeThi.InnerLoop
_ReadDeThi.EndLoop:
	sw $t2,lengthdethi
	addi $t4,$t4,1
	blt $t4,$t3,_ReadDeThi.OuterLoop
	li $a0,0
	sb $a0,($s1)
#close file	
	li $v0,16
	move $a0,$s0
	syscall


	lw $ra,0($sp)
	lw $t0,4($sp)
	lw $t1,8 ($sp)
	lw $t2,12 ($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	lw $t5,24($sp)
	lw $s0,28($sp)
	lw $s1,32($sp)
	lw $t6,36($sp)
	lw $t7,40($sp)
	lw $t8,44($sp)
	lw $t9,48($sp)
	addi $sp,$sp,48
	jr $ra
#################################

#a0 = length arr
#a1 = array int
#a2 = array name address
#a3 = array try times
_sort_players_descending:
	addi $sp, $sp, -44
	sw $t6, ($sp)
	sw $s0, 4($sp) #luu gia tri n
	sw $s1, 8($sp) #luu gia tri arr
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $t2, 20($sp)
	sw $s2,24($sp)
	sw $s3,28($sp)
	sw $t3,32($sp)
	sw $t4,36($sp)
	sw $t5,40($sp)
	sw $ra,44($sp)
	#luu tham so $a0,$a1 vao thanh ghi
	move $s0, $a0
	move $s1, $a1 #array score
	move $s2,$a2 #array name address
	move $s3,$a3 #array try time
_sort_players_descending.loop:
	#sap xep mang con
	#truyen tham so cho ham xuat mang
	move $a0,$s0
	
	move $a1, $s1 #array score
	move $a2,$s2 #array name address
	move $a3,$s3 #array try time
	
	#la $a1, ($s1)
	
	#goi ham sap xep mang ccn
	jal _sort_nguoichoi_array
	
	#khong tang dia chi cua a1 
	#tang chi so i
	addi $t0, $t0, 1
	
	#kiem tra i < n thi lap
	blt $t0, $s0, _sort_players_descending.loop

#cuoi thu tuc
	#restore
	lw $t6, ($sp)
	lw $s0, 4($sp) #luu gia tri n
	lw $s1, 8($sp) #luu gia tri arr
	lw $t0, 12($sp) #chay vong lap
	lw $t1, 16($sp) #thanh ghi tam chua gia tri a[n]
	lw $t2, 20($sp) #thanh ghi tam chua gia tri a[n+1]
	lw $s2,24($sp)
	lw $s3,28($sp)
	lw $t3,32($sp)
	lw $t4,36($sp)
	lw $t5,40($sp)
	lw $ra,44($sp)
	#khoi phuc lai stack
	addi $sp, $sp, 44
	#nhay ve
	jr $ra			
	
#a0 = length arr
#a1 = array int
#a2 = array name address
#a3 = array try times
_sort_nguoichoi_array:
	#dau thu tuc
	addi $sp, $sp, -44
	sw $t6, ($sp)
	sw $s0, 4($sp) #luu gia tri n
	sw $s1, 8($sp) #luu gia tri arr
	sw $t0, 12($sp) #chay vong lap
	sw $t1, 16($sp) #thanh ghi tam chua gia tri a[n]
	sw $t2, 20($sp) #thanh ghi tam chua gia tri a[n+1]
	sw $s2,24($sp)
	sw $s3,28($sp)
	sw $t3,32($sp)
	sw $t4,36($sp)
	sw $t5,40($sp)
	sw $ra,44($sp)
	#luu tham so $a0,$a1 vao thanh ghi
	addi $s0, $a0, 0
	addi $s0,$s0,-1
	move $s1, $a1 #array score
	move $s2,$a2 #array name address
	move $s3,$a3 #array try time
#than thu tuc
	#khoi tao vong lap
	li $t0, 0
_sort_nguoichoi_array.loop:
	#so sanh phan tu hien tai 
	#load 2 phan tu hien tai
	lw $t1, ($s1)
	lw $t2, 4($s1)

	lw $t3,($s2)
	lw $t4,4($s2)

	lw $t5,($s3)
	lw $t6,4($s3)

	#neu  a[n] < a[n+1] thi swap
	blt $t2, $t1, _sort_nguoichoi_array.not_swap
	sw $t2, ($s1)
	sw $t1, 4($s1)

	sw $t4,($s2)
	sw $t3,4($s2)

	sw $t6,($s3)
	sw $t5,4($s3)

_sort_nguoichoi_array.not_swap:
	
	#tang dia chi cua $a1
	addi $s1, $s1, 4
	addi $s2,$s2,4 #add name address to next
	addi $s3,$s3,4 #add try time to next
	#tang chi so i
	addi $t0, $t0, 1
	
	#kiem tra i < n thi lap
	blt $t0, $s0, _sort_nguoichoi_array.loop
#cuoi thu tuc
	#restore
	lw $t6, ($sp)
	lw $s0, 4($sp) #luu gia tri n
	lw $s1, 8($sp) #luu gia tri arr
	lw $t0, 12($sp) #chay vong lap
	lw $t1, 16($sp) #thanh ghi tam chua gia tri a[n]
	lw $t2, 20($sp) #thanh ghi tam chua gia tri a[n+1]
	lw $s2,24($sp)
	lw $s3,28($sp)
	lw $t3,32($sp)
	lw $t4,36($sp)
	lw $t5,40($sp)
	lw $ra,44($sp)
	#khoi phuc lai stack
	addi $sp, $sp, 44
	#nhay ve
	jr $ra				

############Draw line
_DrawWord:
		addi $sp,$sp,-32
		sw $ra,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
		sw $t2,12 ($sp)
		sw $t3,16($sp)
		sw $t4,20($sp)
		sw $t5,24($sp)
		sw $s0,28($sp)
		sw $s1,32($sp)
		move $t3,$a1 #save n in t0
		li $t0,0 #i = 0
		la $s1,DrawDeThi
		la $s0,onedethi
		lw $t4,lengthdethi

		beq $t3,-1,_DrawWord.FirstInit
		beq $t3,-2,_DrawWord.FullAnwer
		beq $t3,-3,_DrawWord.End
_DrawWord.openword:
	lb $t2,($s0) #$t2 = onedethi[i]
	beq $t0,$t3,_DrawWord.loadword #check if i = x
	
_DrawWord.afterloadword:
	addi $t0,$t0,1 #i++
	addi $s0,$s0,1 #onedethi[i++]
	addi $s1,$s1,1 #drawdethi[i++]
	blt $t0,$t4,_DrawWord.openword
	j _DrawWord.Print
_DrawWord.loadword:
	sb $t2,($s1)
	j _DrawWord.afterloadword

	
_DrawWord.FirstInit:

	lb $t5,endchar
	sb $t5,($s1)
	addi $t0,$t0,1
	addi $s1,$s1,1
	blt $t0,$t4,_DrawWord.FirstInit	
	j _DrawWord.Print

_DrawWord.FullAnwer:
	lb $t2, ($s0)
	sb $t2, ($s1)
	addi $s0,$s0,1
	addi $s1,$s1,1
	addi $t0,$t0,1
	blt $t0,$t4,_DrawWord.FullAnwer
	
_DrawWord.Print:
	li $a0,0
	sb $a0,($s1)
_DrawWord.End:
#	la $s1,DrawDeThi
#_DrawWord.Print.loop:	
#	addi $t0,$t0,1
#	addi $s1,$s1,1
#	blt $t0,$t4,_DrawWord.Print.loop
	#li $v0,4
	#la $a0,endline
	#syscall
		lw $ra,0($sp)
		lw $t0,4($sp)
		lw $t1,8 ($sp)
		lw $t2,12 ($sp)
		lw $t3,16($sp)
		lw $t4,20($sp)
		lw $t5,24($sp)
		lw $s0,28($sp)
		lw $s1,32($sp)
		addi $sp,$sp,32
		jr $ra

#--------input_name-------#
_input_name:
    
    		addi $sp,$sp,-32
		sw $ra,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
			
    li $v0,4	#xuat thong bao
    la $a0,input_name_player
    syscall
    li $v0, 8       	#  input ten nguoi choi
    la $a0, curr_player  
    li $a1, 11     

    syscall

    la $a0,curr_player    
	
    jal _strlen              
    
   		lw $ra,0($sp)
		lw $t0,4($sp)
		lw $t1,8 ($sp)
        	addi $sp,$sp,32
		jr $ra


#a0 = adress string
#v1 length	
_strlen:

		addi $sp,$sp,-32
		sw $ra,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
		sw $t2,12($sp)
		sw $s1,16($sp)

		move $s1,$a0

	li $t0, 0 	# khoi tao bien dem bang 0
	li $t2,10 	#ki tu new line
_strlen.loop:
	
	lb $t1, 0($s1) 	  # load ki tu tiep theo vao t1
	beq $t1,$t2 _strlen.exit #kiem tra ki tu newline
	beqz $t1,_strlen.exit	  # kiem tra ki tu rong
	addi $s1, $s1, 1  # tang con tro cua chuoi
	addi $t0, $t0, 1  # tang bien dem
	
	j _strlen.loop 		  # quay lai vong lap
_strlen.exit:
	move $v1,$t0

		lw $ra,0($sp)
		lw $t0,4($sp)
		lw $t1,8 ($sp)
		lw $t2,12($sp)
		lw $s1,16($sp)

	addi $sp,$sp,32
	jr $ra

# read players from file and store in mang_ten, mang_diem, mang_luot
# $a0: address of filename variable
# $a1: address of char array to be stored
# $v0: array size
read_player:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $t0, 4($sp)
	sw $t1, ($sp)
	
	move $t0, $a1
	
	li $v0, 13
	# la $a0, filename
	li $a1, 0
	li $a2, 0
	syscall
	move $a0, $v0
	
	li $v0, 14
	move $a1, $t0
	li $a2, 1000
	syscall
	move $t0, $v0
	
	li $v0, 16
	syscall
	
	move $v0, $t0
	
	lw $ra, 8($sp)
	lw $t0, 4($sp)
	lw $t1, ($sp)
	addi $sp, $sp, 12
	jr $ra

# str address at $a0, length at $a1, int val $v0
str_to_int:
	addi $sp, $sp, -28
	sw $ra, 24($sp)
	sw $t0, 20($sp)
	sw $t1, 16($sp)
	sw $t2, 12($sp)
	sw $t3, 8($sp)
	sw $t4, 4($sp)
	sw $t5, ($sp)
	
	move $t2, $a0
	move $t1, $a1
	li $t3, 0
	li $t4, 10
	li $t5, 0
str_to_int.Loop:
	lb $t0, ($t2) 
	andi $t0,$t0,0x0F
	mul $t3, $t3, $t4
	add $t3, $t3, $t0
	addi $t2, $t2, 1
	addi $t5, $t5, 1
	bne $t5, $t1, str_to_int.Loop
	
	move $v0, $t3
	
	lw $ra, 24($sp)
	lw $t0, 20($sp)
	lw $t1, 16($sp)
	lw $t2, 12($sp)
	lw $t3, 8($sp)
	lw $t4, 4($sp)
	lw $t5, ($sp)
	addi $sp, $sp, 28
	jr $ra


# store player infomation from original content to corresponding arrays
# $a0 address of file content
# $a1 size of that char array
# $v0 number of player extracted
# $v1 length mang_ten
extract_player:
	addi $sp, $sp, -44
	sw $ra,40($sp)
	sw $t8,36($sp)
	sw $s1, 32($sp)
	sw $t0, 28($sp)
	sw $t1, 24($sp)
	sw $t2, 20($sp)
	sw $t3, 16($sp)
	sw $t4, 12($sp)
	sw $t5, 8($sp)
	sw $t6, 4($sp)
	sw $t7, ($sp)
	
	move $t0, $a0
	la $t1, mang_ten
	la $t2, mang_diem
	la $t3, mang_luot_choi
	la $s1,mang_address_nguoichoi
	la $t7, 0
	li $t8,0 #length mang_ten
	#TODO special case zero string
	blez $a1, extract_player.empty
	#move $a0, $t0
	#li $v0, 4
	#syscall
	
extract_player.player:
	move $t4, $t1
	#save address
	
	sw $t4,($s1)
	addi $s1,$s1,4

extract_player.loop_inner:
	lb $t5, ($t0)
	beq $t5, '-', extract_player.point1
	sb $t5, ($t4)
	addi $t4, $t4, 1
	addi $t0, $t0, 1
	addi $t8,$t8,1 #length mang_ten
	j extract_player.loop_inner
extract_player.point1:
	li $t5, 0
	sb $t5, ($t4)
	addi $t8,$t8,1 #length mang_ten
	addi $t1, $t1, 11
	addi $t0, $t0, 1
	li $t6, 0
extract_player.point1.loop:
	lb $t5, ($t0)
	beq $t5, '-', extract_player.point2
	addi $t6, $t6, 1
	addi $t0, $t0, 1
	j extract_player.point1.loop
extract_player.point2:
	sub $a0, $t0, $t6
	move $a1, $t6
	jal str_to_int
	sw $v0, ($t2)
	addi $t2, $t2, 4
	addi $t0, $t0, 1
	
	li $t6, 0
extract_player.point2.loop:
	lb $t5, ($t0)
	beq $t5, '*', extract_player.done
	addi $t6, $t6, 1
	addi $t0, $t0, 1
	j extract_player.point2.loop
extract_player.done:
	sub $a0, $t0, $t6
	move $a1, $t6
	jal str_to_int
	sw $v0, ($t3)
	addi $t3, $t3, 4
	
	addi $t7, $t7, 1
	addi $t0, $t0, 1
	lb $t5, ($t0)
	bgtz $t5, extract_player.player

extract_player.empty:
	move $v0, $t7
	move $v1,$t8
	lw $ra,40($sp)
	lw $t8,36($sp)
	lw $s1, 32($sp)
	lw $t0, 28($sp)
	lw $t1, 24($sp)
	lw $t2, 20($sp)
	lw $t3, 16($sp)
	lw $t4, 12($sp)
	lw $t5, 8($sp)
	lw $t6, 4($sp)
	lw $t7, ($sp)
	addi $sp, $sp, 44
	jr $ra

# write to file from buffer
# a0: address of output file name
# a1: buffer address
write_players:
	addi $sp, $sp, -12
	sw $ra, 8 ($sp)
	sw $t0, 4 ($sp)
	sw $t1, ($sp)

	move $t0, $a1
	
	li $v0, 13
	#la $a0, fout_name
	li $a1, 1
	li $a2, 0
	syscall
	move $t1, $v0
	
	move $a1, $t0
	
	li $v0, 15
	move $a0, $t1
	#la $a1, mang_nguoi_choi
	li $a2, 1000
	syscall
	
	li $v0, 16
	move $a0, $t1
	
	lw $ra, 8 ($sp)
	lw $t0, 4 ($sp)
	lw $t1, ($sp)
	addi $sp, $sp, 12
	jr $ra

# $a0: int value
# $a1: address to write to buffer
# $v0: number of characters
int_to_str:
	addi $sp, $sp, -28
	sw $ra, 24($sp)
	sw $t0, 20($sp)
	sw $t1, 16($sp)
	sw $t2, 12($sp)
	sw $t3, 8($sp)
	sw $t4, 4($sp)
	sw $t5, ($sp)
	
	move $t0, $a0
	li $t1, 10
	li $t2, '0'
	li $t5, 0
int_to_str.load_loop:
	div $t0, $t1
	
	mfhi $t4
	add $t3, $t2, $t4
	mflo $t0
	
	addi $sp, $sp, -1
	sb $t3, ($sp)
	
	addi $t5, $t5, 1
	bgtz $t0, int_to_str.load_loop
	
	move $v0, $t5
	
	move $t2, $a1
int_to_str.store_loop:
	lb $t0, ($sp)
	addi $sp, $sp, 1
	addi $t5, $t5, -1
	sb $t0, ($t2)
	addi $t2, $t2, 1
	bgtz $t5, int_to_str.store_loop
	
	
	lw $ra, 24($sp)
	lw $t0, 20($sp)
	lw $t1, 16($sp)
	lw $t2, 12($sp)
	lw $t3, 8($sp)
	lw $t4, 4($sp)
	lw $t5, ($sp)
	addi $sp, $sp, 28
	jr $ra

# compose characters need to write to a buffer
# a0: address of buffer to store on
# a1: number of player to store
compose_players:
	addi $sp, $sp, -32
	sw $ra, 28($sp)
	sw $t0, 24($sp)
	sw $t1, 20($sp)
	sw $t2, 16($sp)
	sw $t3, 12($sp)
	sw $t4, 8($sp)
	sw $t5, 4($sp)
	sw $t6, ($sp)

	move $t0, $a0
	move $t1, $a1
	la $t2, mang_ten
	la $t3, mang_diem
	la $t4, mang_luot_choi
compose_players.write_player:
	move $t5, $t2
compose_players.copy:
	lb $t6, ($t5)
	blez $t6, compose_players.exit_copy
	sb $t6, ($t0)
	
	addi $t5, $t5, 1
	addi $t0, $t0, 1
	j compose_players.copy
compose_players.exit_copy:
	addi $t2, $t2, 11
	li $t6, '-'
	sb $t6, ($t0)
	addi $t0, $t0, 1
	
	lw $a0, ($t3)
	move $a1, $t0
	jal int_to_str
	add $t0, $t0, $v0 # update pointing address
	
	addi $t3, $t3, 4
	
	li $t6, '-'
	sb $t6, ($t0)
	addi $t0, $t0, 1
	
	lw $a0, ($t4)
	move $a1, $t0
	jal int_to_str
	add $t0, $t0, $v0 # update pointing address
	
	addi $t4, $t4, 4
	
	li $t6, '*'
	sb $t6, ($t0)
	addi $t0, $t0, 1
	
	addi $t1, $t1, -1
	bgtz $t1, compose_players.write_player
	
	li $t6, 0
	sb $t6, ($t0)
	
	
	lw $ra, 28($sp)
	lw $t0, 24($sp)
	lw $t1, 20($sp)
	lw $t2, 16($sp)
	lw $t3, 12($sp)
	lw $t4, 8($sp)
	lw $t5, 4($sp)
	lw $t6, ($sp)
	addi $sp, $sp, 32
	
	jr $ra

#------Input from Player------#
_input_from_player:
	
		addi $sp,$sp,-12
		sw $v0,0($sp)
		sw $t0,4($sp)
		sw $ra,8($sp)
		
	li $v0,4
	la $a0,messPlayerChoice #xuat lua chon cua nguoi choi
	syscall
	
	li $v0,5	#luu gia tri  lua chon
	syscall
	move $t0,$v0
	
	beqz $t0,_input_one_char #=0  nhay den _input_one_char
	bgtz $t0,_input_string  #=1  nhay den _input_string
	
	li $v0,10
	syscall
_input_one_char:
	li $v0,4
	la $a0,messOneChar
	syscall
	
	li $v0,8
	la $a0,answByOneChar #luu ki tu vao answByOneChar
	li $a1,2
	syscall
	
	la $a0,answByOneChar
	la $a1,onedethi
	la $a2,lengthdethi
	jal _IfWordExisted
	
########################################	
		

		lw $v0,0($sp)
		lw $t0,4($sp)
		lw $ra,8($sp)
	addi $sp,$sp,12
		
	move $v0,$v1
	li $v1,1
	jr $ra

_input_string:
	li $v0,4
	la $a0,messString
	syscall
	
	li $v0,8
	la $a0,answByString #luu chuoi vao answByString
	li $a1,100
	syscall
	
	la $a0,answByString
	jal _strlen
	
	sw $v1,answStringLength
	
	la $a0,answByString
	la $a1,answStringLength
	la $a2,onedethi
	la $a3,lengthdethi
	jal _StrCompare
######################################
	
		lw $v0,0($sp)
		lw $t0,4($sp)
		lw $ra,8($sp)
	addi $sp,$sp,12
	move $v0,$v1
	li $v1,2
	jr $ra






##################Check
#a0 = keyword input
#a1 = address onedethi
#a2 = address length one dethi
#
_IfWordExisted:
		addi $sp,$sp,-40
		sw $ra,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
		sw $t2,12 ($sp)
		sw $t3,16($sp)
		sw $t4,20($sp)
		sw $t5,24($sp)
		sw $s0,28($sp)
		sw $s1,32($sp)
		sw $s2,36($sp)
		sw $s3,40($sp)
		move $s1,$a0 #answer by one char
		move $s2,$a1 #one de thi
		move $t1,$a2 #length dethi
		li $t0,-3
		sw $t0,arrayNumOfCharExisted
		
		la $s3,arrayNumOfCharExisted
		
		lw $t4,($t1)
		
		li $t1,0 #arrayNumOfCharExisted length
		li $t0,0 #i = 0
		lb $t2,($s1)

_IfWordExisted.Loop:
		lb $t3,($s2) #onedethi[i]
		
		beq $t3,$t2,_IfWordExisted.Add

_IfWordExisted.Continue:
		
		addi $s2,$s2,1
		addi $t0,$t0,1
		blt $t0,$t4,_IfWordExisted.Loop

		j _IfWordExisted.End

_IfWordExisted.Add:
		
		sw $t0,($s3)
		addi $s3,$s3,4
		addi $t1,$t1,1
		j _IfWordExisted.Continue

_IfWordExisted.End:
		
		beqz $t1,_add1
		j _notadd1
_add1:
		addi $t1,$t1,1
_notadd1:		
		move $v1,$t1
		
		sw $t1,arrayNumOfCharExistedLength
		
		

		lw $ra,0($sp)
		lw $t0,4($sp)
		lw $t1,8 ($sp)
		lw $t2,12 ($sp)
		lw $t3,16($sp)
		lw $t4,20($sp)
		lw $t5,24($sp)
		lw $s0,28($sp)
		lw $s1,32($sp)
		lw $s2,36($sp)
		lw $s3,40($sp)
		addi $sp,$sp,40
		jr $ra


#a0 = string input
#a1 = string input length
#a2 = address onedethi
#a3 =address length one dethi
_StrCompare:
		addi $sp,$sp,-40
		sw $s3,0($sp)
		sw $t0,4($sp)
		sw $t1,8 ($sp)
		sw $t2,12 ($sp)
		sw $t3,16($sp)
		sw $t4,20($sp)
		sw $t5,24($sp)
		sw $s0,28($sp)
		sw $s1,32($sp)
		sw $s2,36($sp)
		sw $ra,40($sp)
		move $s1,$a0 #answer by string
		move $t3,$a1 #length string
		
		move $s2,$a2 #one de thi
		move $t4,$a3 #one de thi length
		
		
		lw $t1,($t3)
		lw $t2,($t4)
		
		li $v1,-3
		bne $t1,$t2,_StrCompare.End		

		li $t0,0
_StrCompare.Loop:
		lb $t3,($s2) #onedethi[i]
		lb $t4,($s1) #string[i]
		
		bne $t3,$t4,_StrCompare.End
		
		addi $s2,$s2,1
		addi $s1,$s1,1
		addi $t0,$t0,1
		blt $t0,$t1,_StrCompare.Loop
		
		move $v1,$t1 #str length
	
_StrCompare.End:
		
		
		
		lw $s3,0($sp)
		lw $t0,4($sp)
		lw $t1,8 ($sp)
		lw $t2,12 ($sp)
		lw $t3,16($sp)
		lw $t4,20($sp)
		lw $t5,24($sp)
		lw $s0,28($sp)
		lw $s1,32($sp)
		lw $s2,36($sp)
		lw $ra,40($sp)
		addi $sp,$sp,40
		jr $ra
