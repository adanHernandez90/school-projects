`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  Data_Memory.v
 * Project:    Integer Datapath
 * Designer:   Kassandra Flores
 * Email:      kassandra.flores@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  8/23/2016
 *
 * Purpose: To create a 0 to 4095 byte addressable I/O memory locations. All data 
 * placed into the byte addressable memory locations will be in Big Endian 
 * format. Reading from memory is asynchronous and writing to memory is 
 * synchronous. To perform a read operation , im_rd must be 
 * asserted. To perform a write, im_wr must be asserted. To
 ****************************************************************************/
module Data_Memory(clk,dm_cs,dm_wr,dm_rd,D_Out,Addr,D_In);
////////////////////////////////////
//           Inputs
///////////////////// ///////////////
input clk;
input dm_cs; 					//Chip Select
input dm_wr; 					//Write	  (Synchronous)
input dm_rd; 					//Read    (Asynchronous)
input [11:0] Addr;		   //Memory is organized as 4096x8 byte addressible
									//memory (i.e 1024x32).Big Endian Format
input [31:0] D_In;         //Data in
/////////////////////////////////////

/////////////////////////////////////
//            Outputs
/////////////////////////////////////
output [31:0] D_Out;       //Data out
/////////////////////////////////////

////////////////////////////////////////
// Byte Addressible Memory Locations
////////////////////////////////////////
reg [7:0] Mem [4095:0];

////////////////////////////////////////
//       Reading from Memory
////////////////////////////////////////

assign D_Out  = ({dm_rd & dm_cs&!dm_wr})? 
					{Mem[Addr],Mem[Addr + 3'b001],Mem[Addr+3'b010],Mem[Addr + 3'b011]}
					: 32'bz;
								 
////////////////////////////////////////
//       Writing to Memory
/////////////////////////////////////////
always@(posedge clk)
	begin
	if(dm_cs & dm_wr&!dm_rd)
		begin
		{Mem[Addr],Mem[Addr + 3'b001],Mem[Addr+3'b010],Mem[Addr + 3'b011]} <= D_In;
		end
	else
		begin
		{Mem[Addr],Mem[Addr + 3'b001],Mem[Addr+3'b010],Mem[Addr + 3'b011]} <= 
		{Mem[Addr],Mem[Addr + 3'b001],Mem[Addr+3'b010],Mem[Addr + 3'b011]};
		end
	end
endmodule
