`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  ALU_.32v
 * Project:    Integer Datapath
 * Designer:   Kassandra Flores
 * Email:      kassandra.flores@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  8/23/2016
 *
 * Purpose: To perform arithemtic or logic operations on the inputed operands
 *			   and set the status flags depending on the selected operation.
 *				ALU Operation selection is 5 bits in length and all S and T 
 *				inputs are 32 bits wide.
 ****************************************************************************/
  module ALU_32(S,T,FS,Y_LO,Y_HI,N,Z,V,C,shamt
    );
//////////////////////////////////
// Paramters 
////////////////////////////////// 
	 parameter
	 
	 MUL_OP = 5'H1E, DIV_OP = 5'H1F,BSLR = 5'h1A , BSRR = 5'h1B;
	 
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
	output wire N,Z,V,C;
	output wire [31:0] Y_LO;	
	output wire [31:0] Y_HI;
/////////////////////////////////
// WIRES
/////////////////////////////////
  wire [31:0] MIPS_Prod;
  wire [63:0] MPY_Prod;
  wire [31:0] DIV_Prod;
  wire [31:0] DIV_Rem;
  wire [31:0] BS_Y;
  wire V_m;
  wire C_m;
/////////////////////////////////
// ALU OPs ( EXLUDING DIV & MUL )
/////////////////////////////////
MIPS_32 
  M0(
    .S(S), 
    .T(T), 
    .Y(MIPS_Prod), 
    .FS(FS), 
    .C(C_m), 
    .V(V_m),
	 .shamt(shamt)
    );
////////////////////////////////
// DIV
////////////////////////////////
DIV_32 
 D0(
    .S(S), 
    .T(T), 
    .Product(DIV_Prod), 
    .Remainder(DIV_Rem), 
    .FS(FS)
    );
////////////////////////////////
// MUL
////////////////////////////////
MPY_32 
 MPY0(
    .S(S), 
    .T(T), 
    .Y(MPY_Prod), 
    .FS(FS)
    );
////////////////////////////////
//	Barrell Shift              //
////////////////////////////////
Barrell_Shift 
	Bs0(
    .FS(FS), 
    .T(T), 
    .shamt(shamt), 
    .Y(BS_Y)
    );
////////////////////////////////
// Y_LO and Y_HI MUX
////////////////////////////////

assign Y_LO = (FS == MUL_OP)? MPY_Prod [31:0] :
              (FS == DIV_OP)? DIV_Prod : 
				  (FS == BSLR | FS == BSRR )? BS_Y:
					MIPS_Prod; //default
assign Y_HI = (FS == MUL_OP)? MPY_Prod [63:32]
										: (FS == DIV_OP)? DIV_Rem  : 16'H0000;
/////////////////////////////////
// Carry and Overflow flags
/////////////////////////////////

assign {C,V} =  (FS != MUL_OP || FS != DIV_OP || FS != BSRR || FS != BSLR) ? {C_m,V_m} : 1'b0;

////////////////////////////////
// Negative and Zero flags
////////////////////////////////
assign N = (FS == MUL_OP)? (Y_HI[31])         : (Y_LO[31]);
assign Z = (FS == MUL_OP || FS == DIV_OP)? (~|{Y_HI,Y_LO}) : (~|Y_LO );

endmodule

