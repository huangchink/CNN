//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		MUX4to1_32b.v
//Description:	32-bit 4to1 multiplexer
//Version:		0.1
//=====================================
`include "def.v"

module MUX4to1_32b(
	Data_in1,
	Data_in2,
	Data_in3,
	Data_in4,
	sel,
	Data_out
);

	input [`INTERNAL_BITS-1:0] Data_in1,Data_in2,Data_in3,Data_in4;
	input [1:0] sel;
	output [`INTERNAL_BITS-1:0] Data_out;

//complete your design here

assign Data_out=(sel==2'd0)?Data_in1:(sel==2'd1)?Data_in2:(sel==2'd2)?Data_in3:(sel==2'd3)?Data_in4:Data_in1;

endmodule
