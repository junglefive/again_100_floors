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
// 功能描述： 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_layer(
input  rst_in,  							/*复位输入*/
input  modle,
input music_en,							//音效开关
input  clk_50m, 							/*时钟输入*/
input  pause,								/*暂停*/
input  left_shift,						/*左移*/
input  right_shift,						/*右移*/
input  [1:0] sw,							//速度切换
output [11:0] display,					/*动态扫描显示*/
output  VGA_HS,VGA_VS,		       	/*输出场扫描信号,默认高电平*/
output [2:0]  VGA_RED,VGA_GREEN,    /*输出RGB信号*/
output [1:0]  VGA_BLUE,					/*Blue*/
output buzzout,
output [7:0] led
    ); 
wire rst;					/*复位*/	
wire clk_8hz;				/*计分频率，约为1Hz*/
wire clk_score;			//计分频率1hz
wire clk_25m;
//-------------------------------------------------------------//
//--------------------/*调用实现异步复位同步恢复*/----------------------------// 
async_rst_sync_recover U1 (.clk_50m(clk_50m), .rst_in(rst_in), .rst(rst));	 
//-----------------------------------------------------------------------//
//--------------------调用分频模块，实现25M,1Hz分频--------------------------//
/*调用分频模块，获得25M频率*/
FrequenceDivide U2 (
		.rst(rst), 
		.pause(pause), 
		.clk_50m(clk_50m), 
		.clk_25m(clk_25m), 
		.clk_score(clk_score), 
		.clk_8hz(clk_8hz)
	);
//-------------------/*调用产生随机数模块，产生随机数*/-----------------------//	
//---------------------/*调用主函数模块*/---------------------------------// 
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
