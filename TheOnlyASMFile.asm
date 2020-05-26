.data 
	DrawTake1: .asciiz " _________\n|/       |\n|\n|\n|\n|\n|\n"
	DrawTake2: .asciiz " _________\n|/       |\n|        O\n|\n|\n|\n|\n"
	DrawTake3: .asciiz " _________\n|/       |\n|        O\n|        |\n|\n|\n|\n"
	DrawTake4: .asciiz " _________\n|/       |\n|        O\n|       /|\n|\n|\n|\n"
	DrawTake5: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       \n|\n|\n "
	DrawTake6: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       /\n|\n|\n"
	DrawTake7: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       / \\ \n|\n|\n"
	endline: .asciiz "\n"
	TB1: .asciiz "\nEnter n : "
	fin: .asciiz "dethi.txt"
	onedethi: .space 1024
	lengthdethi: .word 1
	savechar: .byte 1
	endchar: .byte '*'
	DrawDeThi: .space 1024
	
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
		sw $t4,20($sp)
		sw $t5,24($sp)
		sw $s0,28($sp)
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
	beqz $v0,_ReadDeThi.EndLoop
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