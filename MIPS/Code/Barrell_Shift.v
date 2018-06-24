`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:34:51 11/10/2016 
// Design Name: 
// Module Name:    Barrell_Shift 
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
module Barrell_Shift(FS,T,shamt,Y);
	input [31:0] T;      //Input value
	input [4:0] FS;      //Function Select
	input [4:0] shamt;   //shift amount
	output reg [31:0] Y; //product
 
   parameter BSLR = 5'h1A , BSRR = 5'h1B;
	always@(*)
		begin
		case(FS)
			BSLR:
			case(shamt)
			5'h00: Y = T;
			5'h01: Y = {T[30:0],T[31]};
			5'h02: Y = {T[29:0],T[31:30]};
			5'h03: Y = {T[28:0],T[31:29]};
			5'h04: Y = {T[27:0],T[31:28]};
			5'h05: Y = {T[26:0],T[31:27]};
			5'h06: Y = {T[25:0],T[31:26]};
			5'h07: Y = {T[24:0],T[31:25]};
			5'h08: Y = {T[23:0],T[31:24]};
			5'h09: Y = {T[22:0],T[31:23]};
			5'h0A: Y = {T[21:0],T[31:22]};
			5'h0B: Y = {T[20:0],T[31:21]};
			5'h0C: Y = {T[19:0],T[31:20]};
			5'h0D: Y = {T[18:0],T[31:19]};
			5'h0E: Y = {T[17:0],T[31:18]};
			5'h0F: Y = {T[16:0],T[31:17]};
			5'h10: Y = {T[15:0],T[31:16]};
			5'h11: Y = {T[14:0],T[31:15]};
			5'h12: Y = {T[13:0],T[31:14]};
			5'h13: Y = {T[12:0],T[31:13]};
			5'h14: Y = {T[11:0],T[31:12]};
			5'h15: Y = {T[10:0],T[31:11]};
			5'h16: Y = {T[9:0],T[31:10]};
			5'h17: Y = {T[8:0],T[31:9]};
			5'h18: Y = {T[7:0],T[31:8]};
			5'h19: Y = {T[6:0],T[31:7]};
			5'h1A: Y = {T[5:0],T[31:6]};
			5'h1B: Y = {T[4:0],T[31:5]};
			5'h1C: Y = {T[3:0],T[31:4]};
			5'h1D: Y = {T[2:0],T[31:3]};
			5'h1E: Y = {T[1:0],T[31:2]};
			5'h1F: Y = {T[0],T[31:1]};
			
			default: Y = T;
			endcase

			BSRR :
			case(shamt)
			5'h00 : Y = T;
			5'h01 : Y = {T[0],T[31:1]};
			5'h02 : Y = {T[1:0],T[31:2]};
			5'h03 : Y = {T[2:0],T[31:3]};
			5'h04 : Y = {T[3:0],T[31:4]};
			5'h05 : Y = {T[4:0],T[31:5]};
			5'h06 : Y = {T[5:0],T[31:6]};
			5'h07 : Y = {T[6:0],T[31:7]};
			5'h08 : Y = {T[7:0],T[31:8]};
			5'h09 : Y = {T[8:0],T[31:9]};
			5'h0A : Y = {T[9:0],T[31:10]};
			5'h0B : Y = {T[10:0],T[31:11]};
			5'h0C : Y = {T[11:0],T[31:12]};
			5'h0D : Y = {T[12:0],T[31:13]};
			5'h0E : Y = {T[13:0],T[31:14]};
			5'h0F : Y = {T[14:0],T[31:15]};
			5'h10 : Y = {T[15:0],T[31:16]};
			5'h11 : Y = {T[16:0],T[31:17]};
			5'h12 : Y = {T[17:0],T[31:18]};
			5'h13 : Y = {T[18:0],T[31:19]};
			5'h14 : Y = {T[19:0],T[31:20]};
			5'h15 : Y = {T[20:0],T[31:21]};
			5'h16 : Y = {T[21:0],T[31:22]};
			5'h17 : Y = {T[22:0],T[31:23]};
			5'h18 : Y = {T[23:0],T[31:24]};
			5'h19 : Y = {T[24:0],T[31:25]};
			5'h1A : Y = {T[25:0],T[31:26]};	
			5'h1B : Y = {T[26:0],T[31:27]};	
			5'h1C : Y = {T[27:0],T[31:28]};	
			5'h1D : Y = {T[28:0],T[31:29]};	
			5'h1E : Y = {T[29:0],T[31:30]};	
			5'h1F : Y = {T[30:0],T[31:31]};
			default : Y = T;
			endcase 
		
			default: Y = 32'b0;
			endcase
		end
endmodule
