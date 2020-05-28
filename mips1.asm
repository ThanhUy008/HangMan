.data
mang_nguoi_choi: .space 1000
mang_ten: .space 112
mang_diem: .space 44
mang_luot_choi: .space 44
arr_size: .word 0
file_name: .asciiz "input.txt"
.text
.globl main

main:
	jal read_player
	
	la $t0, mang_nguoi_choi
	la $t1, mang_ten
	la $t2, mang_diem
	la $t3, mang_luot_choi
player:
	move $t4, $t1
loop_inner:
	lb, $t5, ($t0)
	beq $t5, '-', point1
	sb $t5, ($t4)
	addi $t4, $t4, 1
	addi $t0, $t0, 1
	j loop_inner
point1:
	li $t5, 0
	sb $t5, ($t4)
	addi $t1, $t1, 10
	
	li $t6, 0
	lb $t5, ($t0)
	beq $t5, '-', point2
	addi $t6, $t6, 1
	addi $t0, $t0, 1
	j point1
point2:
	sub $a0, $t0, $t6
	move $a1, $t6
	jal str_to_int
	sw $v0, ($t2)
	addi $t2, $t2, 4
	
	li $t6, 0
	lb $t5, ($t0)
	beq $t5, '*', done
	addi $t6, $t6, 1
	addi $t0, $t0, 1
	j point2
done:
	sub $a0, $t0, $t6
	move $a1, $t6
	jal str_to_int
	sw $v0, ($t3)
	addi $t3, $t3, 4
	
	lw $t5, 1($t0)
	bgtz $t5, player
	
	li $v0, 10
	syscall

read_player:
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $v0, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $t1, ($sp)
	
	li $v0, 13
	la $a0, file_name
	li $a1, 0
	li $a2, 0
	syscall
	move $a0, $v0
	
	li $v0, 14
	la $a1, mang_nguoi_choi
	li $a2, 1000
	syscall
	la $t0, arr_size
	sw $v0, ($t0)
	
	li $v0, 16
	syscall
	
	lw $t0, ($sp)
	lw $a2, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
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

extract_player:
	

