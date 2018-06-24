`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  IntegerDataPath_2.v
 * Project:    Intstructon Unit
 * Designer:   Kassandra Flores, Adan Hernandez
 * Email:      kassandra.flores@student.csulb.edu,
 *					adan.hernandez@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  10/09/2016
 *
 * Purpose: To create a data path between the 32 registers inside the 
 * register file and the ALU. All logic and arithmetic operations can 
 * operate on the contents of each register inside the register file aswell
 * with any 32 bit value present at the DT port.The destination 
 * location of any ALU operation or data present on the DY port can 
 * be selected by the DA_Sel port. 1 Being it is the register 
 * specified by the 5 bit D_Addr port or 0 being the 5 bit value specified
 * by the T_Addr port.
 ****************************************************************************/
module IntegerDataPath_2(clk,reset,D_En,D_Addr,T_Addr,DT,T_Sel,C,V,N,Z,DY,PC_in,
								Y_Sel,D_OUT,S_Addr,FS,HILO_ld,ALU_OUT,DA_Sel,I_O_input,
								D_In_Sel,S_Sel,D_OUT_Sel,Flags,shamt);
	input clk;
	input reset;
	
/////////////////////////////////
// Register File inputs & wires
/////////////////////////////////
	input D_En;//Register File write enable
	input [1:0] DA_Sel;// Destination locaton select
	input [4:0] D_Addr;//Destination Address
	input [4:0] S_Addr;//Selected register Source 1
	input [4:0] T_Addr;//Selected register Source 2
	input [4:0] shamt; //Shift Amount into ALU
	input [3:0] Flags; //Flag input from control unit
	input S_Sel;		 //Selects S_addr source //new
	input[1:0]D_OUT_Sel;   //Data out select
	wire [4:0] D_Addr_w;//Selected destination address
	wire [4:0] S_Addr_w;//Selected register source address
	wire [31:0] S;//contents of register source 1
	wire [31:0] T;//contents of register source 2
	
reg [31:0] RS,RT;

assign D_Addr_w = (DA_Sel == 2'b00)? D_Addr: 
						(DA_Sel == 2'b01)? T_Addr:
						(DA_Sel == 2'b10)? 5'b11111:// return address
												 5'b11101;// stack pointer
						 
						 
//////////////////////////////
// ALU input/outputs & wires
//////////////////////////////
	input [4:0] FS; // Function Select
	output C;//carry
	output V;//overflow
	output N;//negative
	output Z;//zero
	
	wire [31:0] Y_LO;
	wire [31:0] Y_HI;
//////////////////////////////
// Inputs into T_MUX
//////////////////////////////
   input [31:0] DT;
	input T_Sel;
//////////////////////////////
// Input into HI reg
//////////////////////////////
	input HILO_ld;// Load control of HI and LO regs
//////////////////////////////
// Input into Y_MUX
//////////////////////////////
	input [31:0] DY;
	input [31:0] I_O_input; //new
	input [31:0] PC_in;
	input [2:0] Y_Sel;// Output select
/////////////////////////////
// Integer Datapath Outputs
/////////////////////////////
	output [31:0] ALU_OUT;//ALU out
	output [31:0] D_OUT;//Data out
	wire [31:0] ALU_OUT_W;
	
   assign ALU_OUT_W = ALU_OUT;
////////////////////////////
//  HI and LO regs
////////////////////////////
    reg [31:0] HI;
	 reg [31:0] LO;
///////////////////////////////////////////////
//			Register File
///////////////////////////////////////////////
Register_File_32x32 
	RF0
	 (
    .clk(clk), 
    .reset(reset), 
    .S(S), 
    .T(T), 
    .D(ALU_OUT_W), 
    .S_Addr(S_Addr_w), 
    .T_Addr(T_Addr), 
    .D_Addr(D_Addr_w), 
    .D_En(D_En)
    );

/////////////////////////////////////////////////////////
//                T_MUX
/////////////////////////////////////////////////////////
wire [31:0] T_Wire;//output control
//                         1     :    0
assign T_Wire = (T_Sel)?  DT :  T; 
/////////////////////////////////////////////////////////
//					S_Sel (S_Addr mux)							 //
/////////////////////////////////////////////////////////
assign S_Addr_w  = (S_Sel)? 5'b11101 : S_Addr;// stack pointer

/////////////////////////////////////////////////////////
//               D_In MUX                              //
/////////////////////////////////////////////////////////
input D_In_Sel;
wire [31:0] Data_in;//new
assign Data_in = (D_In_Sel)? I_O_input : DY;//new

/////////////////////////////////////////////////////////
// 			ALU
/////////////////////////////////////////////////////////
ALU_32
	A0
	(
    .S(RS), 
    .T(RT),
    .FS(FS), 
    .Y_LO(Y_LO), 
    .Y_HI(Y_HI), 
    .N(N), 
    .Z(Z), 
    .V(V), 
    .C(C),
	 .shamt(shamt)
    );
////////////////////////////////////////////////////////////
//                HILO and LO Reg
////////////////////////////////////////////////////////////
	
	always@(posedge clk , posedge reset)
		begin
		if(reset)
			{HI,LO} <= 64'h0;
		else if(HILO_ld)
			{HI,LO} <= {Y_HI,Y_LO};
		else
			{HI,LO}<={HI,LO};
		end

////////////////////////////////////////////////////////////
// 		ALU_Out ,PC_In, D_In, RS and RT registers
////////////////////////////////////////////////////////////
reg [31:0] ALU_OUT_reg;
reg [31:0] D_In_reg;
reg [31:0] PC_In_reg;


		always@(posedge clk, posedge reset)
			begin
			if(reset)
				begin
				{ALU_OUT_reg,D_In_reg}<= 64'h0;
				{RS,RT}<=64'h0;
				PC_In_reg <= 32'b0;
				end
			else 
				begin
				{ALU_OUT_reg,D_In_reg}<={Y_LO,Data_in};
				{RS,RT}<={S,T_Wire};
				PC_In_reg<=PC_in;
				end
			end
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//               Y MUX
////////////////////////////////////////////////////////////
assign ALU_OUT = (Y_Sel==3'b000)?   		 HI :
					  (Y_Sel==3'b001)?   		 LO :
					  (Y_Sel==3'b010)? ALU_OUT_reg :
					  (Y_Sel==3'b011)?    D_In_reg :
					  (Y_Sel==3'b100)?PC_In_reg : 32'bx;
					  
/////////////////////////////////////////////////////////////
// 				D_OUT assign
/////////////////////////////////////////////////////////////
assign D_OUT = (D_OUT_Sel == 2'b00 )?   T_Wire :
					(D_OUT_Sel == 2'b01 )? PC_In_reg:
					(D_OUT_Sel == 2'b10 )? {28'b0,Flags}:
												  T_Wire;//default
					
				
		
endmodule
