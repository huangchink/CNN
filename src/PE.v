//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		PE.v
//Description:	MAC Operation
//Version:		0.1
//=====================================
`include "def.v"
//`define INTERNAL_BITS 32
//`define DATA_BITS 16
module PE( 
	clk,
	rst,
	IF_w,
	W_w,
	IF_in,
	W_in,
	Result
);

	input clk;
	input rst;
	input IF_w,W_w;
	input [`DATA_BITS-1:0] IF_in,W_in; 
	output signed [`INTERNAL_BITS-1:0] Result;

//complete your design here
 // ---------------------- output  ---------------------- //
 //output signed [31:0]Result;
 
 // -----------------------  reg  ----------------------- //
 reg signed [15:0] weight [2:0];
 reg signed [15:0] feature [2:0];
 

	
// ---------------------- Write down Your design below  ---------------------- //
 always@(posedge rst  or posedge clk)
begin
if(rst)
begin
weight[0]<=$signed(16'd0);
weight[1]<=$signed(16'd0);
weight[2]<=$signed(16'd0);
feature[0]<=$signed(16'd0);
feature[1]<=$signed(16'd0);
feature[2]<=$signed(16'd0);
end
else
begin
if(W_w==1'b1 )
begin
weight[2]<=weight[1];
weight[1]<=weight[0];
weight[0]<=W_in;
end

if(IF_w==1'b1 )
begin
//feature[0]<=feature[1];
//feature[1]<=feature[2];
//feature[2]<=IF_in;
feature[2]<=feature[1];
feature[1]<=feature[0];
feature[0]<=IF_in;
end
end
end

assign Result = weight[2]*feature[2]+weight[1]*feature[1]+weight[0]*feature[0];

  
endmodule
