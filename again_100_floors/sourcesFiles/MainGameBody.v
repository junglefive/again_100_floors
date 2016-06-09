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
input rst,  									/*复位*//*下降沿有效*/
input pause,									/*暂停*//*高电平有效*/
input modle,
input music_en,
input [1:0]sw,
input clk_50m, 								/*时钟*/
input clk_8hz,
input clk_score,
input left_shift,								/*左移*/
input right_shift,							/*右移*/
output        	  VGA_HS,				/*输出场扫描信号,默认高电平*/
output        	  VGA_VS,				/*输出场扫描信号,默认高电平*/
output  [2:0]   VGA_RED,				/*输出RED  信号*/
output  [2:0] VGA_GREEN,				/*输出GREEN信号*/
output  [1:0]  VGA_BLUE, 				/*输出BLUE 信号*/
output  [11:0] display,
output  buzzout,
output [7:0] led
    );
//-------------------------------------------//
//-------------产生VGA时序扫描------------------//
wire [10:0] vector_x;
wire [9:0]  vector_y;
/*产生VGA_HS_VS信号并返回当前扫描坐标*/
VGA_timing U30 		(
		.clk_50m(clk_50m), 
		.vector_x(vector_x), 
		.vector_y(vector_y), 
		.VGA_HS(VGA_HS), 
		.VGA_VS(VGA_VS)
	);
//---------------------------------------------//
//-----对左移右移作出反应，返回有符号数rel_xx-------//	
wire signed [11:0] rel_xx;
wire face_RL;											/*左右标志信号*/
/*左移、右移计数结束*/	
left_right_shift U31 (
		.rst(rst),
		.pause(pause),
		.left_shift(left_shift), 
		.right_shift(right_shift), 
		.rel_xx(rel_xx),
		.face_RL(face_RL)
	);
//----------------------------------------------//
//---------------VGA显示模块---------------------//
wire [7:0] key;											//虚拟按键
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
//-----------调用音符显示模块---------------------//
	// Instantiate the Unit Under Test (UUT)
key_music U34 (
		.clk(clk_50m), 
		.key(key), 
		.music_en(music_en),
		.led(led),
		.buzzout(buzzout) 
	);
//------------调用数码管显示分数-------------------//
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
