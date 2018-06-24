`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  MPY_.32v
 * Project:    Integer Datapath
 * Designer:   Kassandra Flores
 * Email:      kassandra.flores@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  8/23/2016
 *
 * Purpose: To perform ALU Operation: Multiplication. Multiplication of 
 *				operands will be S * T. Product of mulptiplcation will be 
 *				placed into a 32 bit reg type output
 *
 ****************************************************************************/
module MPY_32(S,T,Y,FS
    );
/////////////////////////////////
// INPUTS
/////////////////////////////////
	input [31:0] S;
	input [31:0] T;
	input [4:0] FS; // Function Select
/////////////////////////////////
// OUTPUTS
/////////////////////////////////
	output reg [63:0] Y;
	
	integer int_S, int_T;
	// casted to int so verilog will know they are
	// eithor a negative or positive number.
	always@(*)
		begin
		int_S = S;
		int_T = T;
		Y = int_S * int_T;
		end

endmodule
