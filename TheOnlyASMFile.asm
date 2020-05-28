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
.text
	.globl main
main:
	
	#ket thuc
	li $v0,10
	syscall



###########################################Funtion:
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
		sw $t3,20($sp)
		sw $t4,24($sp)
		sw $s0,26($sp)
		sw $s1,32($sp)
		move $t3,$a1 #save  in t0
		
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
	beqz $v0,endloop
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
	lw $t3,20($sp)
	lw $t4,24($sp)
	lw $s0,26($sp)
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