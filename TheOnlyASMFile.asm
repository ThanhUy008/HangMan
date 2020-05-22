.data 
	DrawTake1: .asciiz " _________\n|/       |\n|\n|\n|\n|\n|\n"
	DrawTake2: .asciiz " _________\n|/       |\n|        O\n|\n|\n|\n|\n"
	DrawTake3: .asciiz " _________\n|/       |\n|        O\n|        |\n|\n|\n|\n"
	DrawTake4: .asciiz " _________\n|/       |\n|        O\n|       /|\n|\n|\n|\n"
	DrawTake5: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       \n|\n|\n "

	DrawTake6: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       /\n|\n|\n"
	DrawTake7: .asciiz " _________\n|/       |\n|        O\n|       /|\\ \n|       / \\ \n|\n|\n"
	TB1: .asciiz "\nEnter n : "
	

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
