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
input pause,									 /*��ͣ*/
input left_shift,								 /*����*/
input right_shift,							 /*����*/
output reg signed [11:0] rel_xx=12'h000,/*�������*/
output reg face_RL=1'b1						 /*Ĭ��Ϊ1����ʾ��̫������*/	
    );
//----------------���ơ����Ƽ���---------------------//
reg signed[9:0]  left_x=12'b0;				/*�з�����*/
reg signed[9:0] right_x=12'b0;				/*�з�����*/
reg face_RL1;
reg face_RL2;
always@(posedge left_shift or negedge rst)					/*����ʹ��*/
	if(~rst)	left_x<=10'b0;
	else
		begin
			face_RL1<=1'b0;							/*������£���̫��������ʾ*/
			if(pause) left_x <=left_x ;			 /*��ͣ*/
			else
				begin							
					if(left_x-right_x<11) left_x <= left_x +1'b1;
					else left_x <=left_x ;			/*����ƽ���Ե�����������Ƽ�������ԭ��*/
				end
		end
always@( posedge right_shift or negedge rst)					/*����ʹ��*/
	if(~rst)	right_x<=10'b0;
	else
		begin
			face_RL2<=1'b1;							/*�Ҽ����£���̫��������ʾ*/
			if(pause) right_x<=right_x;			 /*��ͣ*/
			else
				begin
					if(right_x-left_x<11)right_x <= right_x +1'b1;
					else right_x<=right_x; 			/*����ƽ���Ե�����������Ƽ�������ԭ��*/
				end	
		end
always@(posedge right_shift,posedge left_shift)
		if(right_shift) face_RL<=face_RL1;
		else				 face_RL<=face_RL2;
		
always@*	rel_xx <= 25*(left_x - right_x);/*�������,��һ�°�������25������ƽ��*/
//----------------------------------------------------------------------//
endmodule
