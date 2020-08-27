//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		MUX2to1_16b.v
//Description:	16-bit 2to1 multiplexer
//Version:		0.1
//=====================================
`include "def.v"

module MUX2to1_16b(
	Data_in1,
	Data_in2,
	sel,
	Data_out
);

	input [`DATA_BITS-1:0] Data_in1,Data_in2;
	input sel;
	output [`DATA_BITS-1:0] Data_out;

//complete your design here
assign Data_out=(sel==0)?Data_in1:Data_in2;



endmodule
