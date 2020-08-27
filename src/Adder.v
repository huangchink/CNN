//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		Adder.v
//Description:	Add Operation
//Version:		0.1
//=====================================
`include "def.v"
//`define DATA_BITS 16
module Adder(
	Data_in1,
	Data_in2,
	Data_in3,
	Psum,
	Bias,
	Mode,
	Result
);

	input signed [`INTERNAL_BITS-1:0] Data_in1,Data_in2,Data_in3;
	input signed [`INTERNAL_BITS-1:0] Psum;
	input signed [`DATA_BITS-1:0] Bias;
	input [1:0] Mode;
	output signed [`INTERNAL_BITS-1:0] Result;
        reg signed [`INTERNAL_BITS-1:0] Result;
//complete your design here
always@(*)begin
if(Mode==2'd0)
Result=Data_in1+Data_in2+Data_in3;
else if(Mode==2'd1)
Result=Data_in1+Data_in2+Data_in3+Psum;
else if(Mode==2'd2)
Result=Data_in1+Data_in2+Data_in3+Psum+Bias;
else
Result=Data_in1+Data_in2+Data_in3+Psum+Bias;
end

endmodule
