`timescale 1ns / 1ns // `timescale time_unit/time_precision

module part2(input logic [3:0] A, B, input logic [1:0] Function, output logic [7:0] ALUout);
	logic [3:0] s_i, c_out_i;
	part1 adder(.a(A), .b(B), .c_in(1'b0), .s(s_i), .c_out(c_out_i));

	always_comb
	begin
		case (Function)
			2'b00: ALUout = {3'b000, c_out_i[3], s_i};
			2'b01: ALUout = |(A | B); // Output 8’b00000001 if at least 1 of the 8 bits in the two inputs is 1 using a single OR operation.
			2'b10: ALUout = &(A & B); // Output 8’b00000001 if all of the 8 bits in the two inputs are 1 using a single AND operation.
			2'b11: ALUout = {A, B}; // Display A in the most significant four bits and B in the lower four bits.
			default: ALUout = 8'b00000001;
		endcase
	end
endmodule

module part1(input logic [3:0] a, b, input logic c_in, output logic [3:0] s, c_out);
	fa fa1(.a(a[0]), .b(b[0]), .c_in(c_in), .s(s[0]), .c_out(c_out[0]));
	fa fa2(.a(a[1]), .b(b[1]), .c_in(c_out[0]), .s(s[1]), .c_out(c_out[1]));
	fa fa3(.a(a[2]), .b(b[2]), .c_in(c_out[1]), .s(s[2]), .c_out(c_out[2]));
	fa fa4(.a(a[3]), .b(b[3]), .c_in(c_out[2]), .s(s[3]), .c_out(c_out[3]));
endmodule

module fa(input logic a, b, c_in, output logic s, c_out);
	logic s_i1;

	assign s_i1 = a ^ b;
	assign s = s_i1 ^ c_in;
	
	always_comb
	begin
		case (s_i1)
			1'b0: c_out = b;
			1'b1: c_out = c_in;
		endcase
	end
endmodule
