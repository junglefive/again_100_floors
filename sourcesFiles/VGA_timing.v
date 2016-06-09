`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:24 12/26/2014 
// Design Name: 
// Module Name:    VGA_timing 
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
module VGA_timing(
input clk_50m, 									   	/*时钟*/
output reg[10:0] vector_x=0, 						   /*当前vga扫描坐标x*/
output reg[9:0]  vector_y=0,							/*当前vga扫描坐标y*/
output reg        VGA_HS=1,							/*输出场扫描信号,默认高电平*/
output reg        VGA_VS=1								/*输出场扫描信号,默认高电平*/
    );
//------------------/*VGA扫描程序*/---------------------------------------------------------------------//
always@(posedge clk_50m)
			begin
				if(  856<=vector_x && vector_x<976 ) VGA_HS <=1'b0; 	/*产生HS信号*/
				else VGA_HS <=1'b1;																			/*HS=1 */
				if(vector_x==1039)
					begin 
						vector_x <=1'b0;																		/*如果x=1039,x=0*/
						if(vector_y==665 )   vector_y <=1'b0;								/*如果y=665,y=0*/
						else vector_y<=vector_y+1'b1; 													/*y=y+1*/
					end
				else vector_x<= vector_x+1'b1;															/*x=x+1*/	
				if( 637<=vector_y && vector_y<643 ) VGA_VS <=1'b0;   	/*产生VS信号*/
				else VGA_VS <=1'b1;																			/*VS=1 */
			end
//------------------------------------------------------------------------------------------------------//			
endmodule
