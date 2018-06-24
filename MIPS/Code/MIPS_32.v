`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  MIPS_.32v
 * Project:    Integer Datapath
 * Designer:   Kassandra Flores
 * Email:      kassandra.flores@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  8/23/2016
 *
 * Purpose:  ALU Operations that will perform all arithmaic and logic
 *				 operations except Divison and Multiplication and set the 
 *           appropriate carry and overfow.
 *
 ****************************************************************************/
module MIPS_32(S,T,Y,FS,C,V,shamt);
/////////////////////////////////
// INPUTS
/////////////////////////////////
	input [31:0] S;
	input [31:0] T;
	input [4:0] shamt;
	input [4:0] FS; // Function Select
/////////////////////////////////
// OUTPUTS
/////////////////////////////////
	output reg [31:0] Y;
	output reg C;
	output reg V;
/////////////////////////////////
// ALU Operations
//////////////////////////////////
	parameter 
		PASS_S  = 5'H00,   PASS_T  = 5'H01,  ADD     = 5'H02, 
		ADDU    = 5'H03,   SUB     = 5'H04,  SUBU    = 5'H05, 
		SLT     = 5'H06,   SLTU    = 5'H07,  AND     = 5'H08, 
		OR      = 5'H09,   XOR     = 5'H0A,  NOR     = 5'H0B, 
		SLL     = 5'H0C,   SRL     = 5'H0D,  SRA     = 5'H0E, 
		INC     = 5'H0F,   DEC     = 5'H10,  INC4    = 5'H11, 
		DEC4    = 5'H12,   ZEROS   = 5'H13,  ONES    = 5'H14, 
		SP_INIT = 5'H15,   ANDI    = 5'H16,  ORI     = 5'H17, 
		XORI    = 5'H18,   LUI = 5'H19, 
		
		UNUSED = 1'bX, SET = 1'b1, OFF = 1'b0;
///////////////////////////////////
// Function Select Decoder
///////////////////////////////////	
integer int_T;

	always@(*)//Decoder of inputs
	begin
			C = 0;// carry
			V = 0;// overflow
		   Y = 32'H0; // Function Ouput
			case(FS)
		
			PASS_S: Y = S;
				
			PASS_T: Y = T;			
					
			ADDU:// Addition Unsigned
					begin
					{C,Y} = S + T;
					V = C;
					end
			ADD: // Addition Signed
					begin
					{C,Y} = S + T;
					V = (S[31] == T[31])? (T[31]!=Y[31]) : 1'b0;			
					end
			SUB:// Subtraction Signed
					begin
					{C,Y} = S - T;
					V = (S[31] ^ T[31])? (T[31] == Y[31]) : 1'b0;
					end
			SUBU:// Subtraction Unsigned 
					begin
					{C,Y} = S - T;
					V = C;
					end
					
//////////////////////////////////////////
// SLT(Signed): If S is less T , Y = 1
//      	Else, Y = 0
//////////////////////////////////////////
			SLT:	Y = (S[31] == T[31])? (S<T) : (S[31] & ~T[31]);
//////////////////////////////////////////
// SLT(Unsigned): If S is less T , Y = 1
//      	Else, Y = 0
//////////////////////////////////////////
			SLTU: Y = (S<T)? 1'b1: 1'b0;
//////////////////////////////////////////
// AND 
//////////////////////////////////////////			
			AND:  Y = S & T;
//////////////////////////////////////////
// OR
//////////////////////////////////////////
			OR:	Y = S | T ;
//////////////////////////////////////////
// XOR
//////////////////////////////////////////				
			XOR:	Y = S^T;
//////////////////////////////////////////
// NOR
//////////////////////////////////////////			
			NOR:	Y = ~(S|T);
//////////////////////////////////////////
// SLL : Shift Left
//////////////////////////////////////////					
			SLL:	{C,Y} = T << shamt;
//////////////////////////////////////////
// SRL : Shift Right
//////////////////////////////////////////
			SRL:
			begin
			C= T[0];
			Y = T >> shamt;
			end
//////////////////////////////////////////
// SRA : Shift Right Arithmetic 
//////////////////////////////////////////	
			
			SRA:	
			begin
			int_T = T;
			{C,Y}= int_T >>> shamt; // performs sign extension
			end
///////////////////////////////////////////
// INC : Increment S by 1'b1 (value one)
///////////////////////////////////////////			
    		INC:
		   begin
			{C,Y} = S + 1'b1;
			V = (!S[31]&Y[31]);
			end

///////////////////////////////////////////
// DEC: Decrament S by 1'b1 (value one)
///////////////////////////////////////////					
			DEC:
					begin
					{C,Y} = S - 1'b1;
					V =(S[31]&!Y[31]);
					end
///////////////////////////////////////////
// INC4:  Increment S by 3'b100 (value 4)
///////////////////////////////////////////	
			INC4:
					begin
					{C,Y} = S + 3'b100;
					V = (!S[31]&Y[31]);
					end
///////////////////////////////////////////
// DEC4:  Decrement S by 3'b100 (value 4)
///////////////////////////////////////////	
			DEC4:
					begin
					{C,Y} = S - 3'b100;
					V = (S[31]&!Y[31]);
					end
					
			ZEROS:   Y= 32'H000000000;
			
			ONES:  	Y= 32'HFFFFFFFF;
				
			SP_INIT:	Y = 32'h3FC;
			
			ANDI:    Y = S & {16'h0, T[15:0]};
			
			ORI:	   Y = S | {16'h0, T[15:0]};
			
			XORI:	   Y = S ^ {16'h0, T[15:0]};
				
			LUI:	   Y = {T[15:0], 16'h0};
				
				
			
		 endcase
		end
endmodule
