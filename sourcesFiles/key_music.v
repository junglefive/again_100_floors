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
input clk,                   //ϵͳʱ��50MHZ
input music_en,
input[7:0]key,               //��������
output reg buzzout=1'b0,          //���������
output [7:0] led				  //�����ǰ��ֵ
);//ģ������key_music
reg[15:0]counter,count_end; //����Ĵ���
reg key_flg=1'b0;					/*�����־*/
	always@(posedge clk)
	begin
		counter = counter + 1'b1;//��������1
		if(counter==count_end)
		begin
			counter = 16'b0;   //����������
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
			 8'b11111110: count_end=16'd47774; //����1�ķ�Ƶϵ��ֵkey==fe
          8'b11111101: count_end=16'd42568; //����2�ķ�Ƶϵ��ֵkey==fd
          8'b11111011: count_end=16'd37919; //����3�ķ�Ƶϵ��ֵkey==fb
          8'b11110111: count_end=16'd35791; //����4�ķ�Ƶϵ��ֵkey==f7
          8'b11101111: count_end=16'd31888; //����5�ķ�Ƶϵ��ֵkey==ef
          8'b11011111: count_end=16'd28409; //����6�ķ�Ƶϵ��ֵkey==df
          8'b10111111: count_end=16'd25309; //����7�ķ�Ƶϵ��ֵkey==bf
          8'b01111111: count_end=16'd23912; //����1�ķ�Ƶϵ��ֵkey==7f
          8'b01111110: count_end=16'd21282; //����2�ķ�Ƶϵ��ֵkey==7e
          8'b01111101: count_end=16'd18961; //����3�ķ�Ƶϵ��ֵkey==7d
          8'b01111011: count_end=16'd17897; //����4�ķ�Ƶϵ��ֵkey==7b
          8'b01110111: count_end=16'd15944; //����5�ķ�Ƶϵ��ֵkey==77
          8'b01101111: count_end=16'd14205; //����6�ķ�Ƶϵ��ֵkey==6f
          8'b01011111: count_end=16'd12655; //����7�ķ�Ƶϵ��ֵkey==5f
              default: count_end=16'hffff;
		endcase
	end
	assign led = ~key;//�������״̬
endmodule
