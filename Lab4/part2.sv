// Implement an ALU with registers to store computed values
`timescale 1ns / 1ns // `timescale time_unit/time_precision

// Top-level module: 
module part2(input logic Clock, Reset_b, input logic [3:0] Data, input logic [1:0] Function, output logic [7:0] ALUout);
	logic [7:0] Result, Register;

	always_comb
	begin
		case (Function) // Select the ALU function (add, multiply, shift)
			0: Result = Data + Register[3:0];
			1: Result = Data * Register[3:0];
			2: Result = Register[3:0] << Data;
			3: Result = Register;
			default: Result = 0;
		endcase
	end

	// Update the value of the output register on positive clock edge
	always_ff @(posedge Clock)
	begin
		if (Reset_b) Register <= 0;
		else Register <= Result;
	end

	assign ALUout = Register;
endmodule