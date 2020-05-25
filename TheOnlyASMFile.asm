.data 
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