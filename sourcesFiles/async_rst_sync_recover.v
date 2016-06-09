`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:47:56 12/25/2014 
// Design Name: 
// Module Name:    async_rst_sync_recover 
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
/*异步复位同步恢复模块*/
module async_rst_sync_recover(
input clk_50m,								/*时钟*/
input rst_in,								/*输入复位信号*/
output rst									/*同步复位*/
    );
reg sync_rst0=1'b1;					
reg sync_rst1=1'b1;
assign rst=sync_rst1;					/*随syn_rst1变化*/
always@(posedge clk_50m or negedge rst_in)
	begin 
		if (~rst_in) 						/*复位*/
			begin
				sync_rst0<=1'b0;	
			   sync_rst1<=1'b0;			/*复位则归零，实现异步复位*/
			end
		else
			begin								/*rst_in无效后*/
				sync_rst0<=1'b1;			/*下一个脉冲沿到来将syn_rst置1*/
			   sync_rst1<=sync_rst0;	/*下下一个时钟脉冲到来，syn_rst实现同步复位*/
			end
	end
endmodule
