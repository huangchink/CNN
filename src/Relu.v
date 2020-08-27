//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		Relu.v
//Description:	Relu Operation
//Version:		0.1
//=====================================
`include "def.v"

module Relu(
	Data_in,
	Data_out
);
	
	input signed [`INTERNAL_BITS-1:0] Data_in;
	output signed[`INTERNAL_BITS-1:0] Data_out;

//complete your design here

assign Data_out=(Data_in[31]==1'b1)?32'b0:Data_in;


endmodule	
