`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:51 12/31/2014 
// Design Name: 
// Module Name:    music 
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
module music(
input [5:0] cnt_music,
output reg [7:0] key=8'h00
    );
always@*
		begin
			case(cnt_music)
			6'd0:key<=8'hfd;           //中音2，持续两个节拍
			6'd1:key<=8'hfd;  
			6'd2:key<=8'hdf;           //中音6，持续两个节拍
			6'd3:key<=8'hdf;	
			6'd4:key<=8'hfb;           //中音3，持续两个节拍
			6'd5:key<=8'hfb;
			6'd6:key<=8'hdf;           //中音6，持续两个节拍
			6'd7:key<=8'hdf;
			6'd8:key<=8'hf7;           //中音4，持续两个节拍
			6'd9:key<=8'hf7;
			6'd10:key<=8'hef;          //中音5
			6'd11:key<=8'hdf;		      //中音6
			6'd12:key<=8'hef;          //中音5，持续两个节拍
			6'd13:key<=8'hef;   
			6'd14:key<=8'h7f;          //高音1，持续两个节拍
			6'd15:key<=8'h7f;
			6'd16:key<=8'h7e;          //高音2
			6'd17:key<=8'hdf;          //中音6
			6'd18:key<=8'h7d;          //高音3
			6'd19:key<=8'h7b;          //高音4
			6'd20:key<=8'h7d;          //高音3
			6'd21:key<=8'h7b;          //高音4
			6'd22:key<=8'h7e;          //高音2
			6'd23:key<=8'h7f;          //高音1
			6'd24:key<=8'hdf;		      //中音6
			6'd25:key<=8'h7e;          //高音2
			6'd26:key<=8'hef;          //中音5
			6'd27:key<=8'hdf;		      //中音6
			6'd28:key<=8'hf7;          //中音4，持续四个节拍
			6'd29:key<=8'hf7;
			6'd30:key<=8'hf7;
			6'd31:key<=8'hf7;
			6'd32:key<=8'hfd;          //中音2，持续两个节拍
			6'd33:key<=8'hfd;  
			6'd34:key<=8'hdf;          //中音6，持续两个节拍
			6'd35:key<=8'hdf;	
			6'd36:key<=8'hfb;          //中音3，持续两个节拍
			6'd37:key<=8'hfb;
			6'd38:key<=8'hdf;          //中音6，持续两个节拍
			6'd39:key<=8'hdf;
			6'd40:key<=8'hf7;          //中音4，持续两个节拍
			6'd41:key<=8'hf7;
			6'd42:key<=8'hef;          //中音5
			6'd43:key<=8'hdf;		      //中音6
			6'd44:key<=8'hef;          //中音5，持续两个节拍
			6'd45:key<=8'hef;   
			6'd46:key<=8'h7f;          //高音1，持续两个节拍
			6'd47:key<=8'h7f;
			6'd48:key<=8'h7e;          //高音2
			6'd49:key<=8'hdf;          //中音6
			6'd50:key<=8'h7d;          //高音3
			6'd51:key<=8'h7b;          //高音4
			6'd52:key<=8'h7d;          //高音3
			6'd53:key<=8'h7b;          //高音4
			6'd54:key<=8'h7e;          //高音2
			6'd55:key<=8'h7f;          //高音1
			6'd56:key<=8'h7e;          //高音2,持续八个节拍
			6'd57:key<=8'h7e;         
			6'd58:key<=8'h7e; 
			6'd59:key<=8'h7e; 
			6'd60:key<=8'h7e; 
			6'd61:key<=8'h7e; 
			6'd62:key<=8'h7e; 
			6'd63:key<=8'hff;
			default:key<=8'hff;
			endcase
		end
endmodule
