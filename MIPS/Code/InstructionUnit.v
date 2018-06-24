`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  Instruction_Unit.v
 * Project:    Intstructon Unit
 * Designer:   Kassandra Flores, Adan Hernandez
 * Email:      kassandra.flores@student.csulb.edu,
 *					adan.hernandez@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  10/09/2016
 *
 * Purpose: To create an instruction unit in which keeps track of where in 
 * the program we are , fetches instructions from memory and places these
 * fetched instructions in the instruction register.The current value 
 * of the program counter is used to select which address in instruction
 * memory will be read. This read instruction is then loaded onto
 * the instrucrton register. Only bits [11:0] of the PC (program counter)
 * are used to address the instrution memory
 ****************************************************************************/
module Instruction_Unit(clk,reset,PC_in,im_cs,im_wr,im_rd,pc_ld,pc_inc,pc_sel,
								PC_out,ir_ld,IR_out,SE_16);
//////////////////////////////
//				INPUTS			 //
//////////////////////////////
input clk;
input reset;
input im_cs,im_wr,im_rd; // Instruction Memory Controls
input pc_ld;				 // PC reg load control
input pc_inc;				 // PC reg increment control
input [1:0] pc_sel;		 // PC load source select
input [31:0] PC_in;		 // PC Input
input ir_ld;				 // IR register load control
//////////////////////////////
//				OUTPUTS			 //
//////////////////////////////
output [31:0] PC_out;	 // PC output
output [31:0] IR_out;    // IR output
output [31:0] SE_16;		 // IR Sign Extension output
wire [11:0] PC_out_w;    // PC Current Value
assign PC_out_w = PC_out [11:0];//PC Current Value

/////////////////////////////
//			INTERNAL REGS     //
/////////////////////////////
reg [31:0] PC;//Program Counter
reg [31:0] IR;//Instruction Regiser


///////////////////////////////
//		Instruction Mem		  //
///////////////////////////////
wire [31:0] D_Out;

Data_Memory 
	Instruction_Memory
	(
    .clk(clk), 
    .dm_cs(im_cs), 
    .dm_wr(im_wr), 
    .dm_rd(im_rd), 
    .D_Out(D_Out), 
    .Addr(PC_out_w), 
    .D_In(32'h0000_0000)
    );
///////////////////////////////
//			Sign Extension		  //
///////////////////////////////
assign SE_16 = {{16{IR[15]}},IR[15:0]};

assign IR_out = IR;//assign IR_out to contents of IR

//////////////////////////////
//			PC Input Mux		 //
//////////////////////////////
wire [31:0] PC_in_w;//Input into PC register
assign PC_in_w = (pc_sel == 2'b00)?     PC+{SE_16[29:0],2'b00}:
					  (pc_sel == 2'b01)? {PC[31:28],IR[25:0],2'b00}:
				     (pc_sel == 2'b10)?                      PC_in:
										      {PC[31:24],IR[20:0],2'b00};
//////////////////////////////
//			PC Register			 //
//////////////////////////////
always@(posedge clk , posedge reset)
	begin
	if(reset)
		PC<= 32'h0000_0000;
	else if(pc_inc)
			PC<= PC + 3'b100;
	else if(pc_ld)
			PC<= PC_in_w;
	else 
			PC<= PC;
	end
assign PC_out = PC;
//////////////////////////////
//			IR Register			 //
//////////////////////////////
always@(posedge clk, posedge reset)
	begin
	if(reset)
		IR<=32'h0000_0000;
	else if(ir_ld)
		IR<=D_Out;
	else 
		IR<=IR;
	end



endmodule
