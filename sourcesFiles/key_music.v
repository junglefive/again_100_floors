`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:56 12/31/2014 
// Design Name: 
// Module Name:    key_music 
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
module key_music(
input clk,                   //系统时钟50MHZ
input music_en,
input[7:0]key,               //按键输入
output reg buzzout=1'b0,          //蜂鸣器输出
output [7:0] led				  //输出当前键值
);//模块名称key_music
reg[15:0]counter,count_end; //定义寄存器
reg key_flg=1'b0;					/*输出标志*/
	always@(posedge clk)
	begin
		counter = counter + 1'b1;//计数器加1
		if(counter==count_end)
		begin
			counter = 16'b0;   //计数器清零
			if(key_flg&&music_en)//
				buzzout = ~buzzout;
			else buzzout = 1'b0;
		end
	end
//---------------------------------------------------------------//
	always@(*)
	begin
		if(key!=8'hff)key_flg = 1'b1;
		else key_flg = 1'b0;
		case(key)
			 8'b11111110: count_end=16'd47774; //中音1的分频系数值key==fe
          8'b11111101: count_end=16'd42568; //中音2的分频系数值key==fd
          8'b11111011: count_end=16'd37919; //中音3的分频系数值key==fb
          8'b11110111: count_end=16'd35791; //中音4的分频系数值key==f7
          8'b11101111: count_end=16'd31888; //中音5的分频系数值key==ef
          8'b11011111: count_end=16'd28409; //中音6的分频系数值key==df
          8'b10111111: count_end=16'd25309; //中音7的分频系数值key==bf
          8'b01111111: count_end=16'd23912; //高音1的分频系数值key==7f
          8'b01111110: count_end=16'd21282; //高音2的分频系数值key==7e
          8'b01111101: count_end=16'd18961; //高音3的分频系数值key==7d
          8'b01111011: count_end=16'd17897; //高音4的分频系数值key==7b
          8'b01110111: count_end=16'd15944; //高音5的分频系数值key==77
          8'b01101111: count_end=16'd14205; //高音6的分频系数值key==6f
          8'b01011111: count_end=16'd12655; //高音7的分频系数值key==5f
              default: count_end=16'hffff;
		endcase
	end
	assign led = ~key;//输出按键状态
endmodule
