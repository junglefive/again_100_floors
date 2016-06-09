`timescale 1ns / 1ns
//
module Display(
    input clk,
	 input rst,
    input [15:0] cnt_data,
    output reg [3:0] bit_code=4'b1110,//选管
    output reg [7:0] seg_code=8'h00//选码
    );
	 parameter flag_seg=16'd65535;
    reg [15:0] cnt=16'b0;
	 reg clk_seg_tmp=0;
    always@(posedge clk)
	 begin
	     if(~rst)
		      cnt <= 1'b0;
		  else if (cnt==flag_seg)begin cnt<=0;clk_seg_tmp<=~clk_seg_tmp;end
		  else cnt <= cnt + 1'b1;
	 end
	wire clk_seg;
	BUFG U3451(.I (clk_seg_tmp), .O (clk_seg));	 
	always@(posedge clk_seg)
	 begin
	     if(~rst)
		      bit_code <= 4'b1110;
        else //if(cnt[15])		  
			begin
		      bit_code[3:1] <= bit_code[2:0];
				bit_code[0]   <= bit_code[3];
			end
	 end
	 
	 reg [3:0] type_temp; 
	 always@(*)
	 begin
	     case(bit_code)		      
				4'b1110:type_temp <= cnt_data[3:0];		//选管0				
            4'b1101:type_temp <= cnt_data[7:4];		//1				
            4'b1011:type_temp <= cnt_data[11:8];		//2		
            4'b0111:type_temp <= cnt_data[15:12];	//3
				default:type_temp <= cnt_data[3:0];		//0
		  endcase
	 end 
	 always@(*)
	 begin	
     case(type_temp)
		   4'h1:seg_code <= 8'b11111001;
			4'h2:seg_code <= 8'b10100100;
			4'h3:seg_code <= 8'b10110000;	
		   4'h4:seg_code <= 8'b10011001;
			4'h5:seg_code <= 8'b10010010;
			4'h6:seg_code <= 8'b10000010;
			4'h7:seg_code <= 8'b11111000;
			4'h8:seg_code <= 8'b10000000;
		   4'h9:seg_code <= 8'b10010000;
			4'hA:seg_code <= 8'b10001000;
			4'hB:seg_code <= 8'b10000011;			
         4'hC:seg_code <= 8'b11000110;
			4'hD:seg_code <= 8'b10100001;		
	      4'hE:seg_code <= 8'b10000110;
			4'hF:seg_code <= 8'b10001110;
			default:seg_code <= 8'b11000000;
		  endcase
	 end
	 
 endmodule
 