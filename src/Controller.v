//=====================================
//Author:		Chen Yun-Ru (May)
//Filename:		Controller.v
//Description:	Controller
//Version:		0.1
//=====================================
`include "def.v"

module Controller(
	clk,
	rst,
	START,
	DONE,
	//ROM
	ROM_IM_CS,ROM_W_CS,ROM_B_CS,
	ROM_IM_OE,ROM_W_OE,ROM_B_OE,
	ROM_IM_A,ROM_W_A,ROM_B_A,
	//SRAM
	SRAM_CENA,SRAM_CENB,
	SRAM_WENB,
	SRAM_AA,SRAM_AB,
	//PE
	PE1_IF_w,PE2_IF_w,PE3_IF_w,
	PE1_W_w,PE2_W_w,PE3_W_w,
	//Pooling
	Pool_en,
	//Decoder
	Decode_en,
	//Adder
	Adder_mode,
	//MUX
	MUX1_sel,MUX2_sel,MUX3_sel
);

	input clk;
	input rst;
	input START;
	output reg DONE;
	output reg ROM_IM_CS,ROM_W_CS,ROM_B_CS;
	output reg ROM_IM_OE,ROM_W_OE,ROM_B_OE;
	output reg [`ROM_IM_ADDR_BITS-1:0] ROM_IM_A;//10bits
	output reg [`ROM_W_ADDR_BITS-1:0] ROM_W_A;//17 bits
	output reg [`ROM_B_ADDR_BITS-1:0] ROM_B_A;//8bits
	output reg SRAM_CENA,SRAM_CENB;
	output reg SRAM_WENB;
	output reg [`SRAM_ADDR_BITS-1:0] SRAM_AA,SRAM_AB;//13bits
	output reg PE1_IF_w,PE2_IF_w,PE3_IF_w;
	output reg PE1_W_w,PE2_W_w,PE3_W_w;
	output reg Pool_en; 
	output reg Decode_en;
	output reg [1:0] Adder_mode;
	output reg [1:0] MUX2_sel;
	output reg MUX1_sel,MUX3_sel; 

//complete your design here
parameter INIT= 		6'd0;
parameter READ_W=		6'd1;
parameter WRITE=		6'd2;
parameter READ_C=		6'd3;
parameter READ_9=		6'd4;
parameter conv_Done=  	6'd5;
parameter start=		6'd6;



parameter Pooling_INIT =    6'd7;
parameter Pooling_READ =    6'd8;
parameter Pooling_WRITE=    6'd9;
parameter Pooling_DONE =    6'd10;


parameter Conv2_INIT   =    6'd11;
parameter Conv2_READW  =    6'd12;
parameter Conv2_WRITE  =    6'd13;
parameter Conv2_READ9 =     6'd14;
parameter Conv2_READC =     6'd15;
parameter Conv2_DONE   =    6'd16;


parameter Pooling3_INIT =    6'd17;
parameter Pooling3_READ =    6'd18;
parameter Pooling3_WRITE=    6'd19;
parameter Pooling3_DONE =    6'd20;


parameter FC4_INIT=6'd21;
parameter FC4_READ_9=6'd22;
parameter FC4_WRITE=6'd23;
parameter FC4_DONE=6'd24;


parameter FC5_INIT=6'd25;
parameter FC5_READ_9=6'd26;
parameter FC5_WRITE=6'd27;
parameter FC5_DONE=6'd28;

parameter DECODER_INIT=6'd29;
parameter DECODER_READ =6'd30;
parameter DECODER_WRITE=6'd31;
parameter FINISH=6'd32;

  reg   [5:0]  state,n_state;
  reg	[`ROM_IM_ADDR_BITS-1:0] column;
  reg   [`ROM_IM_ADDR_BITS-1:0]  row;
  reg   [3:0]	counter;
  reg   [2:0]   conv0_num;//6
  reg   [3:0]   conv2_num;//15
  reg   [5:0]   FC4_count;//60
  reg   [7:0]   FC4_num;  //180
  reg   [4:0]   FC5_count;//20
  reg   [3:0]   FC5_num;  //10
  reg   [3:0] decoder_num;
always@(posedge clk or posedge rst)begin//state
//if(START)
	//state<=start;
if(rst)
    state<=start;
//else
else
begin
	state<=n_state;
end
end




always@(posedge clk or posedge rst)begin//counter for all cases
  //if(START)begin
 	
//  end
if(rst)begin
    
    conv0_num<=3'd0;
	decoder_num<=4'd0;
	counter<=4'd0;
	FC4_num<=8'd0;
	FC4_count<=6'd0;
	FC5_num<=4'd0;
	FC5_count<=5'd0;
  end

//decoder
else if(state==DECODER_INIT)
begin
  counter<=4'd0;
end
else if(state==DECODER_READ)
begin
decoder_num<=decoder_num+8'd1;
if(decoder_num==8'd10)begin
decoder_num<=0;

end
end
//FC5
 else if(state==FC5_READ_9 && counter==4'd9)
begin
      counter<=4'd0;
	FC5_count<=FC5_count+1;
end
  else if(state==FC5_READ_9)
     counter<=counter+4'd1;
  else if(state==FC5_WRITE || state==FC5_INIT)
     counter<=4'd0;
  else if(state==FC5_DONE)
begin
	 FC5_count<=0;
	 FC5_num<=FC5_num+3'd1;
end

//------------------------------------------
//FC4---------------------------------
  else if(state==FC4_READ_9 && counter==4'd9)
begin
      counter<=4'd0;
	FC4_count<=FC4_count+1;
end
  else if(state==FC4_READ_9)
     counter<=counter+4'd1;
  else if(state==FC4_WRITE || state==FC4_INIT)
     counter<=4'd0;
  else if(state==FC4_DONE)
begin
	 FC4_count<=0;
	 FC4_num<=FC4_num+3'd1;
end
//------FC_end
//Conv0------------------------------
  else if(state==READ_W && counter==4'd9)
      counter<=4'd0;
  else if(state==READ_W)
     counter<=counter+4'd1;
  else if(state==READ_C)
     counter<=counter+4'd1;
  else if(state==READ_9)
     counter<=counter+4'd1;
  else if(state==WRITE || state==INIT)
     counter<=4'd0;
  else if(state==conv_Done)
     begin

	 conv0_num<=conv0_num+3'd1;
	 end
//Pooling-----------------------------
else if(state==Pooling_INIT)
begin
   counter<=4'd0;
conv0_num<=3'd0;
end
else if(state==Pooling_READ && counter==4'd4)
begin
counter<=4'd0;
end
else if(state==Pooling_READ)
begin
   counter<=counter+4'd1;
end
   else if(state==Pooling_WRITE && column==10'd26 &&row==10'd26)
begin
counter<=4'd0;
conv0_num<=conv0_num+1;
end
   else if(state==Pooling_WRITE)
begin
counter<=4'd0;
end
else if(state==Pooling_DONE)
begin
conv0_num<=3'd0;
conv2_num<=4'd0;
end
//Pooling3---------------------------

else if(state==Pooling3_INIT)
begin
   counter<=4'd0;
   conv2_num<=4'd0;
end
else if(state==Pooling3_READ && counter==4'd4)
begin
counter<=4'd0;
end
else if(state==Pooling3_READ)
begin
   counter<=counter+4'd1;
end
   else if(state==Pooling3_WRITE && column==10'd10 &&row==10'd10)
begin
counter<=4'd0;
conv2_num<=conv2_num+1;
end
   else if(state==Pooling3_WRITE)
begin
counter<=4'd0;
end
else if(state==Pooling3_DONE)
begin
conv2_num<=4'd0;
end

//-----------------------------------
//Conv2----------------------------
else if(state==Conv2_INIT)
begin
counter<=4'd0;
end

else if(state==Conv2_READW && counter==4'd9)
begin
counter<=4'd0;
end
else if(state==Conv2_READW)
     counter<=counter+4'd1;
else if(state==Conv2_READC)
     counter<=counter+4'd1;
else if(state==Conv2_READ9)
     counter<=counter+4'd1;
else if(state==Conv2_WRITE)
     counter<=4'd0;
else if(state==Conv2_DONE)
begin
    if(conv0_num!=3'd5)
    conv0_num<=conv0_num+3'd1;
	else
	begin
	conv0_num<=3'd0;
	conv2_num<=conv2_num+4'd1;
	end
end
	
	
end	



always@(*)begin//PE_W_w PE_IF_w for CONV
//FC5-----------------

if(state==FC5_INIT)begin
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(state==FC5_READ_9)
	begin
if(counter==4'd0)begin//
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else  if(counter==4'd1)begin
  			//sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd2)begin
  		  //sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd3)begin
  		//	sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end

else   if(counter==4'd4)begin
           //       sel_w=3'b010;
		  //sel_if=3'b010;
    PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd5)begin
               //   sel_w=3'b010;
		 // sel_if=3'b010;
    PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd6)begin
                 // sel_w=3'b010;
		 // sel_if=3'b010;
	PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else  if(counter==4'd7)begin
              //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd8)begin
                 //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd9)begin
                //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else begin
 	           //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
    end
end


//---------------------------
//FC4----------

else if(state==FC4_INIT)begin
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(state==FC4_READ_9)
	begin
if(counter==4'd0)begin//
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else  if(counter==4'd1)begin
  			//sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd2)begin
  		  //sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd3)begin
  		//	sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end

else   if(counter==4'd4)begin
           //       sel_w=3'b010;
		  //sel_if=3'b010;
    PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd5)begin
               //   sel_w=3'b010;
		 // sel_if=3'b010;
    PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd6)begin
                 // sel_w=3'b010;
		 // sel_if=3'b010;
	PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else  if(counter==4'd7)begin
              //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd8)begin
                 //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd9)begin
                //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else begin
 	           //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
    end
end
	

//FC4_end--------------------------------------------

//Conv0
else if(state==INIT)begin
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(state==READ_W)
	begin
if(counter==4'd0)begin//
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else  if(counter==4'd1)begin
  			//sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd2)begin
  		  //sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd3)begin
  		//	sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end

else   if(counter==4'd4)begin
           //       sel_w=3'b010;
		  //sel_if=3'b010;
    PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd5)begin
               //   sel_w=3'b010;
		 // sel_if=3'b010;
    PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd6)begin
                 // sel_w=3'b010;
		 // sel_if=3'b010;
	PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else  if(counter==4'd7)begin
              //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd8)begin
                 //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd9)begin
                //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else begin
 	           //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
    end
end
	
	
else if(state==READ_C)
	begin
          if(counter==4'd0)begin
                  //sel_if=3'b000;
	            //sel_w=3'b000;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
			  end
         else if(counter==4'd1)begin
                 // sel_if=3'b001;
			//sel_w=3'b000;
	PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
              end
         else if(counter==4'd2)begin
          //sel_if=3'b010;
		//sel_w=3'b000;
	PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
	 else if(counter==4'd3)begin
                  //sel_if=3'b100;
			//sel_w=3'b000;
	PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  
begin
			//sel_if=3'b100;
			//sel_w=3'b000;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
    end
else if(state==READ_9)begin
if(counter==4'd0)begin//
                //  sel_w=3'b000;
		  //sel_if=3'b000;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
              end
else  if(counter==4'd1)begin
  			//sel_w=3'b000;
		  //sel_if=3'b001;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd2)begin
  			//sel_w=3'b000;
		//  sel_if=3'b001;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd3)begin
  			//sel_w=3'b000;
		  //sel_if=3'b001;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end

else   if(counter==4'd4)begin
                 // sel_w=3'b000;
		 // sel_if=3'b010;
     PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd5)begin
                  //sel_w=3'b000;
		  //sel_if=3'b010;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd6)begin
                 // sel_w=3'b000;
		  //sel_if=3'b010;
		   PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else  if(counter==4'd7)begin
                 // sel_w=3'b000;
	        //  sel_if=3'b100;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd8)begin
              //    sel_w=3'b000;
	         // sel_if=3'b100;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd9)begin
              //    sel_w=3'b000;
	          // sel_if=3'b100;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else begin
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
end
else if(state==WRITE)begin
	PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end

//----------------------
//Conv2---------------------------

else if(state==Conv2_INIT)begin
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(state==Conv2_READW)
	begin
if(counter==4'd0)begin//
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else  if(counter==4'd1)begin
  			//sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd2)begin
  		  //sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd3)begin
  		//	sel_w=3'b001;
		  //sel_if=3'b001;
    PE1_W_w=1'b1;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end

else   if(counter==4'd4)begin
           //       sel_w=3'b010;
		  //sel_if=3'b010;
    PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd5)begin
               //   sel_w=3'b010;
		 // sel_if=3'b010;
    PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd6)begin
                 // sel_w=3'b010;
		 // sel_if=3'b010;
	PE1_W_w=1'b0;
	PE2_W_w=1'b1;
	PE3_W_w=1'b0;
   PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else  if(counter==4'd7)begin
              //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd8)begin
                 //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd9)begin
                //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b1;
   PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else begin
 	           //sel_w=3'b100;
	          //sel_if=3'b100;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
    end
end
	
	
else if(state==Conv2_READC)
	begin
          if(counter==4'd0)begin
                  //sel_if=3'b000;
	            //sel_w=3'b000;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
			  end
         else if(counter==4'd1)begin
                 // sel_if=3'b001;
			//sel_w=3'b000;
	PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
              end
         else if(counter==4'd2)begin
          //sel_if=3'b010;
		//sel_w=3'b000;
	PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
	 else if(counter==4'd3)begin
                  //sel_if=3'b100;
			//sel_w=3'b000;
	PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  
begin
			//sel_if=3'b100;
			//sel_w=3'b000;
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
   PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
    end
else if(state==Conv2_READ9)begin
if(counter==4'd0)begin//
                //  sel_w=3'b000;
		  //sel_if=3'b000;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
              end
else  if(counter==4'd1)begin
  			//sel_w=3'b000;
		  //sel_if=3'b001;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd2)begin
  			//sel_w=3'b000;
		//  sel_if=3'b001;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
     PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
else if(counter==4'd3)begin
  			//sel_w=3'b000;
		  //sel_if=3'b001;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b1;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end

else   if(counter==4'd4)begin
                 // sel_w=3'b000;
		 // sel_if=3'b010;
     PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd5)begin
                  //sel_w=3'b000;
		  //sel_if=3'b010;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else   if(counter==4'd6)begin
                 // sel_w=3'b000;
		  //sel_if=3'b010;
		   PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b1;
	PE3_IF_w=1'b0;
              end
else  if(counter==4'd7)begin
                 // sel_w=3'b000;
	        //  sel_if=3'b100;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd8)begin
              //    sel_w=3'b000;
	         // sel_if=3'b100;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else  if(counter==4'd9)begin
              //    sel_w=3'b000;
	          // sel_if=3'b100;
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
     PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b1;
              end
else begin
      PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
      PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end
end
else if(state==Conv2_WRITE)begin
	PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end

//Conv2_end----------------------------------

else 
begin
    PE1_W_w=1'b0;
	PE2_W_w=1'b0;
	PE3_W_w=1'b0;
    PE1_IF_w=1'b0;
	PE2_IF_w=1'b0;
	PE3_IF_w=1'b0;
end




end



always@(*)//Pool_en
begin
if(state==Pooling_READ ||state==Pooling3_READ)
begin
if(counter>=0)
begin
Pool_en=1'b1;
end
else
Pool_en=1'b1;
end
else if(state==Pooling_WRITE||state==Pooling3_WRITE)
Pool_en=1'b1;
else if(state==Pooling_DONE ||state==Pooling3_DONE)
Pool_en=1'b0;
else
Pool_en=1'b0;
end




always@(*)//SRAM_AA
begin
if(state==INIT)
SRAM_AA=13'd0;
//DECODER_INIT

else if(state==DECODER_READ)
begin
SRAM_AA=decoder_num+4704;
end

//DECODER_INIT----
//Pooling
else if(state==Pooling_READ)
begin
if(counter==4'd0)
SRAM_AA=row*28+column+784*conv0_num;
else if(counter==4'd1)
SRAM_AA=row*28+column+1+784*conv0_num;
else if(counter==4'd2)
SRAM_AA=(row+1)*28+column+784*conv0_num;
else if(counter==4'd3)
SRAM_AA=(row+1)*28+column+1+784*conv0_num;
else
SRAM_AA=(row+1)*28+column+1+784*conv0_num;
end
//Pooling_end
//FC5----------------------------
 else   if(state==FC5_READ_9)begin
   if(counter==4'd0)begin
    SRAM_AA=9*FC5_count+0;
   end
   
  else if(counter==4'd1)begin
   SRAM_AA=9*FC5_count+1;
   end
   
   else if(counter==4'd2)begin
SRAM_AA=9*FC5_count+2;
   end
   
   else if(counter==4'd3)begin
  SRAM_AA=9*FC5_count+3;
   end
   
    else if(counter==4'd4)begin
    SRAM_AA=9*FC5_count+4;
   end
   
    else if(counter==4'd5)begin
SRAM_AA=9*FC5_count+5;
   end
   
    else if(counter==4'd6)begin
SRAM_AA=9*FC5_count+6;
   end
   
    else if(counter==4'd7)begin
SRAM_AA=9*FC5_count+7;
   end
   
    else if(counter==4'd8)begin
SRAM_AA=9*FC5_count+8;
   end

    else if(counter==4'd9)begin
SRAM_AA=FC5_num+4704;////////////////////////////
   end   
else
SRAM_AA=FC5_num;
end






//-------------------------------------------
//FC4-------------------------------

 else   if(state==FC4_READ_9)begin
   if(counter==4'd0)begin
    SRAM_AA=4704+9*FC4_count+0;
   end
   
  else if(counter==4'd1)begin
   SRAM_AA=4704+9*FC4_count+1;
   end
   
   else if(counter==4'd2)begin
SRAM_AA=4704+9*FC4_count+2;
   end
   
   else if(counter==4'd3)begin
  SRAM_AA=4704+9*FC4_count+3;
   end
   
    else if(counter==4'd4)begin
    SRAM_AA=4704+9*FC4_count+4;
   end
   
    else if(counter==4'd5)begin
SRAM_AA=4704+9*FC4_count+5;
   end
   
    else if(counter==4'd6)begin
SRAM_AA=4704+9*FC4_count+6;
   end
   
    else if(counter==4'd7)begin
SRAM_AA=4704+9*FC4_count+7;
   end
   
    else if(counter==4'd8)begin
SRAM_AA=4704+9*FC4_count+8;
   end

    else if(counter==4'd9)begin
SRAM_AA=FC4_num;
   end   
else
SRAM_AA=4704+9*FC4_count+8;
end


//FC4_end----------------------------------
//Pooling3-----------------------------
else if(state==Pooling3_READ)
begin
if(counter==4'd0)
SRAM_AA=row*12+column+144*conv2_num;
else if(counter==4'd1)
SRAM_AA=row*12+column+1+144*conv2_num;
else if(counter==4'd2)
SRAM_AA=(row+1)*12+column+144*conv2_num;
else if(counter==4'd3)
SRAM_AA=(row+1)*12+column+1+144*conv2_num;
else
SRAM_AA=(row+1)*12+column+1+144*conv2_num;
end
//Pooling3_end---------------------------



//CONV2--------------------------------

else if(state==Conv2_INIT)begin
SRAM_AA=14'd0;
end


else if(state==Conv2_READW)
begin
if(counter==4'd0)
SRAM_AA=14*(row)+(column)+196*conv0_num+4704;
else if(counter==4'd1)
SRAM_AA=14*(row)+(column+10'd1)+196*conv0_num+4704;
else if(counter==4'd2)
SRAM_AA=14*(row)+(column+10'd2)+196*conv0_num+4704;
else if(counter==4'd3)
SRAM_AA=14*(row+1)+(column)+196*conv0_num+4704;
else if(counter==4'd4)
SRAM_AA=14*(row+1)+(column+10'd1)+196*conv0_num+4704;
else if(counter==4'd5)
SRAM_AA=14*(row+1)+(column+10'd2)+196*conv0_num+4704;
else if(counter==4'd6)
SRAM_AA=14*(row+2)+(column)+196*conv0_num+4704;
else if(counter==4'd7)
SRAM_AA=14*(row+2)+(column+10'd1)+196*conv0_num+4704;
else if(counter==4'd8)
SRAM_AA=14*(row+2)+(column+10'd2)+196*conv0_num+4704;
else if(counter==4'd9)
SRAM_AA=(row*12+column)+(144*conv2_num);//psum
else
SRAM_AA=14*(row+2)+(column+10'd2)+196*conv0_num+4704;
end
else if(state==Conv2_READ9)begin
    if(counter==4'd0)begin
    SRAM_AA=14*row+column+196*conv0_num+4704;
   end
   
  else if(counter==4'd1)begin
    SRAM_AA=14*(row)+(column+10'd1)+196*conv0_num+4704;
   end
   
   else if(counter==4'd2)begin
    SRAM_AA=14*(row)+(column+10'd2)+196*conv0_num+4704;
   end
   
   else if(counter==4'd3)begin
  SRAM_AA=14*(row+1)+(column)+196*conv0_num+4704;
   end
   
    else if(counter==4'd4)begin
   SRAM_AA=14*(row+1)+(column+10'd1)+196*conv0_num+4704;
   end
   
    else if(counter==4'd5)begin
   SRAM_AA=14*(row+1)+(column+10'd2)+196*conv0_num+4704;
   end
   
    else if(counter==4'd6)begin
    SRAM_AA=14*(row+2)+(column)+196*conv0_num+4704;
   end
   
    else if(counter==4'd7)begin
    SRAM_AA=14*(row+2)+(column+10'd1)+196*conv0_num+4704;
   end
   
    else if(counter==4'd8)begin
    SRAM_AA=14*(row+2)+(column+10'd2)+196*conv0_num+4704;
   end

    else if(counter==4'd9)begin
  SRAM_AA=(row*12+column)+(144*conv2_num);//psum
   end
else
SRAM_AA=14*(row+2)+(column+10'd2)+196*conv0_num+4704;
end   

else if(state==Conv2_READC)begin
          if(counter==4'd0)begin
             SRAM_AA=(14*row)+column+196*conv0_num+4704;
          end
         else if(counter==4'd1)begin
             SRAM_AA=(14*(row+10'd1))+column+196*conv0_num+4704;
          end
         else if(counter==4'd2)begin
             SRAM_AA=(14*(row+10'd2))+column+196*conv0_num+4704;
          end
	     else if(counter==4'd3)begin
       SRAM_AA=(row*12+(column-10'd2))+(144*conv2_num);// psum
          end
         else
		     SRAM_AA=(30*(row+10'd2))+column+196*conv0_num+4704;
         

end
else
SRAM_AA=13'd0;
/*
else if(state==Conv2_WRITE)
begin
if(column==10'd0)
SRAM_AA=(row*12+column)+(144*conv2_num);
end
else
begin
SRAM_AA=(row*12+(column-10'd2))+(144*conv2_num);
end
*/
//-----------------------------------------

end






always@(*)begin//SRAM_AB
if(state==INIT)
begin
SRAM_AB=13'd0;
//SRAM_AA=13'd0;
end
//DECODER_READ
else if(state==DECODER_READ)
SRAM_AB=0;
//
//FC5--------------------
else if(state==FC5_READ_9||state==FC5_WRITE)
SRAM_AB=FC5_num+4704;
//-------------------------------


//FC4-----------------------
else if(state==FC4_READ_9||state==FC4_WRITE)
SRAM_AB=FC4_num;


//FC4_end

//Pooling1-----------------------------
else if(state==Pooling_READ)
begin
SRAM_AB=14*(row/2)+(column/2)+196*conv0_num+4704;
end
else if(state==Pooling_WRITE)
begin
SRAM_AB=14*(row/2)+(column/2)+196*conv0_num+4704;
end
//Pooling1_end-----------------------------------------

//Pooling3---------------------------
else if(state==Pooling3_READ)
begin
SRAM_AB=6*(row/2)+(column/2)+36*conv2_num+4704;
end
else if(state==Pooling3_WRITE)
begin
SRAM_AB=6*(row/2)+(column/2)+36*conv2_num+4704;
end

//Pooling3_end
//CONV2--------------------------------
else if(state!=INIT &&state!=READ_W&&state!=WRITE&&state!=READ_C&&state!=READ_9&&state!=conv_Done)
begin

if(column==10'd0 &&state!=Pooling_READ)
begin
SRAM_AB=(row*12+column)+(144*conv2_num);
end
else if(column!=10'd0 &&state!=Pooling_READ)
begin
SRAM_AB=(row*12+(column-10'd2))+(144*conv2_num);
end
else
SRAM_AB=(row*12+(column-10'd2))+(144*conv2_num);
end
/*

parameter Pooling3_INIT
parameter Pooling3_READ
parameter Pooling3_WRITE
parameter Pooling3_DONE
parameter FC4_INIT=6'd21;
parameter FC4_READ_9=6'd22;
parameter FC4_WRITE=6'd23;
parameter FC4_DONE=6'd24;
parameter FC5_INIT=6'd25;
parameter FC5_READ_9=6'd26;
parameter FC5_WRITE=6'd27;
parameter FC5_DONE=6'd28;
parameter DECODER_INIT=6'd29;
parameter DECODER_READ =6'd30;
parameter DECODER_WRITE=6'd31;
parameter FINISH=6'd32;
*/

//----------------------------------
//Conv0--------------------------------------
else if(column==10'd0 &&state!=Pooling_READ)
begin
SRAM_AB=(row*28+column)+(784*conv0_num);
end
else if(column!=10'd0 &&state!=Pooling_READ)
begin
SRAM_AB=(row*28+(column-10'd2))+(784*conv0_num);
end
//Conv0_end----------------------------------------

else 
SRAM_AB=13'd0;

end





always@(*)//ROM_bias
begin
if(state==READ_W)
ROM_B_A=conv0_num;

//CONV2--------------------------------
else if(state==Conv2_READW)
ROM_B_A=conv2_num+6;

//FC4
else if(state==FC4_READ_9)
ROM_B_A=21+FC4_num;

//FC5
else if(state==FC5_READ_9)
ROM_B_A=201+FC5_num;

//else
//ROM_B_A=conv0_num;


end


always@(*)begin//ROM_IM_A 
   
if(state==INIT)
ROM_IM_A=10'd0;
 else   if(state==READ_W)begin
   if(counter==4'd0)begin
    ROM_IM_A=(row*30)+column;
   end
   
  else if(counter==4'd1)begin
    ROM_IM_A=(row*30)+(column+10'd1);
   end
   
   else if(counter==4'd2)begin
    ROM_IM_A=(row*30)+(column+10'd2);
   end
   
   else if(counter==4'd3)begin
    ROM_IM_A=((row+10'd1)*30)+column;
   end
   
    else if(counter==4'd4)begin
    ROM_IM_A=((row+10'd1)*30)+(column+10'd1);
   end
   
    else if(counter==4'd5)begin
    ROM_IM_A=((row+10'd1)*30)+(column+10'd2);
   end
   
    else if(counter==4'd6)begin
    ROM_IM_A=((row+10'd2)*30)+column;
   end
   
    else if(counter==4'd7)begin
    ROM_IM_A=((row+10'd2)*30)+(column+10'd1);
   end
   
    else if(counter==4'd8)begin
    ROM_IM_A=((row+10'd2)*30)+(column+10'd2);
   end

    else if(counter==4'd9)begin
   ROM_IM_A=((row+10'd2)*30)+(column+10'd2);
   end   
else
 ROM_IM_A=((row+10'd2)*30)+(column+10'd2);
end

   else if(state==READ_9)begin
    if(counter==4'd0)begin
    ROM_IM_A=30*row+column;
   end
   
  else if(counter==4'd1)begin
    ROM_IM_A=30*row+(column+10'd1);
   end
   
   else if(counter==4'd2)begin
    ROM_IM_A=30*row+(column+10'd2);
   end
   
   else if(counter==4'd3)begin
    ROM_IM_A=30*(row+10'd1)+column;
   end
   
    else if(counter==4'd4)begin
     ROM_IM_A=30*(row+10'd1)+(column+10'd1);
   end
   
    else if(counter==4'd5)begin
    ROM_IM_A=30*(row+10'd1)+(column+20'd2);
   end
   
    else if(counter==4'd6)begin
    ROM_IM_A=30*(row+10'd2)+column;
   end
   
    else if(counter==4'd7)begin
     ROM_IM_A=30*(row+10'd2)+(column+10'd1);
   end
   
    else if(counter==4'd8)begin
     ROM_IM_A=30*(row+10'd2)+(column+10'd2);
   end

    else if(counter==4'd9)begin
    ROM_IM_A=30*(row+10'd2)+(column+10'd2);
   end
else
  ROM_IM_A=30*(row+10'd2)+(column+10'd2);
    end   
   else if(state==READ_C)begin
          if(counter==4'd0)begin
             ROM_IM_A=(30*row)+column;
          end
         else if(counter==4'd1)begin
             ROM_IM_A=(30*(row+10'd1))+column;
          end
         else if(counter==4'd2)begin
             ROM_IM_A=(30*(row+10'd2))+column;
          end
	 else if(counter==4'd3)begin
             ROM_IM_A=(30*(row+10'd2))+column;
          end
         else
   ROM_IM_A=(30*(row+10'd2))+column;
   end
else
ROM_IM_A=10'd0;
end

always@(*)begin// ROM_W_A
   if(state==INIT)
ROM_W_A=17'd0;

//FC5-----------------------------------
else if(state==FC5_READ_9)
begin
		if(counter==4'd0)
         ROM_W_A=98064+9*FC5_count+0+180*FC5_num;

 		else if(counter==4'd1)
               ROM_W_A=98064+9*FC5_count+1+180*FC5_num;
       	else if(counter==4'd2)
               ROM_W_A=98064+9*FC5_count+2+180*FC5_num;
    	else if(counter==4'd3)
               ROM_W_A=98064+9*FC5_count+3+180*FC5_num;
    	else if(counter==4'd4)
               ROM_W_A=98064+9*FC5_count+4+180*FC5_num;
    	else if(counter==4'd5)
               ROM_W_A=98064+9*FC5_count+5+180*FC5_num;
	else if(counter==4'd6)
               ROM_W_A=98064+9*FC5_count+6+180*FC5_num;
	else if(counter==4'd7)
               ROM_W_A=98064+9*FC5_count+7+180*FC5_num;
else if(counter==4'd8)
               ROM_W_A=98064+9*FC5_count+8+180*FC5_num;
else if(counter==4'd9)
               ROM_W_A=98064+9*FC5_count+9+180*FC5_num;
else if(counter==4'd10)
               ROM_W_A=98064+9*FC5_count+10+180*FC5_num;
else
ROM_W_A=98064+9*FC5_count+10+180*FC5_num;

end





//FC5_end-----------------------------------
//FC4-------------------------------------
else if(state==FC4_READ_9)
begin
		if(counter==4'd0)
         ROM_W_A=864+9*FC4_count+0+540*FC4_num;

 		else if(counter==4'd1)
               ROM_W_A=864+9*FC4_count+1+540*FC4_num;
       	else if(counter==4'd2)
               ROM_W_A=864+9*FC4_count+2+540*FC4_num;
    	else if(counter==4'd3)
               ROM_W_A=864+9*FC4_count+3+540*FC4_num;
    	else if(counter==4'd4)
               ROM_W_A=864+9*FC4_count+4+540*FC4_num;
    	else if(counter==4'd5)
               ROM_W_A=864+9*FC4_count+5+540*FC4_num;
	else if(counter==4'd6)
               ROM_W_A=864+9*FC4_count+6+540*FC4_num;
	else if(counter==4'd7)
               ROM_W_A=864+9*FC4_count+7+540*FC4_num;
else if(counter==4'd8)
               ROM_W_A=864+9*FC4_count+8+540*FC4_num;
else if(counter==4'd9)
               ROM_W_A=864+9*FC4_count+9+540*FC4_num;
else if(counter==4'd10)
               ROM_W_A=864+9*FC4_count+10+540*FC4_num;
else
ROM_W_A=864+9*FC4_count+10+540*FC4_num;
end


//fc4_end-----------------------------------


 else   if(state==READ_W)begin
          if(counter==4'd0)begin
             ROM_W_A=(17'd0)+9*(conv0_num);
              end
         else if(counter==4'd1)begin
             ROM_W_A=17'd1+9*(conv0_num);
              end
         else if(counter==4'd2)begin
             ROM_W_A=17'd2+9*(conv0_num);
              end
         else if(counter==4'd3)begin
             ROM_W_A=17'd3+9*(conv0_num);
              end
         else if(counter==4'd4)begin
             ROM_W_A=17'd4+9*(conv0_num);
              end
         else if(counter==4'd5)begin
             ROM_W_A=17'd5+9*(conv0_num);
              end
         else if(counter==4'd6)begin
             ROM_W_A=17'd6+9*(conv0_num);
              end
         else if(counter==4'd7)begin
             ROM_W_A=17'd7+9*(conv0_num);
              end
         else if(counter==4'd8)begin
             ROM_W_A=17'd8+9*(conv0_num);
              end
	else if(counter==4'd9)begin

	ROM_W_A=17'd8+9*(conv0_num);
	
	end
else ROM_W_A=17'd8+9*(conv0_num);
    end   


 else if(state==Conv2_INIT)
ROM_W_A=17'd54;
 else   if(state==Conv2_READW)begin
          if(counter==4'd0)begin
             ROM_W_A=54+(17'd0)+9*(conv0_num)+54*conv2_num;
              end
         else if(counter==4'd1)begin
             ROM_W_A=54+17'd1+9*(conv0_num)+54*conv2_num;
              end
         else if(counter==4'd2)begin
             ROM_W_A=54+17'd2+9*(conv0_num)+54*conv2_num;
              end
         else if(counter==4'd3)begin
             ROM_W_A=54+17'd3+9*(conv0_num)+54*conv2_num;
              end
         else if(counter==4'd4)begin
             ROM_W_A=54+17'd4+9*(conv0_num)+54*conv2_num;
              end
         else if(counter==4'd5)begin
             ROM_W_A=54+17'd5+9*(conv0_num)+54*conv2_num;
              end
         else if(counter==4'd6)begin
             ROM_W_A=54+17'd6+9*(conv0_num)+54*conv2_num;
              end
         else if(counter==4'd7)begin
             ROM_W_A=54+17'd7+9*(conv0_num)+54*conv2_num;
              end
         else if(counter==4'd8)begin
             ROM_W_A=54+17'd8+9*(conv0_num)+54*conv2_num;
              end
	else if(counter==4'd9)begin

	ROM_W_A=54+17'd8+9*(conv0_num)+54*conv2_num;
	
	end
	
else ROM_W_A=54+17'd8+9*(conv2_num)+54*conv2_num;
    end   

else
ROM_W_A=17'd0;
end

always@(posedge clk or posedge rst)begin//col row
  if(rst)begin
     column<=10'd0;
	 row<=10'd0;
  end
else if(state==INIT)
begin
     column<=10'd0;
	 row<=10'd0;
end
else if (column==10'd0 && state==WRITE)
begin

column<=column+10'd3;
end
else if(state==WRITE && column==10'd29)begin
        column<=10'd0;
        row<=row+10'd1;
   end

else if(state==WRITE)
   column<=column+10'd1;

else if(state==READ_C)
  row<=row;
//Pooling------------------------
else if(state==Pooling_INIT)
begin

   column<=10'd0;
   row<=10'd0;
end
else if(state==Pooling_WRITE && (column==10'd26 && row==10'd26))
begin

column<=10'd0;
row<=10'd0;
end
else if(state==Pooling_WRITE && column==10'd26)
begin
column<=10'd0;
row<=row+10'd2;
end
else if (state==Pooling_WRITE)
begin
column<=column+10'd2;
end
//Pooling_end-----------------------------

//Conv2---------------------------

else if(state==Conv2_INIT)
begin
     column<=10'd0;
	 row<=10'd0;
end
else if (column==10'd0 && state==Conv2_WRITE)
begin

column<=column+10'd3;
end
else if(state==Conv2_WRITE && column==10'd13)begin
        column<=10'd0;
        row<=row+10'd1;
   end

else if(state==Conv2_WRITE)
   column<=column+10'd1;

else if(state==Conv2_READC)
  row<=row;


//Conv2_end-------------------

//Pooling3--------------------

else if(state==Pooling3_INIT)
begin

   column<=10'd0;
   row<=10'd0;
end
else if(state==Pooling3_WRITE && (column==10'd10 && row==10'd10))
begin

column<=10'd0;
row<=10'd0;
end
else if(state==Pooling3_WRITE && column==10'd10)
begin
column<=10'd0;
row<=row+10'd2;
end
else if (state==Pooling3_WRITE)
begin
column<=column+10'd2;
end

//Pooling_end
end

     always@(*)begin//n_state
  case(state)
start:begin
n_state=INIT;

end
//Conv0---------------------
       INIT:begin
            n_state=READ_W;
end
       READ_W:begin
                  if(counter==4'd9)
                     n_state=WRITE;
                  else
                     n_state=READ_W;
              end
       READ_C:begin
                  if(counter==4'd3)
                     n_state=WRITE;
                  else
                     n_state=READ_C;
              end
       READ_9:begin
                  if(counter==4'd9)
                     n_state=WRITE;
                  else
                     n_state=READ_9;
              end
	WRITE:begin
    if(column==10'd29&&row==10'd27)
                     n_state=conv_Done;
                  else if(column==10'd29)
                     n_state=READ_9;
                  else
                     n_state=READ_C;
end
       conv_Done:
begin 
			if(conv0_num!=3'd5)
			n_state=INIT;
                 else    
			n_state=Pooling_INIT;
end
//----------------------------
//Pooling 1---------------------
        Pooling_INIT:
begin
        n_state=Pooling_READ;




end
         Pooling_READ:
begin
             if(counter==3'd4)
                n_state=Pooling_WRITE;
              else
		     n_state=Pooling_READ;
end
         Pooling_WRITE:
begin
               if(column==10'd26 && row==10'd26 &&conv0_num==3'd5)
            n_state=Pooling_DONE;
                   else
                n_state=Pooling_READ;
end
Pooling_DONE:
begin

n_state=Conv2_INIT;

end
//Pooling_end------------------------------------------
//Pooling3--------------------
        Pooling3_INIT:
begin
        n_state=Pooling3_READ;
end

         Pooling3_READ:
begin
             if(counter==3'd4)
                n_state=Pooling3_WRITE;
              else
		     n_state=Pooling3_READ;
end
         Pooling3_WRITE:
begin
               if(column==10'd10 && row==10'd10 &&conv2_num==4'd14)
            n_state=Pooling3_DONE;
                   else
                n_state=Pooling3_READ;
end
		Pooling3_DONE:
begin

n_state=FC4_INIT;

end

//Pooling3_end


 //Conv2-----------------------------------------
		   Conv2_INIT:
begin
		   n_state=Conv2_READW;
end
		   Conv2_READW:
begin
		   
                  if(counter==4'd9)
                     n_state=Conv2_WRITE;
                  else
                     n_state=Conv2_READW;
            
end
		     Conv2_READC:
begin
                  if(counter==4'd3)
                     n_state=Conv2_WRITE;
                  else
                     n_state=Conv2_READC;
end
		    Conv2_READ9:
begin
                  if(counter==4'd9)
                     n_state=Conv2_WRITE;
                  else
                     n_state=Conv2_READ9;
end
	Conv2_WRITE:
begin
                  if((column==10'd13) &&( row==10'd11))
                     n_state=Conv2_DONE;
                  else if(column==10'd13)
                     n_state=Conv2_READ9;
                  else
                     n_state=Conv2_READC;
end
       Conv2_DONE:
begin 
			if(conv2_num==4'd14 &&conv0_num==3'd5)
				n_state=Pooling3_INIT;
            else    
			n_state=Conv2_INIT;
end
//FC4-------------------------------
         FC4_INIT:
begin


	n_state=FC4_READ_9;


end

FC4_READ_9:
begin

 			if(counter==4'd9)
                     n_state=FC4_WRITE;
                  else
                     n_state=FC4_READ_9;



end

FC4_WRITE:
begin


if(FC4_count==60)
begin
n_state=FC4_DONE;
end
else
n_state=FC4_READ_9;
end



FC4_DONE:
begin

if(FC4_num==179)
n_state=FC5_INIT;
else 
n_state=FC4_READ_9;


end
//FC4--end---------------------------------


//FC5----------------------------------
         FC5_INIT:
begin


	n_state=FC5_READ_9;


end

FC5_READ_9:
begin

 			if(counter==4'd9)
                     n_state=FC5_WRITE;
                  else
                     n_state=FC5_READ_9;



end

FC5_WRITE:
begin


if(FC5_count==20)
begin
n_state=FC5_DONE;
end
else
n_state=FC5_READ_9;
end



FC5_DONE:
begin

if(FC5_num==9)
n_state=DECODER_READ;
else 
n_state=FC5_READ_9;


end
//fc5_end------------------------------------------------

//DECODER

DECODER_INIT:
n_state=DECODER_READ;


DECODER_READ:begin
if(decoder_num==10)
n_state=DECODER_WRITE;
else
n_state=DECODER_READ;
end
DECODER_WRITE:
n_state=FINISH;
//-----------------------------------------
//-----------------------------------------		   
 default:n_state=start;
endcase
end




	//ROM
	//ROM_IM_CS,ROM_W_CS,ROM_B_CS,
	//ROM_IM_OE,ROM_W_OE,ROM_B_OE,
	//SRAM
	//SRAM_CENA,SRAM_CENB,
	//SRAM_WENB,
	//SRAM_AA,SRAM_AB,
 
always@(*)begin //out
case(state)
start:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b1;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd0;
      DONE=1'b0;
	end
INIT:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b1;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
		 DONE=1'b0;
	end
	
//You should complete this part	
READ_W:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b1;
   	ROM_IM_CS=1'b1;
	ROM_W_CS=1'b1;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b1;
	ROM_W_OE=1'b1;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	DONE=1'b0;
      end

WRITE:begin
      MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b1;
  	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b1;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd2;
		 DONE=1'b0;
	end

READ_C:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b1;
      ROM_IM_CS=1'b1;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b1;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	 DONE=1'b0;
	end
READ_9:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b1;
      ROM_IM_CS=1'b1;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b1;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	 DONE=1'b0;
	end
conv_Done:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b1;
      ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	 DONE=1'b0;
	end
Pooling_INIT:begin
      MUX1_sel=1'b0;
	MUX2_sel=2'd2;
	MUX3_sel=1'b1;
      ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;//
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	 DONE=1'b0;
end
Pooling_READ:
begin
      MUX1_sel=1'b0;
	MUX2_sel=2'd2;
	MUX3_sel=1'b1;
      ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	 DONE=1'b0;
end
Pooling_WRITE:
begin
      MUX1_sel=1'b0;
	MUX2_sel=2'd2;
	MUX3_sel=1'b1;
      ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;//
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd2;
	 DONE=1'b0;
end

Pooling_DONE:
begin
      MUX1_sel=1'b0;
	MUX2_sel=2'd2;
	MUX3_sel=1'b1;
      ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b1;
	Adder_mode=2'd2;
 DONE=1'b0;
end

//Conv2------------------------------------
Conv2_INIT:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
		DONE=1'b0;
	end

Conv2_READW:begin
	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b1;
   	ROM_IM_CS=1'b1;
	ROM_W_CS=1'b1;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b1;
	ROM_W_OE=1'b1;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	DONE=1'b0;
      end
Conv2_READ9:begin
	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b1;
   	ROM_IM_CS=1'b1;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b1;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	DONE=1'b0;
      end
Conv2_READC:begin
	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b1;
   	ROM_IM_CS=1'b1;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b1;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	DONE=1'b0;
end
Conv2_WRITE:
begin
if(conv0_num==3'd0)begin
	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b1;
   	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd0;
	DONE=1'b0;
end
else if(conv0_num==3'd5)begin
    MUX1_sel=1'b1;
	MUX2_sel=2'd0;
	MUX3_sel=1'b0;
   	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b1;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd2;
	DONE=1'b0;
end
else 
begin
	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b0;
   	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd1;
	DONE=1'b0;
end
end
Conv2_DONE:
begin
	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b0;
   	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd1;
	DONE=1'b0;
end
//Pooling3
Pooling3_INIT:begin
    MUX1_sel=1'b0;
	MUX2_sel=2'd2;
	MUX3_sel=1'b1;
    ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;//
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	 DONE=1'b0;
end
Pooling3_READ:
begin
    MUX1_sel=1'b0;
	MUX2_sel=2'd2;
	MUX3_sel=1'b1;
    ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	 DONE=1'b0;
end
Pooling3_WRITE:
begin
    MUX1_sel=1'b0;
	MUX2_sel=2'd2;
	MUX3_sel=1'b1;
    ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;//
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd2;
	DONE=1'b0;
end

Pooling3_DONE:
begin
    MUX1_sel=1'b0;
	MUX2_sel=2'd2;
	MUX3_sel=1'b1;
    ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b1;
	Adder_mode=2'd2;
 DONE=1'b0;
end
//Pooling3_end


//FC4


FC4_INIT:
begin
MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	DONE=1'b0;

end
FC4_READ_9:
begin


	MUX1_sel=1'b1;
	MUX2_sel=2'd0;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b1;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b1;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd0;
	DONE=1'b0;
end


FC4_WRITE:
begin
if(FC4_count==1)
begin
	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b1;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd0;
      DONE=1'b0;


end

else if(FC4_count==60)
begin

	MUX1_sel=1'b1;
	MUX2_sel=2'd0;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b1;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd2;
      DONE=1'b0;


end

else 
begin

	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd1;
      DONE=1'b0;


end
end

FC4_DONE:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	DONE=1'b0;	

end



//FC4____end
//FC5------------------------------


FC5_INIT:
begin
MUX1_sel=1'b0;
	MUX2_sel=2'd1;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
		DONE=1'b0;

end
FC5_READ_9:
begin


	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b1;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b1;
	ROM_B_OE=1'b1;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
		DONE=1'b0;
end


FC5_WRITE:
begin
if(FC5_count==1)
begin
	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b1;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd0;
      DONE=1'b0;

end

else if(FC5_count==20)
begin

	MUX1_sel=1'b1;
	MUX2_sel=2'd0;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b1;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd2;
      DONE=1'b0;


end

else 
begin

	MUX1_sel=1'b1;
	MUX2_sel=2'd1;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b1;
	Adder_mode=2'd1;
      DONE=1'b0;


end
end

FC5_DONE:begin
	MUX1_sel=1'b0;
	MUX2_sel=2'd0;
	MUX3_sel=1'b0;
	ROM_IM_CS=1'b0;
	ROM_W_CS=1'b0;
	ROM_B_CS=1'b0;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b0;
	SRAM_CENB=1'b0;
	SRAM_WENB=1'b0;
	Adder_mode=2'd2;
	DONE=1'b0;	

end
DECODER_INIT:begin
	DONE=1'b0;	
	Decode_en=1'b0;
	MUX2_sel=2'd3;
end
DECODER_READ:begin
if(decoder_num>=1)begin
	DONE=1'b0;	
	Decode_en=1'b1;
	MUX2_sel=2'd3;
	SRAM_CENA=1'b1;
end
else
SRAM_CENA=1'b1;
end
DECODER_WRITE:begin
	DONE=1'b0;
	
	SRAM_CENA=1'b0;
	Decode_en=1'b0;
	MUX2_sel=2'd3;
	SRAM_CENB=1'd1;
	SRAM_WENB=1'd1;
end
FINISH:
DONE=1'b1;	
//FC5-----------------------------
//------------------------------------
default:begin
   
     ROM_IM_CS=1'b1;
	ROM_W_CS=1'b1;
	ROM_B_CS=1'b1;
	ROM_IM_OE=1'b0;
	ROM_W_OE=1'b0;
	ROM_B_OE=1'b0;
	SRAM_CENA=1'b1;
	SRAM_CENB=1'b1;
	SRAM_WENB=1'b0;
	Adder_mode=2'd0;
	end
endcase
end
  
endmodule
