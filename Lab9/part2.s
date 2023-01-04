# Display a sequence of messages to a console every 5 seconds using interrupts

.data
# Messages
msg_1: .asciz "Please take a deep breath       "
msg_2: .asciz "Please drink some water         "
msg_3: .asciz "Please give your eyes a break   "

# Timer Related
timeNow: .word 0xFFFF0018 # current time
cmp: .word 0xFFFF0020 # time for new interrupt

.text
# Display Related
.eqv OUT_CTRL 0xffff0008
.eqv OUT 0xffff000C

main:
	# Set time to trigger interrupt to be 5000 milliseconds (5 seconds)
	li t0, 5000
	la t1, cmp
	lw t1, 0(t1)
	sw t0, 0(t1)
	
	# Set the handler address and enable interrupts
	la t2, timer_handler
	csrrw zero, utvec, t2
	csrrsi zero, ustatus, 0x1
	csrrsi zero, uie, 0x10

	# Set addresses for transmitter
	li s3, 0xffff000c # Transmitter Data
	li s4, 0xffff0008 # Transmitter Control
	li s5, 0x1 # Mask
	la s7, msg_1

# Determine if interrupt has occured and branch if so
POLL:	li s0, 0x10010080
	lw s1, 0(s0)
	addi s2, zero, 1
	beq s2, s1, TRANSMIT_MSG
	b POLL

TRANSMIT_MSG:
addi s8, s7, 32

LOOP: # Loop through the characters of one message
POLL_WRITE:# Check if transmitter is ready to receive new value
	lw s6, 0(s4) # Transmitter Control value
	and s6, s6, s5
	beqz s6, POLL_WRITE
WRITE: # Write one character
	lbu s9, 0(s7)
	sb s9, 0(s3)
	addi s7, s7, 1
	bltu s7, s8, LOOP # Jump to next character

# Switch to next message
	addi s7, s7, -32
	la s10, msg_1
	bne s7, s10, not1
	la s7, msg_2
	b done
not1:
	la s10, msg_2
	bne s7, s10, not2
	la s7, msg_3
	b done
not2:
	la s7, msg_1
done:
	sw zero, 0(s0)
	b POLL

# Interrupt handler - triggered when timer indicates that 5 seconds have passed
timer_handler:
	# Push registers to stack
	addi sp, sp, -24
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw s0, 16(sp)
	lw s1, 20(sp)

	# Set up conditions for next interrupt (will generate interrupts every 5 seconds by incrementing the comparison register)
	lw t0, timeNow
	lw t1, 0(t0)
	li t2, 5000 # 5000 milliseconds
	add t2, t1, t2
	lw t3, cmp
	sw t2, 0(t3)
	
	# Set a flag to indicate an interrupt
	li s0, 0x10010080
	addi s1, zero, 1
	sw s1, 0(s0)
	
	# Pop registers from stack
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	lw s0, 16(sp)
	lw s1, 20(sp)
	addi sp, sp, 24
	uret # Jump to original program counter (pre-interrupt)