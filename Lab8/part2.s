# Program that implements bubble sort
.global _start
.text
_start:
	la s2, LIST # Load the memory address into s2
	lw s3, 0(s2) # Number of words in list
	addi s3, s3, -1 # Upper bound on inner loop counter
	mv s4, zero # Inner loop counter
	addi s5, s2, 4 # Move to effective starting point of list

# Main
# Bubble sort algorithm
LOOP_LIST:
	mv a0, s5
	beq s4, s3, DONE_INNER
	jal SWAP
	addi s5, s5, 4
	addi s4, s4, 1
	b LOOP_LIST
DONE_INNER:
	addi s3, s3, -1
	beq s3, zero, END
	addi s5, s2, 4
	mv s4, zero
	b LOOP_LIST

# Swap subroutine: determine whether to swap and perform swap if necessary
SWAP:
	addi sp, sp, -4
	sw ra, 0(sp)
	lw t0, 0(a0)
	lw t1 4(a0)
	bgt t0, t1, SWITCH
	mv a0, zero
	b DONE_ROUTINE
SWITCH:
	sw t1, 0(a0)
	sw t0, 4(a0)
	addi a0, zero, 1
	b DONE_ROUTINE
DONE_ROUTINE:
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

END:
	ebreak

# Trial list for testing
.global LIST
.data
LIST:
.word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33, -1