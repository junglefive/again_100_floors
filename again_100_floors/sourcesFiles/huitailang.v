`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:14:48 12/26/2014 
// Design Name: 
// Module Name:    ll 
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
module huitailang(
input up_flg,
input signed[11:0]rel_xx,			/*���λ��*/
input [9:0]cnt_life,					/*��������*/
input [10:0]vector_x,				/*ɨ������x*/
input [9:0]vector_y,					/*ɨ������x*/
input clk_50m,							/*ʱ��*/
input face_RL,							/*����_����ת����־*/
output reg[7:0] color=0						/*�����̫����ɫ�ź�*/
    );
//----------------��ȡ��̬����--------------------------------//
reg [12:0] i=2499,j=2500;					/*����������ѭ����ȡ��̫��������ɫ*/
//------------��(0-2499)��(2500-4999)��------------------------------------//
	reg [12:0] addra=13'd0;
	reg [12:0] addrb=13'd2500;
	// Outputs
	wire [7:0] douta;
	wire [7:0] doutb;
	// Instantiate the Unit Under Test (UUT)
	huitailang_rom U331_htl (
		.clka(clk_50m), 
		.addra(addra), 
		.douta(douta), 
		.clkb(clk_50m), 
		.addrb(addrb), 
		.doutb(doutb)
	);
//----------------------------------------------//
always@(posedge clk_50m)
begin
		if(375-rel_xx == vector_x && cnt_life == vector_y) begin i<=2499;j<=2500;end
		else
			begin
				if((375-rel_xx<vector_x && vector_x<=425-rel_xx)
						&&(cnt_life <=vector_y && vector_y<cnt_life+50))
					begin
							begin
								if(up_flg) 		 begin if(i==0)i<=2499; else i<=i-1'b1;addra<=i;end
								else			 	 begin if(i==2499)i<=0; else i<=i+1'b1;addra<=i;end
							end
							begin if(j==4999)j<=2500; else begin j<=j+1'b1;addrb<=j;end		end
							
					end
			end
end

always@(posedge clk_50m)
	if(~face_RL) color<=douta; //aΪ����
	else 
		begin if(~up_flg)color<=doutb;else color<=douta;end
//----------------------------------------------------------//	
endmodule
