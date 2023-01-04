# Sum the numbers in a list

.global _start
.text
_start:
	la s2, LIST
	addi s10, zero, 0 # Sum
	addi s11, zero, 0 # Loop counter
	addi s9, zero, -1 # Terminating character
	
LOOP: lw s8, 0(s2)
	beq s8, s9, END
	addi s11, s11, 1
	add s10, s10, s8
	addi s2, s2, 4
	j LOOP

END:
	ebreak

.global LIST
.data
LIST:
.word 1, 2, 3, 5, 0xA, -1