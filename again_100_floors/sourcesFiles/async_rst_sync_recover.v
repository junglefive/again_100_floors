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
/*�첽��λͬ���ָ�ģ��*/
module async_rst_sync_recover(
input clk_50m,								/*ʱ��*/
input rst_in,								/*���븴λ�ź�*/
output rst									/*ͬ����λ*/
    );
reg sync_rst0=1'b1;					
reg sync_rst1=1'b1;
assign rst=sync_rst1;					/*��syn_rst1�仯*/
always@(posedge clk_50m or negedge rst_in)
	begin 
		if (~rst_in) 						/*��λ*/
			begin
				sync_rst0<=1'b0;	
			   sync_rst1<=1'b0;			/*��λ����㣬ʵ���첽��λ*/
			end
		else
			begin								/*rst_in��Ч��*/
				sync_rst0<=1'b1;			/*��һ�������ص�����syn_rst��1*/
			   sync_rst1<=sync_rst0;	/*����һ��ʱ�����嵽����syn_rstʵ��ͬ����λ*/
			end
	end
endmodule
