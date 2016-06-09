`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:44:36 12/26/2014 
// Design Name: 
// Module Name:    left_right_shift 
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
module left_right_shift(
input	rst,
input pause,									 /*暂停*/
input left_shift,								 /*左移*/
input right_shift,							 /*右移*/
output reg signed [11:0] rel_xx=12'h000,/*相对坐标*/
output reg face_RL=1'b1						 /*默认为1，显示灰太狼右脸*/	
    );
//----------------左移、右移计数---------------------//
reg signed[9:0]  left_x=12'b0;				/*有符号数*/
reg signed[9:0] right_x=12'b0;				/*有符号数*/
reg face_RL1;
reg face_RL2;
always@(posedge left_shift or negedge rst)					/*左移使能*/
	if(~rst)	left_x<=10'b0;
	else
		begin
			face_RL1<=1'b0;							/*左键按下，灰太狼右脸显示*/
			if(pause) left_x <=left_x ;			 /*暂停*/
			else
				begin							
					if(left_x-right_x<11) left_x <= left_x +1'b1;
					else left_x <=left_x ;			/*到达平面边缘，继续按左移键，则在原地*/
				end
		end
always@( posedge right_shift or negedge rst)					/*右移使能*/
	if(~rst)	right_x<=10'b0;
	else
		begin
			face_RL2<=1'b1;							/*右键按下，灰太狼右脸显示*/
			if(pause) right_x<=right_x;			 /*暂停*/
			else
				begin
					if(right_x-left_x<11)right_x <= right_x +1'b1;
					else right_x<=right_x; 			/*到达平面边缘，继续按右移键，则在原地*/
				end	
		end
always@(posedge right_shift,posedge left_shift)
		if(right_shift) face_RL<=face_RL1;
		else				 face_RL<=face_RL2;
		
always@*	rel_xx <= 25*(left_x - right_x);/*相对坐标,按一下按键产生25个像素平移*/
//----------------------------------------------------------------------//
endmodule
