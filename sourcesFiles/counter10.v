`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:59:43 12/04/2014 
// Design Name: 
// Module Name:    counter10 
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
module counter10(
input endgame,
input rst,
input  cp,
input  en,
input pause,
output reg  [3:0] Q=4'b0
);
//----------------ʮ���Ƽ�����-------------------//
		always@(posedge cp or negedge rst)
		begin
		  if(~rst) Q <= 1'b0;
		  else if(!en||pause||endgame) Q<=Q;
		  else if(Q == 4'b1001) 
		          Q <= 4'b0000;//������10�����     	
		  else    Q <= Q + 1'b1;//������1
		end
//-------------------------------------------//
endmodule
