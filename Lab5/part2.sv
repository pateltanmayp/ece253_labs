// Counter with in-built clock rate divider
module part2 #(parameter CLOCK_FREQUENCY = 500)(input logic ClockIn, Reset, input logic [1:0] Speed, output logic [3:0] CounterValue);
	logic enable;
	RateDivider #(CLOCK_FREQUENCY) div(ClockIn, Reset, Speed, enable);
	DisplayCounter dc(ClockIn, Reset, enable, CounterValue);
endmodule

module RateDivider #(parameter CLOCK_FREQUENCY = 500) (input logic ClockIn, Reset, input logic [1:0] Speed, output logic Enable);
	logic [$clog2((CLOCK_FREQUENCY << 2) - 1) + 1:0] load, counter;
	always_comb
	begin
	case (Speed)
		0: load = 0;
		1: load = CLOCK_FREQUENCY - 1;
		2: load = (CLOCK_FREQUENCY << 1) - 1;
		3: load = (CLOCK_FREQUENCY << 2) - 1;
		default: load = (CLOCK_FREQUENCY << (Speed - 1)) - 1;
	endcase
	end

	always_ff @(posedge ClockIn)
	begin
		if (Reset) counter <= 0;
		else if (Enable) counter <= load;
		else counter <= counter - 1;
	end

	assign Enable = &(~counter);
endmodule

module DisplayCounter(input logic Clock, Reset, EnableDC, output logic [3:0] CounterValue);
	always_ff @(posedge Clock)
	begin
		if (Reset) CounterValue <= 0;
		else if(EnableDC) CounterValue <= CounterValue + 1;
	end
endmodule