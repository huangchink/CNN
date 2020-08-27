//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		MUX2to1_32b.v
//Description:	32-bit 2to1 multiplexer
//Version:		0.1
//=====================================
`include "def.v"

module MUX2to1_32b(
	Data_in1,
	Data_in2,
	sel,
	Data_out
);

	input [`INTERNAL_BITS-1:0] Data_in1,Data_in2;
	input sel;
	output [`INTERNAL_BITS-1:0] Data_out;

//complete your design here

assign Data_out=(sel==0)?Data_in1:Data_in2;

endmodule
