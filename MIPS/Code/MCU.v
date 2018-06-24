`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  MCU.v
 * Designer:   Kassandra Flores, Adan Hernandez
 * Email:      kassandra.flores@student.csulb.edu,
 *					adan.hernandez@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  10/11/2016
 *
 * Purpose: A state machine implementing the MIPS Control Unit (MCU) for the 
 * major cycles of fetch, decode, execute. All control signals for the Integer 
 * datapath and instruction unit will be outputted from the control unit.
 * Inputs into the control unit are the Instruction Register , the 
 * status flags and an interrupt. At reset the stack pointer will be set to
 * 32 bit value of 32'h3FC.
 ****************************************************************************/
module MCU(sys_clk,reset,intr, // system inputs
           C,N,Z,V,				 // ALU statis inputs
       	  IR,						 // Instruction Register input
			  int_ack,            // Ouput to I/O subsystem
			  pc_sel,			    // Selects input value into Program Counter Reg
			  pc_ld,					 // Load Control into PC register
			  pc_inc,				 // Increment PC register contents by 4
			  ir_ld,					 // Load control into Instrution Register (IR)
			  im_cs,					 // Instruction Memory Chip Select
			  im_rd, 				 // Instruction Memory read control
			  im_wr,					 // Instruction Memory write control
			  D_En,					 // Register File Data Write Enable
			  DA_Sel,				 // Register File Destination Address Select
			  T_Sel,					 // RT register Content Select
			  HILO_ld,				 // HI and LO register load control
			  Y_Sel,					 // Integer Datapath Output Select
			  dm_cs,					 // Data Memory Chip select
			  dm_rd,					 // Data Memory Read select
			  dm_wr,					 // Data Memory Write select
			  D_In_Sel,           // Data In select
			  IO_wr,				    // Input Ouput Module write control
			  IO_rd,					 // Input Output Module read control
			  FS,						 // Function Select
			  S_Sel,					 // S_Addr Register File Select
			  D_OUT_Sel,          // D_OUT from Integer Datapath Select
			  ps_c,					 // Present state carry flag
			  ps_n,               // Present state negative flag
			  ps_z,               // Present state zero flag
			  ps_v,               // present state overflow flag
			  ld_Flags            // Load Flag control
			);
input sys_clk,reset,intr;   // System clock , reset, and interrupt request
input C,N,Z,V;					 // Integer ALU status flags
input [31:0] IR ;				 // Instruction Register Input from IU
output reg ld_Flags; 			 // Flag Values from return from interrupt
output reg pc_ld,pc_inc;		 // Program Counter Load Control, Inc by 4 control
output reg [1:0] pc_sel;	    // PC input select 
output reg ir_ld;					 // IR register load control
output reg im_cs,im_rd,im_wr;	 // Instruction Mem read,chip select,write control
output reg D_En;					 // RF data write enable
output reg [1:0] DA_Sel;		 // RF Destination address select
output reg T_Sel;					 // RT register content select
output reg HILO_ld;				 // HI and LO reg control
output reg [2:0] Y_Sel;			 // Integer Datapath output select
output reg dm_cs,dm_wr,dm_rd;	 // Data Mem chip select, write , read control
output reg int_ack;			    // Interrupt Acknowledge
output reg D_In_Sel;           // Data In select
output reg [4:0] FS;				 // Function Select
output reg IO_wr,IO_rd;			 // Input output Mem module read and write control
output reg S_Sel;					 // S_Addr Register File Select
output reg [1:0] D_OUT_Sel;			 // D_OUT form Integer datapath select
integer i ; 						 // for loop control variable in task

//////////////////////////////
//		PARAMETERS				 //
//////////////////////////////
parameter 
RESET  = 00 , FETCH  = 01 , DECODE = 02,
ADD    = 10 , ADDU   = 11 , AND    = 12, OR    = 13, NOR   = 14, SRA = 15,
SLL    = 16 , SLT    = 17 , MULT   = 18, DIV   = 19, XOR   = 9, SLTU = 8,
SUB    = 7  , SUBU   =  6 ,
ORI    = 20 , LUI    = 21 , LW_CALC    = 22, SW    = 23, SRL = 24, ADDI = 25,
SLTI   = 26 ,SLTIU = 27,  XORI = 28, ANDI = 29, 
WB_alu = 30 , WB_imm = 31 , WB_Din = 32, WB_hi = 33, WB_lo = 34, WB_mem = 35,
WB_LW  = 36 , LW = 37 , MFLO = 38 , MFHI = 39 , 
INTR_1 = 501, INTR_2 = 502 , INTR_3 = 503, INTR_4 = 504, INTR_5 = 505,
INTR_6 = 506, INTR_7 = 507,
BEQ = 40, BEQ_WR = 41, BNE = 42, 
BNE_WR = 43, BLEZ = 45, BGTZ = 46, BLEZ_WR =47 , BGTZ_WR = 48,
JUMP   = 50,  JR_CALC = 51, JR = 52 , JAL = 53, JC = 54,
JN   = 55, JZ = 56, JV = 57,
BREAK  = 510, ILLEGAL_OP = 511,
INPUT  = 60, OUTPUT = 61,SETIE = 62,WB_INPUT = 63, WB_OUTPUT = 64, 
INPUT_CALC = 65, RETI = 66, RETI_2 = 67, RETI_3 = 68, RETI_4 = 69,
RETI_5 = 70, RETI_6 = 71, RETI_7 = 72, RETI_8 = 73,

R_Type   = 6'h000_000,

E_KEY    = 6'b01_1111,
BGEZ = 80, BLTZ = 81, NO_OP = 82,  BSLR = 85, BSRR = 86,
BGEZ_WR = 87, BLTZ_WR = 88;


////////////////////////////////
//			STATE REGISTERS		//
////////////////////////////////

reg [8:0] state;// 512 possible states

////////////////////////////////
//				Flag Regsiter  	//
////////////////////////////////
output reg ps_n,ps_z,ps_c,ps_v; // Present state flags
reg ns_n,ns_z,ns_c,ns_v;        // Next state flags

always@(posedge sys_clk , posedge reset)
	begin
	if(reset)
	{ps_n,ps_z,ps_c,ps_v} <= 4'b0000;
	else
	{ps_n,ps_z,ps_c,ps_v} <= {ns_n,ns_z,ns_c,ns_v};	
	end
////////////////////////////////
// 	Interrupt Flag Register //
////////////////////////////////
reg ps_intr;
reg ns_intr;

always@(posedge sys_clk , posedge reset)
	begin
	if(reset)
	ps_intr <= 1'b0;
	else
	ps_intr <= ns_intr;
	end
/////////////////////////////////////////////////
//			    MIPS CONTROL UNIT					  //
//			MOORE FINITE STATE MACHINE				  //
/////////////////////////////////////////////////

always@(posedge sys_clk, posedge reset)
	
	if(reset)
	begin 
  @(negedge sys_clk)
   begin
	// RTL: PC <-- 32'h0,  ALU_Out <-- 32'h3FC,  int_ack <-- 0
	{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
	{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0; 
	{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h15;     
	{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
	S_Sel = 1'b0; D_OUT_Sel = 2'b00;
	ld_Flags = 1'b0;
	#1 {ns_n,ns_z,ns_c,ns_v} <= 4'b0000;
	ns_intr <= 1'b0;
	state = RESET;
end
	end
		 
  else
  case (state)
			///////////////////////////////////////////////////////////////////////
			//					RESET STATE															//
			///////////////////////////////////////////////////////////////////////
			FETCH: 
			if( int_ack == 1'b0 & intr == 1'b1 & ps_intr == 1'b1)
			 begin // ** Interrupt Recieved; Head to ISR ***
			@(negedge sys_clk)
			 begin// control word for deasserting everything
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = INTR_1;
			end
				
							
			 end// end if 
		    else
			 begin
			 if( (int_ack == 1'b1 & intr == 1'b1) | intr == 1'b0 | ps_intr == 1'b0) 
			 begin
			 int_ack = 1'b0;
			 // RTL: IR<-- IM[PC]; PC+4
			 @(negedge sys_clk)
			 begin
			 {pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_1_1; {IO_wr,IO_rd} = 2'b0_0;
			 {im_cs, im_rd, im_wr} = 3'b1_1_0; D_In_Sel = 1'b0;
			 {D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			 {dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			 S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			 ld_Flags = 1'b0;
			 #1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			 ns_intr <= ns_intr;
			 state = DECODE;
			 end
			 end//end if 	
			 end
			////////////////////////////////////////////////////////////////////////
			//					RESET STATE														    //
			////////////////////////////////////////////////////////////////////////
			RESET: 
			// RTL:  $sp <-- ALU_OUT(32'h3FC)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_11_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= 4'b0000;
			ns_intr <= 1'b0;
			state = FETCH;
			end
			end
	
			///////////////////////////////////////////////////////////////////////
			//							DECODE STATE												//
			///////////////////////////////////////////////////////////////////////
			DECODE: 
			begin
			@(negedge sys_clk)
			begin 
			//if(OPCODE == R-Type Instr)
			if(IR[31:26] ==  R_Type)
			begin// It is an R-Type Instruction
			// RTL: RS <-- $rs , RT <-- $rt
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			case (IR[5:0])//case (funct)
			6'h0D : state = BREAK;
			6'h20 : state = ADD;
			6'h21 : state = ADDU;
			6'h22 : state = SUB;
			6'h23 : state = SUBU;
			6'h02 : state = SRL;
			6'h03 : state = SRA;
			6'h2A : state = SLT;
			6'h00 : state = SLL;
			6'h10 : state = MFHI;
			6'h12 : state = MFLO;
			6'h18 : state = MULT;
			6'h1a : state = DIV;
			6'h25 : state = OR;
			6'h24 : state = AND;
			6'h26 : state = XOR;
			6'h27 : state = NOR;
			6'h2b : state = SLTU;
			6'h08 : state = JR_CALC;
			6'h1F : state = SETIE;
			default: state =  ILLEGAL_OP;
			endcase
			end// end for if(OPCODE == R-Type)
			
			else if(IR[31:26] == E_KEY)
			begin// its an enhanced type
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
		
			case (IR[25:21])
			5'h00: state = BLTZ;  //done(?)
			5'h01: state = BGEZ;  //done(?)
			5'h03: state = NO_OP; //done{?}
			5'h04: state = BSLR;	 //done barrell shft left (with rotate)
			5'h06: state = BSRR;  //done barrell shift right (with rotate)
			5'h09: state = JC;//new
			5'h0A: state = JZ;//new
			5'h0B: state = JN;//new
			5'h0C: state = JV;//new
			endcase
			end
			
			else // Its a I\J-Type Instruction
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_1_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			case (IR[31:26])//case (funct)
			6'h0D : state = ORI;
			6'h0F : state = LUI;
			6'h08 : state = ADDI;
			6'h0A : state = SLTI;
			6'h23 : state = LW_CALC;
			6'h2B : state = SW;
			6'h02 : state = JUMP;
			6'h03 : state = JAL;
			6'h04 : begin state = BEQ; T_Sel = 0; end
			6'h05 : begin state = BNE; T_Sel = 0; end
			6'h06 : state = BLEZ;
			6'h07 : state = BGTZ;
			6'h0B : state = SLTIU;
			6'h0C : state = ANDI;
			6'h0E : state = XORI;
			6'h1C : state = INPUT_CALC;
			6'h1D : state = OUTPUT;
			6'h1E : state = RETI;
			default: state =  ILLEGAL_OP;
			endcase
			end//end for else for I and J Type Instructions
			end//end for @(negedge sys_clk)
			end//end for DECODE state
			////////////////////////////////////////////////////////////////////////
			//		JC                  		   				Jump Carry					 //
			////////////////////////////////////////////////////////////////////////
			JC:
			// RTL: PC <-- {PC+4[31:28],Address,7'b0000000}
			begin
			@(negedge sys_clk)
			if(ps_c)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b11_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			else
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			end// end for JC state
			////////////////////////////////////////////////////////////////////////
			//		JZ                  		   				Jump Zero 					 //
			////////////////////////////////////////////////////////////////////////
			JZ:
			// RTL: PC <-- {PC+4[31:28],Address,7'b0000000}
			begin
			@(negedge sys_clk)
			if(ps_z)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b11_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			else
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			end// end for JZ state
			////////////////////////////////////////////////////////////////////////
			//		JN                  		   				Jump Negative				 //
			////////////////////////////////////////////////////////////////////////
			JN:
			// RTL: PC <-- {PC+4[31:28],Address,7'b0000000}
			begin
			@(negedge sys_clk)
			if(ps_n)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b11_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			else
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			end// end for JN state
			////////////////////////////////////////////////////////////////////////
			//		JV                  		   				Jump Overflow	   		 //
			////////////////////////////////////////////////////////////////////////
			JV:
			// RTL: PC <-- {PC+4[31:28],Address,7'b0000000}
			begin
			@(negedge sys_clk)
			if(ps_v)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b11_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			else
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			end// end for JV state
			////////////////////////////////////////////////////////////////////////
			//		BGEZ		   part 1/2	  Branch if greater than or equal to zero	 //
			////////////////////////////////////////////////////////////////////////
			BGEZ : 
			// RTL: ALU_OUT <-- $rt 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h01;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};// new
			ns_intr <= ps_intr;
			state = BGEZ_WR;
			end
			end// end for BGEZ state
			////////////////////////////////////////////////////////////////////////
			//								BGEZ     part 2/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BGEZ_WR:  
			// RTL: if(rs => 0) PCP4 + Sign_Extention_IR[15:0] << 2
			//		  else 
			//				 PC <- PC + 4
			begin
				@(negedge sys_clk)
				begin
				if(ps_n == 1'b0 | ps_z == 1)
				begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ns_intr;
				state = FETCH;
				end
				else
				begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ns_intr;
				state = FETCH;
				end
				end
			 end// end for BGEZ_WR state
			////////////////////////////////////////////////////////////////////////
			//		BLTZ		   part 1/2	           	Branch if less than zero		 //
			////////////////////////////////////////////////////////////////////////
			BLTZ : 
			// RTL: ALU_OUT <-- $rt 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h01;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};// new
			ns_intr <= ps_intr;
			state = BLTZ_WR;
			end
			end// end for BLTZ state
			////////////////////////////////////////////////////////////////////////
			//								BLTZ     part 2/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BLTZ_WR:  
			// RTL: if(rs < 0) PCP4 + Sign_Extention_IR[15:0] << 2
			//		  else 
			//				 PC <- PC + 4
			begin
				@(negedge sys_clk)
				begin
				if(ps_n == 1'b1)
				begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ns_intr;
				state = FETCH;
				end
				else
				begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ns_intr;
				state = FETCH;
				end
				end
			 end// end for BLTZ_WR state
			////////////////////////////////////////////////////////////////////////
			//		NO_OP		   						   No Operation                   //
			////////////////////////////////////////////////////////////////////////
			NO_OP : 
			// Occupies 3 clock ticks
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};// new
			ns_intr <= ps_intr;
			state = WB_alu;
			end
			end// end for BSL state
			////////////////////////////////////////////////////////////////////////
			//		BSLR		   						   Barrell Shift Left (w/rotate)	 //
			////////////////////////////////////////////////////////////////////////
			BSLR : 
			// RTL: ALU_OUT <-- $rt<<shamt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h1A;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};// new
			ns_intr <= ps_intr;
			state = WB_alu;
			end
			end// end for BSL state
			////////////////////////////////////////////////////////////////////////
			//		BSR		   									Barrell Shift Right		 //
			////////////////////////////////////////////////////////////////////////
			BSRR : 
			// RTL: ALU_OUT <-- $rt>>shamt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h1B;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};// new
			ns_intr <= ps_intr;
			state = WB_alu;
			end
			end// end for BSL state
			////////////////////////////////////////////////////////////////////////
			//								ADD		   											 //
			////////////////////////////////////////////////////////////////////////
			ADD : 
			// RTL: ALU_OUT <-- $rs + $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h02;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};// new
			ns_intr <= ps_intr;
			state = WB_alu;
			end
			end// end for ADD state
			////////////////////////////////////////////////////////////////////////
			//								ADDU		   											 //
			////////////////////////////////////////////////////////////////////////
			ADDU : 
			// RTL: ALU_OUT <-- $rs + $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h03;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};// new
			ns_intr <= ps_intr;
			state = WB_alu;
			end
			end// end for ADDU state
			////////////////////////////////////////////////////////////////////////
			//								SUB		   											 //
			////////////////////////////////////////////////////////////////////////
			SUB : 
			// RTL: ALU_OUT <-- $rs - $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h04;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};// new
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for SUB state
			////////////////////////////////////////////////////////////////////////
			//								SUBU		   											 //
			////////////////////////////////////////////////////////////////////////
			SUBU : 
			// RTL: ALU_OUT <-- $rs - $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h05;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};// new
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for SUBU state
			////////////////////////////////////////////////////////////////////////
			//								SRL		   											 //
			////////////////////////////////////////////////////////////////////////
			SRL : 
			// RTL: ALU_OUT <-- $rt >> 1
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h0D;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for SRL
			////////////////////////////////////////////////////////////////////////
			//								SRA		   											 //
			////////////////////////////////////////////////////////////////////////
			SRA : 
			// RTL: ALU_OUT <-- $rt >> 1 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h0E;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for SRA
			////////////////////////////////////////////////////////////////////////
			//								SLL		   											 //
			////////////////////////////////////////////////////////////////////////
			SLL : 
			// RTL: ALU_OUT <-- $rt << 1 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h0C;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for SLL
			////////////////////////////////////////////////////////////////////////
			//								SLT		   											 //
			////////////////////////////////////////////////////////////////////////
			SLT : 
			//										true     false
			// RTL: ALU_OUT <-- ($rs<$rt)? 1    :   0
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h06;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for SLT
			////////////////////////////////////////////////////////////////////////
			//								MULT		   											 //
			////////////////////////////////////////////////////////////////////////
			MULT : 
			// RTL: {Y_LO,Y_HI} <-- $rs * $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0; 
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_1_000;    FS = 5'h1E;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for MULT state
			////////////////////////////////////////////////////////////////////////
			//								DIV 		   											 //
			////////////////////////////////////////////////////////////////////////
			DIV : 
			// RTL: {Y_LO,Y_HI} <-- $rs / $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_1_000;    FS = 5'h1F;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for DIV state
			////////////////////////////////////////////////////////////////////////
			//								OR 		   											 //
			////////////////////////////////////////////////////////////////////////
			OR : 
			// RTL: ALU_OUT <-- $rs | $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h09;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {N,Z,C,V};
			ns_intr = ns_intr;
			state = WB_alu;
			end
			end// end for OR state			
			////////////////////////////////////////////////////////////////////////
			//								NOR 		   											 //
			////////////////////////////////////////////////////////////////////////
			NOR : 
			// RTL: ALU_OUT <-- ~($rs | $rt)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h0B;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {N,Z,C,V};
			ns_intr = ns_intr;
			state = WB_alu;
			end
			end// end for NOR state
			////////////////////////////////////////////////////////////////////////
			//								XOR		   											 //
			////////////////////////////////////////////////////////////////////////
			XOR : 
			// RTL: ALU_OUT <-- $rs ^ $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h0A;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for XOR state
			////////////////////////////////////////////////////////////////////////
			//							SLTU  (unsigned values) 	   						 //
			////////////////////////////////////////////////////////////////////////
			SLTU : 
			//										true     false
			// RTL: ALU_OUT <-- ($rs<$rt)? 1    :   0            
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h07;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
		   ld_Flags = 1'b0;	
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for SLTU state
			////////////////////////////////////////////////////////////////////////
			//								AND		   											 //
			////////////////////////////////////////////////////////////////////////
			AND : 
			// RTL: ALU_OUT <-- $rs & $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h08;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_alu;
			end
			end// end for AND state
			////////////////////////////////////////////////////////////////////////
			//								ORI		   											 //
			////////////////////////////////////////////////////////////////////////
			ORI : 
			// RTL: ALU_OUT <-- $rs | $rt(se_16)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h17;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_imm;
			end
			end// end for ORI state
			////////////////////////////////////////////////////////////////////////
			//								XORI		   											 //
			////////////////////////////////////////////////////////////////////////
			XORI : 
			// RTL: ALU_OUT <-- $rs ^ $rt(se_16)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h18;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_imm;
			end
			end// end for XORI state
			////////////////////////////////////////////////////////////////////////
			//								ANDI		   											 //
			////////////////////////////////////////////////////////////////////////
			ANDI : 
			// RTL: ALU_OUT <-- $rs ^ $rt(se_16)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h16;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_imm;
			end
			end// end for ANDI state
			////////////////////////////////////////////////////////////////////////
			//								SLTIU		 (unsigned)   						   	 //
			////////////////////////////////////////////////////////////////////////
			SLTIU : 
			//										             true     false
			// RTL: ALU_OUT <-- if ( $rs<$rt(se_16) )?  1    :   0     			
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h07;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_imm;
			end
			end// end for SLTIU state
			////////////////////////////////////////////////////////////////////////
			//								LUI		   											 //
			////////////////////////////////////////////////////////////////////////
			LUI :
			// RTL: ALU_OUT <-- { RT [15:0] , 16'h0}
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h19;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_imm;
			end
			end// end for LUI state
			////////////////////////////////////////////////////////////////////////
			//								ADDI		   											 //
			////////////////////////////////////////////////////////////////////////
			ADDI : 
			// RTL: ALU_OUT <-- $rs + $rt(se_16)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h02;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_imm;
			end
			end// end for ADDI state
			////////////////////////////////////////////////////////////////////////
			//								SLTI		   											 //
			////////////////////////////////////////////////////////////////////////
			SLTI : 
			// RTL: ALU_OUT <-- $rs + $rt(se_16)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h06;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
			ns_intr <= ns_intr;
			state = WB_imm;
			end
			end// end for SLTI state
			////////////////////////////////////////////////////////////////////////
			//								SW 		   											 //
			////////////////////////////////////////////////////////////////////////
			SW :
			// RTL: ALU_OUT <-- $rs + $rt(se_16) 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h02;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = WB_mem;
			end
			end// end for SW state
			////////////////////////////////////////////////////////////////////////
			//								OUTPUT             								    //
			////////////////////////////////////////////////////////////////////////
			OUTPUT : 
			// RTL: ALU_OUT <-- $rs + $rt(se_16)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h02;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_n,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = WB_OUTPUT;
			end
			end// end for INPUT state
			////////////////////////////////////////////////////////////////////////
			//								WB_OUTPUT												//
			////////////////////////////////////////////////////////////////////////
			WB_OUTPUT :
			// RTL : I/O[ALU_OUT] <-- RT(rt)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b1_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for WB_mem state
			////////////////////////////////////////////////////////////////////////
			//								INPUT_CALC            							    //
			////////////////////////////////////////////////////////////////////////
			INPUT_CALC : 
			// RTL: ALU_OUT <-- $rs + $rt(se_16)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h02;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = INPUT;
			end
			end// end for OUTPUT_CALC state
			////////////////////////////////////////////////////////////////////////
			//						  INPUT (load word from I/O memory)           	    //
			////////////////////////////////////////////////////////////////////////
			INPUT:
			// RTL: D_In <-- I_O_Mem[ALU_OUT] 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_1;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b1;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = WB_INPUT;
			end
			end// end for INPUT state
			////////////////////////////////////////////////////////////////////////
			//								WB_INPUT	      										 //
			////////////////////////////////////////////////////////////////////////
			WB_INPUT:
			// RTL : R[rt] <-- D_In
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_01_0_0_011;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b1_0_1;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for WB_OUTPUT state
			////////////////////////////////////////////////////////////////////////
			//							LW_CALC (Effective Address Calculation)	   	 //
			////////////////////////////////////////////////////////////////////////
			LW_CALC :
			// RTL: ALU_OUT <-- $rs + $rt(se_16) 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h02;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = LW;
			end
			end// end for LW_CALC state
			
			////////////////////////////////////////////////////////////////////////
			//							LW  (load word from memory)           	   	    //
			////////////////////////////////////////////////////////////////////////
			LW :
			// RTL: D_In <-- dM[ALU_OUT] 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h02;
			{dm_cs, dm_rd, dm_wr} = 3'b1_1_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = WB_LW;
			end
			end// end for LW state

			////////////////////////////////////////////////////////////////////////
			//								BEQ     part 1/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BEQ :  
			// RTL:  ALU_OUT <-- $rs - $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h04;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {N,Z,C,V};
			ns_intr <= ns_intr;
			state = BEQ_WR;
			end
			end// end for BEQ state
			////////////////////////////////////////////////////////////////////////
			//								BEQ     part 2/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BEQ_WR:  
			// RTL: if(RS ==  RT) PCP4 + {SE14IR[15],IR[15:0],2'b00}
			//		  else 
			//				 PC <- PC + 4
			begin
				@(negedge sys_clk)
				begin
				if(ps_z == 1'b1)
					begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ns_intr;
				state = FETCH;
					end
				else
					begin
					{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
					{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
					{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
					{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
					S_Sel = 1'b0; D_OUT_Sel = 2'b00;
					ld_Flags = 1'b0;
					#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
					ns_intr <= ns_intr;
					state = FETCH;
					end
				end
			 end// end for ADD state
			////////////////////////////////////////////////////////////////////////
			//								BNE     part 1/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BNE :  
			// RTL:  ALU_OUT <-- $rs - $rt
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h04;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {N,Z,C,V};
			ns_intr <= ns_intr;
			state = BNE_WR;
			end
			end// end for ADD state
			////////////////////////////////////////////////////////////////////////
			//								BNE     part 2/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BNE_WR:  
			// RTL: if(RS ==  RT) PCP4 + {SE14IR[15],IR[15:0],2'b00}
			//		  else 
			//				 PC <- PC + 4
			begin
				@(negedge sys_clk)
				begin
				if(ps_z == 1'b0)
					begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ns_intr;
				state = FETCH;
					end
				else
					begin
					{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
					{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
					{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
					{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
					S_Sel = 1'b0; D_OUT_Sel = 2'b00;
					ld_Flags = 1'b0;
					#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
					ns_intr <= ns_intr;
					state = FETCH;
					end
				end
			 end// end for BEQ_WR state
			////////////////////////////////////////////////////////////////////////
			//								BLEZ   part 1/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BLEZ :  
			// RTL:  ALU_OUT <-- $rs 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {N,Z,C,V};
			ns_intr <= ns_intr;
			state = BLEZ_WR;
			end
			end// end for BLEZ state
			////////////////////////////////////////////////////////////////////////
			//								BLEZ     part 2/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BLEZ_WR:  
			// RTL: if(rs <= 0) PCP4 + Sign_Extention_IR[15:0] << 2
			//		  else 
			//				 PC <- PC + 4
			begin
				@(negedge sys_clk)
				begin
				if(ps_z == 1'b1 | ps_n == 1'b1)
				begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ns_intr;
				state = FETCH;
				end
				else
				begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ns_intr;
				state = FETCH;
				end
				end
			 end// end for BLEZ_WR state
			////////////////////////////////////////////////////////////////////////
			//								BGTZ   part 1/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BGTZ :  
			// RTL:  ALU_OUT <-- $rs 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {N,Z,C,V};
			ns_intr <= ns_intr;
			state = BGTZ_WR;
			end
			end// end for BGTZ state
			////////////////////////////////////////////////////////////////////////
			//								BGTZ     part 2/2	 									 //
			////////////////////////////////////////////////////////////////////////
			BGTZ_WR:  
			// RTL: if(rs > 0) PCP4 + Sign_Extention_IR[15:0] << 2
			//		  else 
			//				 PC <- PC + 4
			begin
				@(negedge sys_clk)
				begin
				if(!(ps_z == 1'b1 | ps_n == 1'b1))
				begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ps_intr;
				state = FETCH;
				end
				else
				begin
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
				{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
				S_Sel = 1'b0; D_OUT_Sel = 2'b00;
				ld_Flags = 1'b0;
				#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
				ns_intr <= ps_intr;
				state = FETCH;
				end
				end
			 end// end for BGTZ_WR state
			////////////////////////////////////////////////////////////////////////
			//								SETIE		   											 //
			////////////////////////////////////////////////////////////////////////
			SETIE : 
			// RTL: interrupt enable 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= 1'b1;
			state = FETCH;
			end
			end// end for SETIE state
			
			////////////////////////////////////////////////////////////////////////
			//								RETI		   											 //
			////////////////////////////////////////////////////////////////////////
			RETI : 
			// RTL: RS <-- RF[$sp]
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b1; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= ps_intr;
			state = RETI_2;
			end
			end// end for RETI state
			////////////////////////////////////////////////////////////////////////
			//								RETI_2	   											 //
			////////////////////////////////////////////////////////////////////////
			RETI_2 : 
			// RTL: ALU_OUT <-- RS
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= ps_intr;
			state = RETI_3;
			end
			end// end for RETI_2 state
			////////////////////////////////////////////////////////////////////////
			//								RETI_3	   											 //
			////////////////////////////////////////////////////////////////////////
			RETI_3 : 
			// RTL:  Present State Flags <--- M{ALU_OUT] , RS <-- Rf[$sp]
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b1_1_0;                       int_ack = 1'b0;
			S_Sel = 1'b1; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b1;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {N,Z,C,V};
		   ns_intr <= ps_intr;
			state = RETI_4;
			end
			end// end for RETI_3 state		
			////////////////////////////////////////////////////////////////////////
			//								RETI_3	   											 //
			////////////////////////////////////////////////////////////////////////
			RETI_4 : 
			// RTL:  ALU_OUT <-- RS - 4
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h12;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= ps_intr;
			state = RETI_5;
			end
			end// end for RETI_3 state			
			
			////////////////////////////////////////////////////////////////////////
			//								RETI_4	   											 //
			////////////////////////////////////////////////////////////////////////
			RETI_5 : 
			// RTL:  D_In <-- M[ALU_OUT]  ,    Rd[$sp] <-- ALU_OUT
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_11_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b1_1_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= ps_intr;
			state = RETI_6;
			end
			end// end for RETI_4 state
			////////////////////////////////////////////////////////////////////////
			//								RETI_5	   											 //
			////////////////////////////////////////////////////////////////////////
			RETI_6 : 
			// RTL: RS <-- RF[$sp] , PC <-- D_In
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b10_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_011;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b1; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= ps_intr;
			state = RETI_7;
			end
			end// end for RETI_5 state
			////////////////////////////////////////////////////////////////////////
			//								RETI_6	   											 //
			////////////////////////////////////////////////////////////////////////
			RETI_7 : 
			// RTL: ALU_OUT <-- RS - 4
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h12;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= ps_intr;
			state = RETI_8;
			end
			end// end for RETI_6 state
			////////////////////////////////////////////////////////////////////////
			//								RETI_7	   											 //
			////////////////////////////////////////////////////////////////////////
			RETI_8: 
			// RTL: Rd[$sp] <-- ALU_OUT
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_11_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= ps_intr;
			state = FETCH;
			end
			end// end for RETI_7 state

			////////////////////////////////////////////////////////////////////////
			//						JUMP     		   											 //
			////////////////////////////////////////////////////////////////////////
			JUMP:
			// RTL: PC <-- {PC+4[31:28],Address,2'b00}
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b01_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_z,ps_v};
			ns_intr <= ps_intr;
			state = FETCH;
			end
			end// end for JUMP state
			////////////////////////////////////////////////////////////////////////
			//								JR_CALC 	   											 //
			////////////////////////////////////////////////////////////////////////
			JR_CALC : 
			// RTL: ALU_OUT <-- R[rs]
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = JR;
			end
			end// end for JR_CALC
			////////////////////////////////////////////////////////////////////////
			//								JR    	   											 //
			////////////////////////////////////////////////////////////////////////
			JR : 
			// RTL: PC <-- ALU_OUT[rs]
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b10_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for JR
			////////////////////////////////////////////////////////////////////////
			//								JAL    	   											 //
			////////////////////////////////////////////////////////////////////////
			JAL : 
			// RTL: PC <-- {PC+4[31:28],Address,2'b00}
			//		  R[$ra] <-- PC
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b01_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_10_0_0_100;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for JAL
			////////////////////////////////////////////////////////////////////////
			//								BREAK		   							NOT DONE		 //
			////////////////////////////////////////////////////////////////////////
			BREAK :
			begin
			@(negedge sys_clk)
			begin
			$display("BREAK INSTRUCTION FETCH %t",$time);
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			$display(" R E G I S T E R ' S  A F T E R  B R E A K");
			$display(" ");
			Dump_Registers32; 
			$display(" ");
			Dump_Memory;
			Dump_I_O_Memory;
			$finish;                                   
			end
			end
			////////////////////////////////////////////////////////////////////////
			//						ILLEGAL OP	      								NOT DONE  //
			////////////////////////////////////////////////////////////////////////
			ILLEGAL_OP :
			begin
			@(negedge sys_clk)
			begin
			$display("ILLEGAL OPCODE FETCHED %t",$time);
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			Dump_Registers32; //task to output MIPS RegFile
			Dump_PC_and_IR; // task to output current values of Program Counter 
								 // and Instruction Register
			$finish;
			end
			end
			////////////////////////////////////////////////////////////////////////
			//						INTERRUPT 1	      								NOT DONE  //
			////////////////////////////////////////////////////////////////////////
			INTR_1 : 
			// RTL : ALU_OUT <-- 0x3FC 
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h15;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = INTR_2;
			end
			end
			////////////////////////////////////////////////////////////////////////
			//						INTERRUPT 2	      								NOT DONE  //
			////////////////////////////////////////////////////////////////////////
			INTR_2 : 
			// RTL: D_In <--M[ALU_OUT(0x3FC)], RS <-- RF[$sp]
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0; 
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b1_1_0;                       int_ack = 1'b0;
			S_Sel = 1'b1; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = INTR_3;
			end
			end
			////////////////////////////////////////////////////////////////////////
			//						INTERRUPT 3	      								NOT DONE  //
			////////////////////////////////////////////////////////////////////////
			INTR_3 : 
			// RTL: PC<-- D_In  , ALU_OUT <-- RS + 4
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b10_1_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0; 
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_011;    FS = 5'h11;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b1; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = INTR_4;
			end
			end
			////////////////////////////////////////////////////////////////////////
			//						INTERRUPT 4	      								NOT DONE  //
			////////////////////////////////////////////////////////////////////////
			INTR_4 : 
			// RTL: Rd[$sp] <-- ALU_OUT ,  M[ALU_OUT(0x3FC)] <-- PC
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0; 
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_11_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b1_0_1;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b01;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = INTR_5;
			end
			end
			
			////////////////////////////////////////////////////////////////////////
			//						INTERRUPT 5	      							             //
			////////////////////////////////////////////////////////////////////////
			INTR_5 : 
			// RTL: RS <-- RF[$sp]
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0; 
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b1; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = INTR_6;
			end
			end
		   ////////////////////////////////////////////////////////////////////////
			//						INTERRUPT 6       								NOT DONE  //
			////////////////////////////////////////////////////////////////////////
			INTR_6 : 
			// RTL: ALU_OUT <-- RS + 4
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0; 
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h11;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = INTR_7;
			end
			end
			////////////////////////////////////////////////////////////////////////
			//						INTERRUPT 7	      								NOT DONE  //
			////////////////////////////////////////////////////////////////////////
			INTR_7 : 
			// RTL: M[ALU_OUT] <-- {N,Z,C,V}, Rd[$sp] <-- ALU_OUT
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0; 
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_11_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b1_0_1;                       int_ack = 1'b1;
			S_Sel = 1'b0; D_OUT_Sel = 2'b10;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end
			////////////////////////////////////////////////////////////////////////
			//								MFHI   				         						 //
			////////////////////////////////////////////////////////////////////////
			MFHI :
			// RTL : R[rd] <-- Y_HI
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_00_0_0_000;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end of MFHI state
			////////////////////////////////////////////////////////////////////////
			//								MFLO   				         						 //
			////////////////////////////////////////////////////////////////////////
			MFLO :
			// RTL : R[rd] <-- Y_LO
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_00_0_0_001;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end of MFLO state
			////////////////////////////////////////////////////////////////////////
			//								WB_alu													 //
			////////////////////////////////////////////////////////////////////////
			WB_alu :
			// RTL : R[rd] <-- ALU_OUT
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_00_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for WB_alu state
			////////////////////////////////////////////////////////////////////////
			//								WB_imm													 //
			////////////////////////////////////////////////////////////////////////
			WB_imm :
			// RTL : R[rt] <-- ALU_OUT
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_01_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
		   ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for WB_imm state
			////////////////////////////////////////////////////////////////////////
			//								WB_mem													 //
			////////////////////////////////////////////////////////////////////////
			WB_mem :
			// RTL : M[ALU_OUT(rs+se_16)] <-- RT(rt)
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b0_00_0_0_010;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b1_0_1;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} = {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for WB_mem state
			////////////////////////////////////////////////////////////////////////
			//								WB_LW 													 //
			////////////////////////////////////////////////////////////////////////
			WB_LW :
			// RTL : R[rt] <-- D_In
			begin
			@(negedge sys_clk)
			begin
			{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0; {IO_wr,IO_rd} = 2'b0_0;
			{im_cs, im_rd, im_wr} = 3'b0_0_0; D_In_Sel = 1'b0;
			{D_En, DA_Sel, T_Sel, HILO_ld, Y_Sel} = 8'b1_01_0_0_011;    FS = 5'h00;
			{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                       int_ack = 1'b0;
			S_Sel = 1'b0; D_OUT_Sel = 2'b00;
			ld_Flags = 1'b0;
			#1 {ns_n,ns_z,ns_c,ns_v} <= {ps_n,ps_z,ps_c,ps_v};
			ns_intr <= ns_intr;
			state = FETCH;
			end
			end// end for WB_mem state
			endcase			
		

			
			
			task Dump_Registers16;// Display registers  0 to 15
			begin
			for ( i = 0 ; i < 16 ; i = i +1)
				begin
				 $display("time = %t, Register %h = %h",$time,
							 i, Top_lvlTB.uut.IDP_uut.RF0.Data[i]);
				end//end for
			end
			endtask//end Dump_Register16 task
			
			task Dump_Registers32;// Display register 0 to 31
			begin
			for ( i = 0 ; i < 32 ; i = i +1)
				begin
				 $display("time = %t, Register %h = %h",$time,i,
							Top_lvlTB.uut.IDP_uut.RF0.Data[i]);
				end//end Dump_Registers32 for
			end
			endtask//end Dump_Registers32 task
			
			task Dump_PC_and_IR;// Display contents of PC and IR registers
			begin
			$display("time = %t , PC = %h, IR = %h",$time,
			         Top_lvlTB.uut.IU_uut.PC,Top_lvlTB.uut.IU_uut.IR);
			end
			endtask// end Dump_PCand_IR task
			task Dump_Memory;// Display contents of Memory
			begin// Displaying Memory locations M[C0] to M[FF]
			for ( i =  960; i < 1012 ; i = i +1)
				begin
				 $display("Memory [%h] =  %3'h",i,Top_lvlTB.dm_uut.Mem[i]);
				end//end Dump_Registers32 for
			end
			endtask// end Dump_Memory
			
			task Dump_I_O_Memory;// Display contents of I_O_Memory
			begin// Displaying Memory locations I_0_M[C0] to I_0_M[FF]
			for ( i = 192 ; i < 256 ; i = i +1)
				begin
				 $display("I_O_Memory [%h] =  %3'h",i,Top_lvlTB.IOMEM.Mem[i]);
				end//end Dump_Registers32 for
			end
			endtask// end Dump_Memory
			
endmodule

