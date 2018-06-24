`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:58 11/02/2016 
// Design Name: 
// Module Name:    I_O 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module I_O(sys_clk,intr , // System signals
			  Addr,          // Memory Address
			  D_In,          // Data to be loaded into Memory
			  intr_req,      // Interrupt request from I/O module
			  intr_ack,      // Interrupt Acknowledge
			  IO_wr,         // Write (synchronous)
			  IO_rd,         // Read (asynchronous)
			  IO_D_Out       // Data out
    );
input  sys_clk;           // System Clock
input  intr;              // Interrupt Request 
input  [11:0] Addr;       // Memory is organized as 4096x8 byte addressible
						        // memory (i.e 1024x32).Big Endian Format
input  [31:0] D_In;       // Data in
output reg intr_req;      // Interrupt request from I/O module
input  intr_ack;          // Interrupt Acknowledge 
input  IO_wr,IO_rd;       // I/O read and write control signals
output [31:0] IO_D_Out;   // contents of memory location specified by Addr	
					
////////////////////////////////////////
// Byte Addressible Memory Locations
////////////////////////////////////////
reg [7:0] Mem [4095:0];

assign IO_D_Out = ({IO_rd &!IO_wr})? 
					   {Mem[Addr],Mem[Addr + 3'b001],Mem[Addr+3'b010],Mem[Addr + 3'b011]}
					    : 32'bz;
////////////////////////////////////////
//       Writing to Memory
/////////////////////////////////////////
always@(posedge sys_clk)
	begin
	if(IO_wr&!IO_rd)
		begin
		{Mem[Addr],Mem[Addr + 3'b001],Mem[Addr+3'b010],Mem[Addr + 3'b011]} <= D_In;
		end
	else
		begin
		{Mem[Addr],Mem[Addr + 3'b001],Mem[Addr+3'b010],Mem[Addr + 3'b011]} <= 
		{Mem[Addr],Mem[Addr + 3'b001],Mem[Addr+3'b010],Mem[Addr + 3'b011]};
		end
	end

always@(posedge sys_clk)
	if(intr_ack)
		intr_req<=0;
	else if (intr)
		intr_req<=1;
	
	else
		intr_req<=0;
		
endmodule
