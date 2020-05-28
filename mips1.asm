.data
mang_nguoi_choi: .space 1000
mang_ten: .space 112
mang_diem: .space 44
mang_luot_choi: .space 44
arr_size: .word 0
player_size: .word 0
file_name: .asciiz "input.txt"
.text
.globl main

main:
	la $a0, file_name
	la $a1, mang_nguoi_choi
	jal read_player
	
	
	
	la $a0, mang_nguoi_choi
	move $a1, $v0
	jal extract_player
	
	la $t0, player_size
	sw $v0, ($t0)
	
	li $a0, '\n'
	li $v0, 11
	syscall
	jal print_names
	
	li $v0, 10
	syscall

# read player.txt file
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

# print names from mang_ten
print_names:
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $t0, 12($sp)
	sw $t1, 8($sp)
	sw $t2, 4($sp)
	sw $t3, ($sp)
	
	la $t0, player_size
	lw $t1, ($t0)
	la $t2, mang_ten
	li $t3, 0
print_names.loop:
	beq $t3, $t1, print_names.end
	move $a0, $t2
	li $v0, 4
	syscall
	
	li $a0, ' '
	li $v0, 11
	syscall
	
	addi $t2, $t2, 11
	addi $t3, $t3, 1
	j print_names.loop
print_names.end:
	lw $ra, 16($sp)
	lw $t0, 12($sp)
	lw $t1, 8($sp)
	lw $t2, 4($sp)
	lw $t3, ($sp)
	addi $sp, $sp 20
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

