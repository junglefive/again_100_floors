`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:21:27 12/21/2014 
// Design Name: 
// Module Name:    FrequenceDivide 
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
module FrequenceDivide(
input			rst,
input			pause,
input		   clk_50m,			/*����50M*/
output   	clk_score,
output 		clk_8hz
    );
//------------------------------------------------------------------
reg clk_score_tmp1=1'b0;
reg clk_score_tmp2=1'b0;
reg clk_score_tmp3=1'b0;
//-------------ʵ�����������Ƶ��---------------------------//
always@(posedge clk_8hz)begin clk_score_tmp1<=~clk_score_tmp1; end
always@(posedge clk_score_tmp1) begin  clk_score_tmp2<=~clk_score_tmp2; end		//1HZ
always@(posedge clk_score_tmp2)begin  clk_score_tmp3<=~clk_score_tmp3;end
//---------------------------------------------------------//	
BUFG U12(.I(clk_score_tmp3),.O(clk_score));
//-------------------ʵ��1Hz��Ƶ-----------------------------//	
reg [22:0] cnt=23'b0;	
reg clk_8hz_tmp=1'b0;
always@( posedge clk_50m)
    begin
		if(~rst) 	cnt <= 1'b0;		/*��λ*/
		else if(pause) cnt<=cnt;		/*��ͣ*/
		else if(cnt==23'd3125000)begin cnt<=0;clk_8hz_tmp<=~clk_8hz_tmp;end
    	else  cnt <= cnt + 1'b1;		
    end
BUFG U13(.I(clk_8hz_tmp),.O(clk_8hz));
//--------------------------------------------//		 
endmodule
