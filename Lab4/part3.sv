// Create a shift register using muxes and D Flip-Flops: the register can shift in any specified direction
// and can perform both regular and arithmetic shifts (i.e. with and without the sign bit copied)
`timescale 1ns / 1ns // `timescale time_unit/time_precision

// Top-level module: instantiate multiple muxes and flip-flops to create a 4-bit shift register
module part3(input logic clock, reset, ParallelLoadn, RotateRight, ASRight, input logic [3:0] Data_IN, output logic [3:0] Q);
	mux_dff ff3(clock, reset, ParallelLoadn, RotateRight, Q[2], (ASRight ? Q[3] : Q[0]), Data_IN[3], Q[3]); // The extra logic on this line implements arithmetic shift
	mux_dff ff2(clock, reset, ParallelLoadn, RotateRight, Q[1], Q[3], Data_IN[2], Q[2]);
	mux_dff ff1(clock, reset, ParallelLoadn, RotateRight, Q[0], Q[2], Data_IN[1], Q[1]);
	mux_dff ff0(clock, reset, ParallelLoadn, RotateRight, Q[3], Q[1], Data_IN[0], Q[0]);
endmodule

// Mux with a D Flip-Flop: this module is repeated an arbitrary number of times to create a shift register of that width
module mux_dff(input logic clock, reset, loadn, LoadLeft, Right, Left, D, output logic Q);
	always_ff @(posedge clock)
	begin
		if (reset) Q <= 0;
		else Q <= loadn ? (LoadLeft ? Left : Right) : D; // Shift in the appropriate direction
	end
endmodule