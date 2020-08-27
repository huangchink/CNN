//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		Truncate.v
//Description:	Truncate Operation
//Version:		0.1
//=====================================
`include "def.v"
//`define INTERNAL_BITS 32
//`define DATA_BITS 16
module Truncate(
	Data_in,
	Data_out
);

	input [`INTERNAL_BITS-1:0] Data_in;
	output [`DATA_BITS-1:0] Data_out;

//complete your design here
assign Data_out=Data_in[23:8];


endmodule
