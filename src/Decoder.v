//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		Decoder.v
//Description:	Index Decode
//Version:		0.1
//=====================================
`include "def.v"

module Decoder(
	clk,
	rst,
	en,
	Data_in,
	Index
);

	input clk;
	input rst;
	input en;
	input [`INTERNAL_BITS-1:0] Data_in;
	output [`INTERNAL_BITS-1:0] Index;

//complete your design here
reg signed [31:0]result0 ;
reg signed [31:0]result1 ;
reg signed [31:0]result2 ;
reg signed [31:0]result3 ;
reg signed [31:0]result4 ;
reg signed [31:0]result5 ;
reg signed [31:0]result6 ;
reg signed [31:0]result7 ;
reg signed [31:0]result8 ;
reg signed [31:0]result9 ;
reg [31:0]max_index;
always@(posedge clk or posedge rst)
begin
if(rst)begin
result0<=$signed(32'd0);
result1<=$signed(32'd0);
result2<=$signed(32'd0);
result3<=$signed(32'd0);
result4<=$signed(32'd0);
result5<=$signed(32'd0);
result6<=$signed(32'd0);
result7<=$signed(32'd0);
result8<=$signed(32'd0);
result9<=$signed(32'd0);
end
else if(en==1'd1)
begin
result0<=result1;
result1<=result2;
result2<=result3;
result3<=result4;
result4<=result5;
result5<=result6;
result6<=result7;
result7<=result8;
result8<=result9;
result9<=Data_in;
end
end
always@(*)
begin
if(result0>=result1&&result0>=result2&&result0>=result3&&result0>=result4&&result0>=result5&&result0>=result6&&result0>=result7&&result0>=result8&&result0>=result9)
max_index=32'd0;
else if(result1>=result0&&result1>=result2&&result1>=result3&&result1>=result4&&result1>=result5&&result1>=result6&&result1>=result7&&result1>=result8&&result1>=result9)
max_index=32'd1;
else if(result2>=result0&&result2>=result1&&result2>=result3&&result2>=result4&&result2>=result5&&result2>=result6&&result2>=result7&&result2>=result8&&result2>=result9)
max_index=32'd2;
else if(result3>=result0&&result3>=result1&&result3>=result2&&result3>=result4&&result3>=result5&&result3>=result6&&result3>=result7&&result3>=result8&&result3>=result9)
max_index=32'd3;
else if(result4>=result0&&result4>=result1&&result4>=result2&&result4>=result3&&result4>=result5&&result4>=result6&&result4>=result7&&result4>=result8&&result4>=result9)
max_index=32'd4;
else if(result5>=result0&&result5>=result1&&result5>=result2&&result5>=result3&&result5>=result4&&result5>=result6&&result5>=result7&&result5>=result8&&result5>=result9)
max_index=32'd5;
else if(result6>=result0&&result6>=result1&&result6>=result2&&result6>=result3&&result6>=result4&&result6>=result5&&result6>=result7&&result6>=result8&&result6>=result9)
max_index=32'd6;
else if(result7>=result0&&result7>=result1&&result7>=result2&&result7>=result3&&result7>=result4&&result7>=result5&&result7>=result6&&result7>=result8&&result7>=result9)
max_index=32'd7;
else if(result8>=result0&&result8>=result1&&result8>=result2&&result8>=result3&&result8>=result4&&result8>=result5&&result8>=result6&&result8>=result7&&result8>=result9)
max_index=32'd8;
else if(result9>=result0&&result9>=result1&&result9>=result2&&result9>=result3&&result9>=result4&&result9>=result5&&result9>=result6&&result9>=result7&&result9>=result8)
max_index=32'd9;
else
max_index=32'd0;
end
assign Index=max_index;

endmodule
