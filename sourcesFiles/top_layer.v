`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: hust
// Engineer: U201213759
// Create Date:    17:25:58 12/21/2014 
// Design Name: 
// Module Name:    TopLayer 
// Project Name: OneHundredLayer
// Target Devices: basys2
// Tool versions: ISE14.7 
// ���������� 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_layer(
input  rst_in,  							/*��λ����*/
input  modle,
input music_en,							//��Ч����
input  clk_50m, 							/*ʱ������*/
input  pause,								/*��ͣ*/
input  left_shift,						/*����*/
input  right_shift,						/*����*/
input  [1:0] sw,							//�ٶ��л�
output [11:0] display,					/*��̬ɨ����ʾ*/
output  VGA_HS,VGA_VS,		       	/*�����ɨ���ź�,Ĭ�ϸߵ�ƽ*/
output [2:0]  VGA_RED,VGA_GREEN,    /*���RGB�ź�*/
output [1:0]  VGA_BLUE,					/*Blue*/
output buzzout,
output [7:0] led
    ); 
wire rst;					/*��λ*/	
wire clk_8hz;				/*�Ʒ�Ƶ�ʣ�ԼΪ1Hz*/
wire clk_score;			//�Ʒ�Ƶ��1hz
wire clk_25m;
//-------------------------------------------------------------//
//--------------------/*����ʵ���첽��λͬ���ָ�*/----------------------------// 
async_rst_sync_recover U1 (.clk_50m(clk_50m), .rst_in(rst_in), .rst(rst));	 
//-----------------------------------------------------------------------//
//--------------------���÷�Ƶģ�飬ʵ��25M,1Hz��Ƶ--------------------------//
/*���÷�Ƶģ�飬���25MƵ��*/
FrequenceDivide U2 (
		.rst(rst), 
		.pause(pause), 
		.clk_50m(clk_50m), 
		.clk_25m(clk_25m), 
		.clk_score(clk_score), 
		.clk_8hz(clk_8hz)
	);
//-------------------/*���ò��������ģ�飬���������*/-----------------------//	
//---------------------/*����������ģ��*/---------------------------------// 
MainGameBody  U3(
	.rst(rst),
	.pause(pause),
	.modle(modle),
	.music_en(music_en),
	.sw(sw),
	.clk_8hz(clk_8hz),
	.clk_50m(clk_50m),
	.clk_score(clk_score),
	.left_shift(left_shift),
	.right_shift(right_shift),
	.clk_25m(clk_25m), 
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_RED(VGA_RED),
	.VGA_GREEN(VGA_GREEN),
	.VGA_BLUE(VGA_BLUE),
	.display(display),
	.led(led),
	.buzzout(buzzout) 
);
//---------------------------------------------------------------------//
endmodule
