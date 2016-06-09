`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:48 12/24/2014 
// Design Name: 
// Module Name:    Score 
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
module Score(
input  rst,									/*��λ*/
input  clk_50m, 							/*ʱ��*/					
input  clk_1Hz,							/*�Ʒ�Ƶ��*/
input  pause,								/*��ͣ*/
input  endgame,							/*��Ϸ������ֹͣ�Ʒֱ�־*/
output [11:0] display					/*��̬ɨ����ʾ*/
    );
//-------------����ת��ΪBCD----------------------//
wire  [15:0]  score;									   /*�������reg�ͱ���Ϊ�β��У�*/
wire  secnd_scor_en;										/*ʮλ����ʹ��*/
wire  third_scor_en;										/*��λ����ʹ��*/
wire  forth_scor_en;										/*ǧλ����ʹ��*/
counter10 U351(															 /*��*/
.rst(rst),
.cp(clk_1Hz),
.en(1'b1),
.pause(pause),
.endgame(endgame),
.Q(score[3:0])
);	
assign secnd_scor_en = (score[3:0]==4'd9);						 /*��λ*/
counter10 U352(																 /*ʮ*/
.rst(rst),
.cp(clk_1Hz),
.pause(pause),
.endgame(endgame),
.en(secnd_scor_en),
.Q(score[7:4])
);
assign third_scor_en = (score[3:0]==4'd9 && score[7:4]==4'd9);/*��λ*/
counter10 U353(															 	  /*��*/
.rst(rst),
.cp(clk_1Hz),
.pause(pause),
.endgame(endgame),
.en(third_scor_en),
.Q(score[11:8])
);	
assign forth_scor_en = (score[3:0]==4'd9 && score[7:4]==4'd9 && score[11:8]==4'd9);/*��λ*/
counter10 U354(																 /*ǧ*/
.rst(rst),
.cp(clk_1Hz),
.pause(pause),
.endgame(endgame),
.en(forth_scor_en),
.Q(score[15:12])
);	
//--------------------------------------------//
//------------/*�����������ʾ*/----------------//
Display U345(
	.clk(clk_50m),
	.rst(rst),
	.cnt_data(score),
	.bit_code(display[11:8]),
	.seg_code(display[7:0])
);
//---------------------------------------------------------//
endmodule
