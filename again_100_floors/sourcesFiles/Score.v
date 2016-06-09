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
input  rst,									/*复位*/
input  clk_50m, 							/*时钟*/					
input  clk_1Hz,							/*计分频率*/
input  pause,								/*暂停*/
input  endgame,							/*游戏结束，停止计分标志*/
output [11:0] display					/*动态扫描显示*/
    );
//-------------分数转换为BCD----------------------//
wire  [15:0]  score;									   /*如果换成reg型变量为何不行？*/
wire  secnd_scor_en;										/*十位分数使能*/
wire  third_scor_en;										/*百位分数使能*/
wire  forth_scor_en;										/*千位分数使能*/
counter10 U351(															 /*个*/
.rst(rst),
.cp(clk_1Hz),
.en(1'b1),
.pause(pause),
.endgame(endgame),
.Q(score[3:0])
);	
assign secnd_scor_en = (score[3:0]==4'd9);						 /*进位*/
counter10 U352(																 /*十*/
.rst(rst),
.cp(clk_1Hz),
.pause(pause),
.endgame(endgame),
.en(secnd_scor_en),
.Q(score[7:4])
);
assign third_scor_en = (score[3:0]==4'd9 && score[7:4]==4'd9);/*进位*/
counter10 U353(															 	  /*百*/
.rst(rst),
.cp(clk_1Hz),
.pause(pause),
.endgame(endgame),
.en(third_scor_en),
.Q(score[11:8])
);	
assign forth_scor_en = (score[3:0]==4'd9 && score[7:4]==4'd9 && score[11:8]==4'd9);/*进位*/
counter10 U354(																 /*千*/
.rst(rst),
.cp(clk_1Hz),
.pause(pause),
.endgame(endgame),
.en(forth_scor_en),
.Q(score[15:12])
);	
//--------------------------------------------//
//------------/*调用数码管显示*/----------------//
Display U345(
	.clk(clk_50m),
	.rst(rst),
	.cnt_data(score),
	.bit_code(display[11:8]),
	.seg_code(display[7:0])
);
//---------------------------------------------------------//
endmodule
