// Implement a multi-bit full adder circuit from scratch
`timescale 1ns / 1ns // `timescale time_unit/time_precision

// Top level module: instantiate multiple single-bit full adders
module part1(input logic [3:0]  a, b, input logic c_in, output logic [3:0] s, c_out);
	fa fa1(.a(a[0]), .b(b[0]), .c_in(c_in), .s(s[0]), .c_out(c_out[0]));
	fa fa2(.a(a[1]), .b(b[1]), .c_in(c_out[0]), .s(s[1]), .c_out(c_out[1]));
	fa fa3(.a(a[2]), .b(b[2]), .c_in(c_out[1]), .s(s[2]), .c_out(c_out[2]));
	fa fa4(.a(a[3]), .b(b[3]), .c_in(c_out[2]), .s(s[3]), .c_out(c_out[3]));
endmodule

// The single bit full adder
module fa(input logic a, b, c_in, output logic s, c_out);
	logic s_i1;

	assign s_i1 = a ^ b;
	assign s = s_i1 ^ c_in;
	
	always_comb
	begin
		case (s_i1)
			1'b0: c_out = b;
			1'b1: c_out = c_in;
			default: c_out = 1'b1;
		endcase
	end
endmodule
