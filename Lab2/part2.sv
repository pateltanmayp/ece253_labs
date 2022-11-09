// Implement common 7400-series logic chips from scratch, as well as a mux
`timescale 1ns / 1ns // `timescale time_unit/time_precision

// Top-level module: instantiate the 7400-series IC's to create a 2to1 mux
module mux2to1(input logic x, y, s,
	output logic m;
	logic ns, xp, yp;

	v7404 NOT_(.pin1(s), .pin2(ns));
	v7408 AND_(.pin1(s), .pin2(y), .pin3(yp), .pin4(ns), .pin5(x), .pin6(xp));
	v7432 OR_(.pin1(xp), .pin2(yp), .pin3(m));
endmodule

module v7404(input logic pin1, pin3, pin5, pin9, pin11, pin13,
	output logic pin2, pin4, pin6, pin8, pin10, pin12);

    	assign pin2 = ~pin1;
    	assign pin4 = ~pin3;
    	assign pin6 = ~pin5;
    	assign pin12 = ~pin13;
    	assign pin10 = ~pin11;
    	assign pin8 = ~pin9;
endmodule

module v7408(input logic pin1, pin3, pin5, pin9, pin11, pin13,
	output logic pin2, pin4, pin6, pin8, pin10, pin12);

    	assign pin3 = pin1 & pin2;
    	assign pin6 = pin4 & pin5;
    	assign pin11 = pin12 & pin13;
    	assign pin8 = pin9 & pin10;
endmodule

module v7432(input logic pin1, pin3, pin5, pin9, pin11, pin13,
	output logic pin2, pin4, pin6, pin8, pin10, pin12);

    	assign pin3 = pin1 | pin2;
    	assign pin6 = pin4 | pin5;
    	assign pin11 = pin12 | pin13;
    	assign pin8 = pin9 | pin10;
endmodule