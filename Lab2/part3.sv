// Implement a hex decoder to display a value of choice on the HEX0 7-segment display
`timescale 1ns / 1ns // `timescale time_unit/time_precision

// Top-level module: implement the hex decoder
module hex_decoder(c, display);
	input logic [3:0]c;
	output logic [6:0]display;

	// Enumerate all input cases with a case block
	always_comb
	begin
		case(c)
			0: display = 7'b1000000;
			1: display = 7'b1111001;
			2: display = 7'b0100100;
			3: display = 7'b0110000;
			4: display = 7'b0011001;
			5: display = 7'b0010010;
			6: display = 7'b0000010;
			7: display = 7'b1111000;
		endcase
	end
endmodule