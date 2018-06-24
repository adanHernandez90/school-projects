`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  DIV_.32v
 * Project:    Integer Datapath
 * Designer:   Kassandra Flores
 * Email:      kassandra.flores@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  8/23/2016
 *
 * Purpose: To perform ALU Operation: Divison. Division of operands will be 
 *          S divided by T. Product of division will be outputted into 32 
 *          bit reg typ. Remainder of divison will be outputted into 32 
 *				bit reg type.
 *
 ****************************************************************************/
module DIV_32(S,T,Product,Remainder,FS
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
	output reg [31:0]Product;
	output reg [31:0] Remainder;
	
	integer int_S, int_T;
	// casted to int so verilog will know they are
	// eithor a negative or positive number.
	always@(*)
		begin
		int_S = S;
		int_T = T;
		Product = int_S / int_T;
		Remainder = int_S % int_T;
		end

endmodule
