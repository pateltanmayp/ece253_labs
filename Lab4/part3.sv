`timescale 1ns / 1ns // `timescale time_unit/time_precision

module part3(input logic clock, reset, ParallelLoadn, RotateRight, ASRight, input logic [3:0] Data_IN, output logic [3:0] Q);
	mux_dff ff3(clock, reset, ParallelLoadn, RotateRight, Q[2], (ASRight ? Q[3] : Q[0]), Data_IN[3], Q[3]);
	mux_dff ff2(clock, reset, ParallelLoadn, RotateRight, Q[1], Q[3], Data_IN[2], Q[2]);
	mux_dff ff1(clock, reset, ParallelLoadn, RotateRight, Q[0], Q[2], Data_IN[1], Q[1]);
	mux_dff ff0(clock, reset, ParallelLoadn, RotateRight, Q[3], Q[1], Data_IN[0], Q[0]);
endmodule

module mux_dff(input logic clock, reset, loadn, LoadLeft, Right, Left, D, output logic Q);
	always_ff @(posedge clock)
	begin
		if (reset) Q <= 0;
		else Q <= loadn ? (LoadLeft ? Left : Right) : D;
	end
endmodule