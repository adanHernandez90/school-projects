`timescale 1ns / 1ps
/****************************** C E C S  4 4 0 ******************************
 * 
 * File Name:  Top_lvlTB.v
 * Designer:   Kassandra Flores, Adan Hernandez
 * Email:      kassandra.flores@student.csulb.edu,
 *					adan.hernandez@student.csulb.edu
 * Rev. No.:   Version 1.0
 * Rev. Date:  10/18/2016
 *
 * Purpose: To implement the Instruction Unit, Integer datapath , Data 
 * memory and Control unit and create an operating MIPS baeline architecture.
 * Interrupt sources into the CPU will come from a defined I/O space and 
 * the cpu is tasked to identify and acknowledge that a interrupt has been
 * requested.
 ****************************************************************************/

module Top_lvlTB;

	// Inputs
	reg sys_clk;
	reg reset;
	reg intr;
	wire [31:0] D_in_Mem;
	wire [31:0] D_in_IO;

	// Outputs
	wire [31:0] ALU_OUT;
	wire dm_wr;
	wire dm_cs;
	wire dm_rd;
	wire IO_wr;
	wire IO_rd;
	wire intr_ack;
	wire intr_req;
	wire [31:0] D_OUT;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.sys_clk(sys_clk), 
		.reset(reset), 
		.intr_req(intr_req), 
		.ALU_OUT(ALU_OUT), 
		.dm_wr(dm_wr), 
		.dm_cs(dm_cs), 
		.dm_rd(dm_rd), 
		.IO_wr(IO_wr), 
		.IO_rd(IO_rd), 
		.D_in_Mem(D_in_Mem), 
		.D_in_IO(D_in_IO), 
		.intr_ack(intr_ack), 
		.D_OUT(D_OUT)
	);

	Data_Memory dm_uut (
    .clk(sys_clk), 
    .dm_cs(dm_cs), 
    .dm_wr(dm_wr), 
    .dm_rd(dm_rd), 
    .D_Out(D_in_Mem), 
    .Addr(ALU_OUT[11:0]), 
    .D_In(D_OUT)
    );


I_O 
	IOMEM (
    .sys_clk(sys_clk), 
    .intr(intr), 
    .Addr(ALU_OUT[11:0]), 
    .D_In(D_OUT), 
    .intr_req(intr_req), 
    .intr_ack(intr_ack), 
    .IO_wr(IO_wr),
    .IO_rd(IO_rd), 
    .IO_D_Out(D_in_IO)
    );


// Create a 10 ns clock
   always
   #5 sys_clk=~sys_clk;

	initial begin
	// Initialize Inputs
		$timeformat(-9, 1, " ns", 9);    
		$readmemh("iMem15.list",uut.IU_uut.Instruction_Memory.Mem);
		$readmemh("dMem14_Fa16.list",dm_uut.Mem);
		sys_clk = 0;
		reset = 1;
		intr = 0;
		$display(" WITH ISR, Interrupt after writing to register 1 to 15 ");
		// Wait 100 ns for global reset to finish
		#100;
      reset = 1'b0;
		// Add stimulus here
		 #910 intr = 1;
		 @(posedge intr_ack)
		 intr = 0;
		
	end
      
endmodule

