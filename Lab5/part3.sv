// Morse code!
module part3 #(parameter CLOCK_FREQUENCY=500)(input logic ClockIn, Reset, Start, input logic [2:0] Letter, output logic DotDashOut, NewBitOut);
	logic [11:0] letter_code, out;
	logic Enable;

	always_comb
	begin
	case (Letter)
		0: letter_code = 12'b101110000000; // A
		1: letter_code = 12'b111010101000; // B
		2: letter_code = 12'b111010111010; // C
		3: letter_code = 12'b111010100000; // D
		4: letter_code = 12'b100000000000; // E
		5: letter_code = 12'b101011101000; // F
		6: letter_code = 12'b111011101000; // G
		7: letter_code = 12'b101010100000; // H
		default: letter_code = 0;
	endcase
	end

	RateDivider #(CLOCK_FREQUENCY) div(ClockIn, Reset, Start, Enable);
	shift_reg sr(ClockIn, Reset, Enable, Start, letter_code, out);
	assign DotDashOut = out[11];
	assign NewBitOut = Enable;
endmodule

module RateDivider #(parameter CLOCK_FREQUENCY = 500) (input logic ClockIn, Reset, Start, output logic Enable);
	logic [$clog2((CLOCK_FREQUENCY >> 1) - 1) + 1:0] load, counter;
	logic [12:0] num_enables;
	assign load = (CLOCK_FREQUENCY >> 1) - 1;

	always_ff @(posedge ClockIn)
	begin
		if (Start) begin
			counter <= load;
			num_enables = 1;
		end
		else if (Enable & !num_enables[12]) begin
			counter <= load;
			num_enables = num_enables << 1;
		end
		else if (num_enables[12] | Reset) begin
			counter <= load;
			num_enables = 1 << 12;
		end
		else counter <= counter - 1;
	end

	assign Enable = &(~counter);
endmodule

module shift_reg(input logic clock, reset, enable, load_enable, input logic [11:0] load, output logic [11:0] out);
	always_ff @(posedge clock)
	begin
		if (reset) out <= 0;
		else if (load_enable) out <= load;
		else if (enable) out <= out << 1;
	end
endmodule