//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		Pooling.v
//Description:	Max Pooling Operation
//Version:		0.1
//=====================================
`include "def.v"
//`define INTERNAL_BITS 32
module Pooling(
	clk,
	rst,
	en,
	Data_in,
	Data_out
);

	input clk;
	input rst;
	input en;
	input [`INTERNAL_BITS-1:0] Data_in;
	output [`INTERNAL_BITS-1:0] Data_out;

//complete your design here
reg signed [31:0]data0 ;
reg signed [31:0]data1 ;
reg signed [31:0]data2 ;
reg signed [31:0]data3 ;
reg signed [31:0]mmax;
always@(posedge clk or posedge rst)
begin
if(rst)begin
data0<=$signed(32'd0);
data1<=$signed(32'd0);
data2<=$signed(32'd0);
data3<=$signed(32'd0);
end
else if(en)
begin
data0<=data1;
data1<=data2;
data2<=data3;
data3<=Data_in;

end
end
always@(*)
begin

if((data0>data1&&data0>data2)&&data0>data3)
mmax=data0;
else if((data1>=data0&&data1>=data2)&&data1>=data3)
mmax=data1;
else if((data2>=data0&&data2>=data1)&&data2>=data3)
mmax=data2;
else if((data3>=data0&&data3>=data1)&&data3>=data2)
mmax=data3;
else
mmax=data0;

end

assign Data_out=mmax;

endmodule
