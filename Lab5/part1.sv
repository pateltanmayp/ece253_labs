`timescale 1ns / 1ns // `timescale time_unit/time_precision

module part1(input logic Clock, Enable, Reset, output logic [7:0] CounterValue);
	assign a0 = Enable;
	t_ff t_ff0(a0, Clock, Reset, CounterValue[0]);
	assign a1 = a0 & CounterValue[0];
	t_ff t_ff1(a1, Clock, Reset, CounterValue[1]);
	assign a2 = a1 & CounterValue[1];
	t_ff t_ff2(a2, Clock, Reset, CounterValue[2]);
	assign a3 = a2 & CounterValue[2];
	t_ff t_ff3(a3, Clock, Reset, CounterValue[3]);
	assign a4 = a3 & CounterValue[3];
	t_ff t_ff4(a4, Clock, Reset, CounterValue[4]);
	assign a5 = a4 & CounterValue[4];
	t_ff t_ff5(a5, Clock, Reset, CounterValue[5]);
	assign a6 = a5 & CounterValue[5];
	t_ff t_ff6(a6, Clock, Reset, CounterValue[6]);
	assign a7 = a6 & CounterValue[6];
	t_ff t_ff7(a7, Clock, Reset, CounterValue[7]);
endmodule

module t_ff(input logic T, Clock, Reset, output logic Q);
	always_ff @(posedge Clock)
	begin
		if (Reset) Q <= 0;
		else Q <= Q ^ T;
	end
endmodule