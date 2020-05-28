.data 
	mang_nguoi_choi: .space 1000
	mang_ten: .space 112
	mang_diem: .space 44
	mang_luot_choi: .space 44
	DrawTake1: .asciiz " _________\n|/       |\n|\n|\n|\n|\n|\n"
	DrawTake2: .asciiz " _________\n|/       |\n|        O\n|\n|\n|\n|\n"
	DrawTake3: .asciiz " _________\n|/       |\n|        O\n|        |\n|\n|\n|\n"
	DrawTake4: .asciiz " _________\n|/       |\n|        O\n|       /|\n|\n|\n|\n"
	DrawTake5: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       \n|\n|\n "
	DrawTake6: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       /\n|\n|\n"
	DrawTake7: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       / \\ \n|\n|\n"
	
	TB1: .asciiz "\nEnter n : "
	fin: .asciiz "dethi.txt"
	onedethi: .space 1024
	lengthdethi: .word 1
	savechar: .byte 1
	endchar: .byte '*'
	endline: .byte '\0'
	charspacing: .byte '-'
	DrawDeThi: .space 1024
	temp: .word 1
	nguoichoi: .asciiz "nguoichoi.txt"
	arraytennguoichoi: .space 1000
	onetennguoichoi: .space 10
	arraydiem: .space 4000
	arraysolanchoi: .space 100
	arraytempdiem: .space 100
	lengthoftemp: .word 1
	arraytennguoichoilength: .space 4000
	arraytennguoichoiaddress: .space 4000
	numberofplayer: .word 1
	curr_player: .space 11 #ten toi da 10 ki tu
        input_name_player: .asciiz "\n Enter your name:\n"
        messPlayerChoice: .asciiz "\n Nhap 0 de tra loi voi 1 ki tu, 1 de tra loi toan bo\n"
	messOneChar:	.asciiz "\n Nhap  ki tu ban muon doan\n"
	messString:	.asciiz "\n Nhap  chuoi ban muon tra loi\n"
	answByOneChar: .space 2
	answByString: .space 100
.text
	.globl main
main:
	
	
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
	
	addi $s5,$s5,4	
	
	sw $t6,lengthoftemp
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
	sw $t6,lengthoftemp
	#  atoi($t7) , length = $t6
	la $t7,arraysolanchoi
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
		
	li   $v0, 13       # system call for open file
	la   $a0, fin      # input file name
	li   $a1, 0        # flag for reading
	li   $a2, 0        # mode is ignored
	syscall            # open a file 
	move $s0, $v0      # save the file descriptor 

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

_sort_players_descending.loop:
	#sap xep mang con
	#truyen tham so cho ham xuat mang
	sub $a0, $s0, $t0 
	la $a1, ($s1)
	#goi ham sap xep mang ccn
	jal _sort_small_array
	
	#khong tang dia chi cua a1 
	#tang chi so i
	addi $t0, $t0, 1
	
	#kiem tra i < n thi lap
	blt $t0, $s0, _sort_players_descending.loop
#cuoi thu tuc
	#restore
	lw $ra, ($sp)
	lw $s0, 4($sp) #luu gia tri n
	lw $s1, 8($sp) #luu gia tri arr
	lw $t0, 12($sp) #chay vong lap
	lw $t1, 16($sp) #thanh ghi tam chua gia tri a[n]

	#khoi phuc lai stack
	addi $sp, $sp, 32
	
	jr $ra	
	

_sort_small_array:
	#dau thu tuc
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp) #luu gia tri n
	sw $s1, 8($sp) #luu gia tri arr
	sw $t0, 12($sp) #chay vong lap
	sw $t1, 16($sp) #thanh ghi tam chua gia tri a[n]
	sw $t2, 20($sp) #thanh ghi tam chua gia tri a[n+1]
	
	#luu tham so $a0,$a1 vao thanh ghi
	addi $s0, $a0, 0
	move $s1, $a1
	
#than thu tuc
	#khoi tao vong lap
	li $t0, 0
_sort_small_array.loop:
	#so sanh phan tu hien tai 
	#load 2 phan tu hien tai
	lw $t1, ($s1)
	lw $t2, 4($s1)
	#neu  a[n] < a[n+1] thi swap
	blt $t2, $t1, _sort_small_array.not_swap
	sw $t2, ($s1)
	sw $t1, 4($s1)
_sort_small_array.not_swap:
	
	#tang dia chi cua $a1
	addi $s1, $s1, 4
	#tang chi so i
	addi $t0, $t0, 1
	
	#kiem tra i < n thi lap
	blt $t0, $s0, _sort_small_array.loop
#cuoi thu tuc
	#restore
	lw $ra, ($sp)
	lw $s0, 4($sp) #luu gia tri n
	lw $s1, 8($sp) #luu gia tri arr
	lw $t0, 12($sp) #chay vong lap
	lw $t1, 16($sp) #thanh ghi tam chua gia tri a[n]
	lw $t2, 20($sp) #thanh ghi tam chua gia tri a[n+1]

	#khoi phuc lai stack
	addi $sp, $sp, 32
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
		move $t3,$a1 #save random x in t0
		
		li $t0,0 #i = 0
		la $s1,DrawDeThi
		la $s0,onedethi
		lw $t4,lengthdethi

		beq $t3,-1,_DrawWord.FirstInit
		beq $t3,-2,_DrawWord.FullAnwer
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
	li $t0,0
	la $s1,DrawDeThi
_DrawWord.Print.loop:	
	lb $a0,($s1)
	li $v0,11
	syscall
	addi $t0,$t0,1
	addi $s1,$s1,1
	blt $t0,$t4,_DrawWord.Print.loop
	li $v0,4
	la $a0,endline
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
		addi $sp,$sp,32
		jr $ra

#--------input_name-------#
_input_name:
    
    li $v0,4	#xuat thong bao
    la $a0,input_name_player
    syscall
    li $v0, 8       	#  input ten nguoi choi
    la $a0, curr_player  
    li $a1, 11     

    move $t0, $a0  	 # luu ten vao t0
    syscall

    jal _strlen              
    
    li $v0, 10     	 # the end 
    syscall
    
_strlen:
	li $t0, 0 	# khoi tao bien dem bang 0
	li $t2,10 	#ki tu new line
_strlen.loop:
	
	lb $t1, 0($a0) 	  # load ki tu tiep theo vao t1
	beq $t1,$t2 _strlen.exit #kiem tra ki tu newline
	beqz $t1,_strlen.exit	  # kiem tra ki tu rong
	addi $a0, $a0, 1  # tang con tro cua chuoi
	addi $t0, $t0, 1  # tang bien dem
	
	j _strlen.loop 		  # quay lai vong lap
_strlen.exit:
	move $v1,$t0
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
extract_player:
	addi $sp, $sp, -36
	sw $ra, 32($sp)
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
	la $t7, 0
	#TODO special case zero string
	blez $a1, extract_player.empty
	#move $a0, $t0
	#li $v0, 4
	#syscall
	
extract_player.player:
	move $t4, $t1
extract_player.loop_inner:
	lb $t5, ($t0)
	beq $t5, '-', extract_player.point1
	sb $t5, ($t4)
	addi $t4, $t4, 1
	addi $t0, $t0, 1
	j extract_player.loop_inner
extract_player.point1:
	li $t5, 0
	sb $t5, ($t4)
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
	
	lw $ra, 32($sp)
	lw $t0, 28($sp)
	lw $t1, 24($sp)
	lw $t2, 20($sp)
	lw $t3, 16($sp)
	lw $t4, 12($sp)
	lw $t5, 8($sp)
	lw $t6, 4($sp)
	lw $t7, ($sp)
	addi $sp, $sp, 36
	jr $ra

#------Input from Player------#
_input_from_player:
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
	
	jr $ra

_input_string:
	li $v0,4
	la $a0,messString
	syscall
	
	li $v0,8
	la $a0,answByString #luu chuoi vao answByString
	li $a1,100
	syscall

	jr $ra