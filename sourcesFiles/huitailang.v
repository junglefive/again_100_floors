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
input signed[11:0]rel_xx,			/*相对位移*/
input [9:0]cnt_life,					/*生命计数*/
input [10:0]vector_x,				/*扫描坐标x*/
input [9:0]vector_y,					/*扫描坐标x*/
input clk_50m,							/*时钟*/
input face_RL,							/*右脸_左脸转换标志*/
output reg[7:0] color=0						/*输出灰太狼颜色信号*/
    );
//----------------读取动态数据--------------------------------//
reg [12:0] i=2499,j=2500;					/*整数，用于循环读取灰太狼像素颜色*/
//------------左(0-2499)右(2500-4999)脸------------------------------------//
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
	if(~face_RL) color<=douta; //a为右脸
	else 
		begin if(~up_flg)color<=doutb;else color<=douta;end
//----------------------------------------------------------//	
endmodule
