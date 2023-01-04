# Implementation of device I/O with polling

.global _start
.text
_start:
	li s0, 0xffff0004 # Receiver Data
	li s1, 0xffff0000 # Receiver Control
	li s2, 0xffff000c # Transmitter Data
	li s3, 0xffff0008 # Transmitter Control
	li s4, 0x1 # Mask

POLL_READ:
	lw s6, 0(s1) # Receiver Control value
	lbu s7, 0(s0) # Receiver Data value
	and s6, s6, s4
	beqz s6, POLL_READ

POLL_WRITE:
	lw s6, 0(s3) # Transmitter Control value
	and s6, s6, s4
	beqz s6, POLL_WRITE

WRITE:
	sb s7, 0(s2)
	b POLL_READ

END:
	ebreak