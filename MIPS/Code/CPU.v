`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  CPU.v
 * Designer:   Kassandra Flores, Adan Hernandez
 * Email:      kassandra.flores@student.csulb.edu,
 *					adan.hernandez@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  11/16/2016
 *
 * Purpose: To implement the Instruction Unit, Integer datapath ,Instruction
 * Data memory and Control unit and create the central processing unit
 * for the baseline mips architecure , now , with enhanced 
 * intructions. This CPU is intended to interact with data and 
 * I/O memory and be able to handle, recieve and acknowledge interrupts.
 ****************************************************************************/
module CPU(
				sys_clk,reset,intr_req,// System Inputs
				ALU_OUT,					  // Output from Integer Datapath
				dm_wr,dm_cs,dm_rd,     // Data Memory controls
				IO_wr, IO_rd,			  // I/O Memory control signals
				D_in_Mem,              // Data out from data memory
            D_in_IO,					  // Data input from I/O memory
				intr_ack,              // Interrupt Acknowledge
				D_OUT             	  // output of contents in IDP
					
				);
input sys_clk, reset, intr_req ; // System Inputs
input [31:0] D_in_Mem;				// Input from Data Memory
input [31:0] D_in_IO;				// Input from I/O Memory
output dm_cs;							// Data memory chip select
output dm_rd;							// Data memory read control
output dm_wr;							// Data memory write control
output intr_ack;						// Interrup Acknowledge
output IO_wr;                    // I/O Memory write control
output IO_rd;                    // I/O Memory read control
output [31:0] D_OUT;     	      // output of contents in IDP
			
			///////////////
// Connections between control unit and integer datapath//
//////////////////////////////////////////////////////////
wire [1:0] pc_sel;	// PC load source select 
wire pc_ld;       	// PC load control
wire ir_ld;				// IR load control
wire pc_inc;      	// PC increment by 4 control
wire [31:0] IR_out;	// IR contents
wire [31:0] PC_out;	// PC Contents
wire [31:0] SE_16;   // Sign Extension of bits IR[15:0]

//////////////////////////////////////////////////////////
// Connections between control unit and instruction unit//
//////////////////////////////////////////////////////////
wire im_cs;//chip select
wire im_rd;//read control
wire im_wr;//write control
/////////////////////////////////////////////////////////
// Integer Data path outputs
/////////////////////////////////////////////////////////
output [31:0] ALU_OUT;// Output from Arithmetic Unit in integer 

//////////////////////////////////////////////////////////
// Connections between control unit and integer data pah//
//////////////////////////////////////////////////////////
wire D_En;               // Register write enable 
wire [1:0] DA_Sel;       // Destination Address select
wire T_Sel;              // RT register source select
wire HILO_ld;            // HI and LO load control
wire [2:0] Y_Sel;        // Integer Datapath output select
wire [4:0] FS;           // Function Select
wire D_In_Sel;           // Input select from eithor IO memory or Data Memory
wire S_Sel;			       // Source Address select coming from control unit
wire [1:0]D_OUT_Sel;     // D_OUT select from Integer Datapath
wire ps_c,ps_n,ps_v,ps_z;// Present state flag values
wire [3:0] Flags;        // Flag wire
wire C,V,N,Z;         	 // Status Flags
wire ld_Flags;
assign Flags = (ld_Flags)? D_in_Mem[3:0] : {N,Z,C,V};// if loading flags
																	  // from memory or IDP
// Instantiate the module
Instruction_Unit 
	IU_uut (
		 .clk(sys_clk), //cc
		 .reset(reset), //cc
		 .PC_in(ALU_OUT), //cc
		 .im_cs(im_cs),// cc 
		 .im_wr(im_wr), //cc
		 .im_rd(im_rd), //cc
		 .pc_ld(pc_ld), //cc
		 .pc_inc(pc_inc), //cc
		 .pc_sel(pc_sel), //cc
		 .PC_out(PC_out), //cc
		 .ir_ld(ir_ld), //cc
		 .IR_out(IR_out), //cc
		 .SE_16(SE_16)//cc
		 );
	 
IntegerDataPath_2 
	 IDP_uut(
		 .clk(sys_clk), //cc
		 .reset(reset), //cc
		 .D_En(D_En), //cc
		 .D_Addr(IR_out[15:11]), //cc
		 .T_Addr(IR_out[20:16]), //cc
		 .DT(SE_16), //cc
		 .T_Sel(T_Sel), //cc
		 .C(C), //cc
		 .V(V), //cc
		 .N(N), //cc
		 .Z(Z), //cc
		 .DY(D_in_Mem), // input from outside data memory
		 .PC_in(PC_out), //cc
		 .Y_Sel(Y_Sel), //cc
		 .D_OUT(D_OUT), //cc
		 .S_Addr(IR_out[25:21]), //cc
		 .FS(FS), //cc
		 .HILO_ld(HILO_ld), //cc
		 .ALU_OUT(ALU_OUT), //cc
		 .DA_Sel(DA_Sel), //cc
		 .I_O_input(D_in_IO), //cc
		 .D_In_Sel(D_In_Sel), //cc
		 .S_Sel(S_Sel), //cc
		 .D_OUT_Sel(D_OUT_Sel), //cc
		 .Flags({ps_n,ps_z,ps_c,ps_v}), //cc
		 .shamt(IR_out[10:6])//cc
		 );
	 
MCU 
	CU (
		 .sys_clk(sys_clk), //cc
		 .reset(reset), //cc
		 .intr(intr_req),//cc 
		 .C(Flags[1]),
		 .N(Flags[3]),
		 .Z(Flags[2]),
		 .V(Flags[0]),
		 .IR(IR_out), //cc
		 .int_ack(intr_ack), //c
		 .pc_sel(pc_sel),//cc 
		 .pc_ld(pc_ld), //cc
		 .pc_inc(pc_inc), //cc
		 .ir_ld(ir_ld), //cc
		 .im_cs(im_cs), //cc
		 .im_rd(im_rd), //cc
		 .im_wr(im_wr), //cc
		 .D_En(D_En), //cc
		 .DA_Sel(DA_Sel), //cc
		 .T_Sel(T_Sel), //cc
		 .HILO_ld(HILO_ld), //cc
		 .Y_Sel(Y_Sel), //cc
		 .dm_cs(dm_cs), //cc
		 .dm_rd(dm_rd), //cc
		 .dm_wr(dm_wr), //cc
		 .D_In_Sel(D_In_Sel), //cc
		 .IO_wr(IO_wr), //cc
		 .IO_rd(IO_rd), //cc
		 .FS(FS), //cc
		 .S_Sel(S_Sel),//cc 
		 .D_OUT_Sel(D_OUT_Sel), //cc
		 .ps_c(ps_c), //cc
		 .ps_n(ps_n), //cc
		 .ps_z(ps_z), //cc
		 .ps_v(ps_v), //cc
		 .ld_Flags(ld_Flags)//cc
		 );



	 
endmodule
