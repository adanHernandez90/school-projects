`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  Register_File32x32.v
 * Project:    32 32-bit Register File
 * Designer:   Kassandra Flores
 * Email:      kassandra.flores@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  9/23/2016
 *
 * Purpose: To create 32 32-bit registers with D being the data available 
 * to be written into the registers and D_Addr, being the register selected 
 * to write to. Only when D_En is high and D_Add is not register 0, will the 
 * contents at port D be written to the selected internal registers. S and 
 * T are outputs that are able to dsplay current values held by internal 
 * registers. S_Addr controls which register will appear on the S port and 
 * T_Addr will control which register appears on the T port.
 ****************************************************************************/
module Register_File_32x32(clk,reset,S,T,D,S_Addr,T_Addr,D_Addr,D_En);


	input clk;
	input reset;
	
/////////////////////////////////
// Data values present at input
//////////////////////////////////
	input [31:0] D;
//////////////////////////////////
/// Data Enable
///////////////////////////////////
	input D_En;
///////////////////////////////////
// Register Selects
///////////////////////////////////	
	input [4:0] D_Addr;
	input [4:0] S_Addr;
	input [4:0] T_Addr;
//////////////////////////////////
// Ports available to display
// contents held in register file
//////////////////////////////////	
	output  [31:0] S;
	output  [31:0] T;
//////////////////////////////////
// Internal data registers
//////////////////////////////////	
	reg [31:0] Data [31:0] ;
	
	always@(posedge clk , posedge reset)
		begin
			if(reset)
				Data[0] <= 32'h0;// Only r0 is effected by reset
				
			if(D_En && (D_Addr != 5'b000_00))// Register 0 is not allowed to be written to
				Data[D_Addr] <= D;//If r0 is  not selected and D_En is high
									  //then Data at port D is placed into register
									  
			end	
			
	assign S = Data[S_Addr];// Selects which register will be displayed by S
									// by using S_Addr to specify which register
	assign T = Data[T_Addr];//Selects which register will be displayed by T
									// by using T_Addr to specify which register
	

endmodule
