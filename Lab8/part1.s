# Program that counts consecutive ones

.global _start
.text
_start:
	la s2, LIST # Load the memory address into s2
	addi s10, zero, 0 # Final result
	addi s1, zero, -1 # For comparison (terminating character)

LOOP_LIST:
	lw a0, 0(s2) # Put curr address into subroutine argument var
	beq a0, s1, END # If reached end of list, end program
	jal ONES
	addi s2, s2, 4 # Increment address to next word in list
	bgt a0, s10, CHANGE
	b LOOP_LIST
CHANGE:
	mv s10, a0
	b LOOP_LIST

ONES:
	addi sp, sp, -4
	sw ra, 0(sp)
	add t2, zero, a0 # Put word into temp register
	mv a0, zero # Will store subroutine output
LOOP:
	beqz t2, DONE # Loop until data contains no more ones
	srli t3, t2, 1 # Perform SHIFT, followed by AND
	and t2, t2, t3
	addi a0, a0, 1 # Count the string lengths so far
	b LOOP
DONE:
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

END:
	ebreak

# Sample list
.global LIST
.data
LIST:
.word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, -1