// Create a counter with in-built clock rate divider: count at custom speeds

// Top-level module: collect an enable signal from a RateDivider module and use it to enable a counter increment step
module part2 #(parameter CLOCK_FREQUENCY = 500)(input logic ClockIn, Reset, input logic [1:0] Speed, output logic [3:0] CounterValue);
	logic enable;
	RateDivider #(CLOCK_FREQUENCY) div(ClockIn, Reset, Speed, enable);
	DisplayCounter dc(ClockIn, Reset, enable, CounterValue);
endmodule

// RateDivider: Generate an enable signal at a custom frequency (given by speed)
// E.g. For a frequency of 500 Hz, the enable signal will be high exactly once every 500 cycles
module RateDivider #(parameter CLOCK_FREQUENCY = 500) (input logic ClockIn, Reset, input logic [1:0] Speed, output logic Enable);
	logic [$clog2((CLOCK_FREQUENCY << 2) - 1) + 1:0] load, counter;

	// Select the value that will be loaded into the down-counter (enable signal is high when the counter reaches 0)
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

	assign Enable = &(~counter); // The enable pin is high every time the counter reaches 0
endmodule

// DisplayCounter: increment a counter every time the enable signal is high
module DisplayCounter(input logic Clock, Reset, EnableDC, output logic [3:0] CounterValue);
	always_ff @(posedge Clock)
	begin
		if (Reset) CounterValue <= 0;
		else if(EnableDC) CounterValue <= CounterValue + 1;
	end
endmodule