`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:11:10 12/26/2014 
// Design Name: 
// Module Name:    MainGameBody 
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
module MainGameBody(
input rst,  									/*��λ*//*�½�����Ч*/
input pause,									/*��ͣ*//*�ߵ�ƽ��Ч*/
input modle,
input music_en,
input [1:0]sw,
input clk_50m, 								/*ʱ��*/
input clk_8hz,
input clk_score,
input left_shift,								/*����*/
input right_shift,							/*����*/
output        	  VGA_HS,				/*�����ɨ���ź�,Ĭ�ϸߵ�ƽ*/
output        	  VGA_VS,				/*�����ɨ���ź�,Ĭ�ϸߵ�ƽ*/
output  [2:0]   VGA_RED,				/*���RED  �ź�*/
output  [2:0] VGA_GREEN,				/*���GREEN�ź�*/
output  [1:0]  VGA_BLUE, 				/*���BLUE �ź�*/
output  [11:0] display,
output  buzzout,
output [7:0] led
    );
//-------------------------------------------//
//-------------����VGAʱ��ɨ��------------------//
wire [10:0] vector_x;
wire [9:0]  vector_y;
/*����VGA_HS_VS�źŲ����ص�ǰɨ������*/
VGA_timing U30 		(
		.clk_50m(clk_50m), 
		.vector_x(vector_x), 
		.vector_y(vector_y), 
		.VGA_HS(VGA_HS), 
		.VGA_VS(VGA_VS)
	);
//---------------------------------------------//
//-----����������������Ӧ�������з�����rel_xx-------//	
wire signed [11:0] rel_xx;
wire face_RL;											/*���ұ�־�ź�*/
/*���ơ����Ƽ�������*/	
left_right_shift U31 (
		.rst(rst),
		.pause(pause),
		.left_shift(left_shift), 
		.right_shift(right_shift), 
		.rel_xx(rel_xx),
		.face_RL(face_RL)
	);
//----------------------------------------------//
//---------------VGA��ʾģ��---------------------//
wire [7:0] key;											//���ⰴ��
wire endgame;
VGAdisplay U33(
		.rst(rst), 
		.pause(pause),
		.modle(modle),
		.sw(sw),
		.rel_xx(rel_xx), 
		.face_RL(face_RL),
		.clk_8hz(clk_8hz),
		.clk_50m(clk_50m),   
		.vector_x(vector_x), 
		.vector_y(vector_y), 
		.endgame(endgame),
		.key(key), 		
		.VGA_RED(VGA_RED), 
		.VGA_GREEN(VGA_GREEN), 
		.VGA_BLUE(VGA_BLUE)
	);	
//---------------------------------------------//
//-----------����������ʾģ��---------------------//
	// Instantiate the Unit Under Test (UUT)
key_music U34 (
		.clk(clk_50m), 
		.key(key), 
		.music_en(music_en),
		.led(led),
		.buzzout(buzzout) 
	);
//------------�����������ʾ����-------------------//
Score	U35(
	.clk_50m(clk_50m),
	.clk_1Hz(clk_score),
	.rst(rst),
	.pause(pause),
	.endgame(endgame), 
	.display(display)
);	
//---------------------------------------------//	
endmodule
