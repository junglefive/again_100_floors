`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:23 12/26/2014 
// Design Name: 
// Module Name:    VGAdisplay 
// Project Name: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGAdisplay(
input rst,  									/*��λ*//*�½�����Ч*/
input pause,									/*��ͣ*//*�ߵ�ƽ��Ч*/
input modle,
input [1:0]sw,									/*����ѡ����Ϸģʽ�����ģʽor����ģʽ*/
input clk_8hz,									/*1Hz*/	
input clk_50m, 								/*ʱ��*/
input face_RL,
input clk_25m,
input [10:0]  vector_x, 					/*��ǰvgaɨ������x*/
input [9:0]      vector_y,					/*��ǰvgaɨ������y*/
input signed [11:0] rel_xx,				/*�����ƶ��ź�*/
output reg         endgame=1'b0,			/*������Ϸ��־*/
output reg [2:0]   VGA_RED=3'b0,		/*���RED  �ź�*/
output reg [2:0] VGA_GREEN=3'b0,		/*���GREEN�ź�*/
output reg [1:0]  VGA_BLUE=2'b0, 	/*���BLUE �ź�*/
output 	  [7:0] key
    );
wire [7:0]	 colorOUT; 
reg  [7:0]	 color=8'h00;					/*��ɫRGB*/	
reg	   life_en=1'b1;
parameter VEC_X_799		=10'd799;
parameter VEC_y_599		=10'd599;
//---------------------֡--ˢ��ʱ������---------------
reg clk_frame_tmp=1'b0;
wire clk_frame;
always@(posedge clk_50m)
begin
	if(vector_x==799&&vector_y==599)clk_frame_tmp<=1'b1;
	else clk_frame_tmp<=1'b0;
end
BUFG U3300(.I(clk_frame_tmp),.O(clk_frame));
//-------------------------------------------------
//-------------------------/*����������ɫ����,����ɫֵ000*/-----------------------//
/*����߼���·�����б���ȫ���г�*/
always@(vector_x,vector_y,color)
	begin
		if ((vector_x>VEC_X_799)||(vector_y>VEC_y_599))  {VGA_RED,VGA_GREEN,VGA_BLUE}<=8'b00000000; 	/*����������ɫ����*/
		else if(vector_x<=80||vector_x>=720) {VGA_RED,VGA_GREEN,VGA_BLUE}<=8'b10001011; 	/*����ɫ��*/
		else if((80<vector_x && vector_x<100 || 700<vector_x && vector_x<720)&&				/*��Ļ���ҷ�����*/
					((   0<=vector_y && vector_y<80 )					
					||(100<vector_y && vector_y<180)
					||(200<vector_y && vector_y<280)
					||(300<vector_y && vector_y<380)
					||(400<vector_y && vector_y<480)
					||(500<vector_y && vector_y<580)
					)){VGA_RED,VGA_GREEN,VGA_BLUE}<=8'b00011010;										/*��Ļ���ҷ�����*/
		else {VGA_RED,VGA_GREEN,VGA_BLUE}<= color;													/*����ɫ��ֵ��RGB*/
	end
//-----------------------------------------------------------------------------------//
reg k1_en=1'b0,k2_en=1'b0,k3_en=1'b0;		/*�ϰ�1-3ʹ���ź�*/
reg k4_en=1'b0,k5_en=1'b1;						/*�ϰ�4-5ʹ���ź�*/
//
reg [9:0] cnt_k1=10'b0,cnt_k2=10'b0;		/*�ϰ�12��������*/
reg [9:0] cnt_k3=10'b0,cnt_k4=10'b0;		/*�ϰ�34��������*/
reg [9:0] cnt_k5=10'b0;							/*�ϰ�56��������*/
//
reg [9:0] cnt_life=10'd10;						/*��������*/
reg 		 touch_flag		=1'b0;				/*�Ƿ������ϰ���־*/	
parameter const_heiht	=5'd20;				/*�ϰ��߶�20*/
parameter const_580y 	=10'd579;			/*�ϰ�����ʱ����y����580�У�����579*/	
parameter obstacle1_x1  =10'd100;				/*�ϰ�1������x1*/
parameter obstacle1_x2	=10'd300;				/*�ϰ�1������x2*//*�ϰ�1����150*/
parameter obstacle2_x1  =10'd200;				/*�ϰ�2������x1*/
parameter obstacle2_x2	=10'd400;				/*�ϰ�2������x2*//*�ϰ�1����150*/
parameter obstacle3_x1  =10'd300;				/*�ϰ�3������x1*/
parameter obstacle3_x2	=10'd500;				/*�ϰ�3������x2*//*�ϰ�1����150*/
parameter obstacle4_x1  =10'd450;			/*�ϰ�4������x1*/
parameter obstacle4_x2	=10'd650;			/*�ϰ�4������x2*//*�ϰ�1����150*/
parameter obstacle5_x1  =10'd500;			/*�ϰ�5������x1*/
parameter obstacle5_x2	=10'd700;			/*�ϰ�5������x2*//*�ϰ�1����150*/
parameter htl_375_x1		=9'd375;				/*��̫�ǳ���ʱ����x1*/
parameter htl_425_x2		=9'd425;				/*��̫�ǳ���ʱ����x2*/
parameter htl_heiht_50	=6'd50;				/*��̫�Ǹ߶�50*/
/**/
reg [3:0] cnt_chang=3'd1;
reg [8:0] chang_num=9'd379;
reg [2:0] constant_v=3'd2;//	�ϰ������ٶ��л�
always@(posedge clk_50m)
	begin
		case(sw)
		  2'b00:begin constant_v=3'd2;cnt_chang= 4'd3; chang_num=9'd379; end
		  2'b01:begin constant_v=3'd3;cnt_chang= 4'd3; chang_num=9'd381; end
		  2'b10:begin constant_v=3'd4;cnt_chang= 4'd7; chang_num=9'd379; end
		  2'b11:begin constant_v=3'd5;cnt_chang= 4'd9; chang_num=9'd379; end
		default:begin constant_v=3'd2;cnt_chang= 4'd3; chang_num=9'd379; end
		endcase
	end
//-------------------�ϰ�1����-------------//
always@(posedge clk_50m or negedge rst)
begin
	if(~rst) begin cnt_k1 <=10'b0;end					
		else
			begin
/*�ϰ�ʹ��*/ 	if(k1_en&&vector_x==VEC_X_799&&vector_y==VEC_y_599)/*��k1_en��Ч��cnt_k1��ʼ������ÿ֡+2*/
						begin												/*���������Ϸ�ʱ����0*/	/*�ϰ�1��ͣ*/	
							if(pause)begin cnt_k1 <= cnt_k1;end		/*��ͣ*/
							else
								begin
								if(const_580y-cnt_k1==cnt_chang) cnt_k1 <=10'b0;
								else begin cnt_k1<= cnt_k1+constant_v;end
								end
						end
				else begin cnt_k1 <= cnt_k1;end
			end
end
//--------------------------------------//
//-------------------�ϰ�2����-------------//
always@(posedge clk_50m or negedge rst)
begin
	if(~rst) begin cnt_k2<=10'b0;end	
	else
		begin
			if(k2_en&&vector_x==VEC_X_799&&vector_y==VEC_y_599)/*��k2_en��Ч��cnt_k2��ʼ������ÿ֡+2*/
				begin												/*���������Ϸ�ʱ����0*/	
					if(pause)begin cnt_k2<=cnt_k2;end			/*��ͣ*/
					else
						begin
							if(const_580y-cnt_k2==cnt_chang) cnt_k2 <=10'b0;
							else begin cnt_k2<=cnt_k2+constant_v; end
						end
				end
			else begin cnt_k2 <= cnt_k2;end	
		end
end
//----------------------------------------//
//-------------------�ϰ�3����-------------//
always@(posedge clk_50m or negedge rst)
begin
	if(~rst) begin cnt_k3<=10'b0;end	
	else
		begin
			if(k3_en&&vector_x==VEC_X_799&&vector_y==VEC_y_599)/*��k3_en��Ч��cnt_k3��ʼ������ÿ֡+3*//*����*/
				begin												/*���������Ϸ�ʱ����0*/
					if(pause)begin	cnt_k3<=cnt_k3;end		/*��ͣ*/
					else
						begin
							if(const_580y-cnt_k3==cnt_chang)cnt_k3<=10'b0;/*����*/
							else begin  cnt_k3<=cnt_k3+constant_v;	end
						end
				end
			else begin cnt_k3<= cnt_k3;end			
		end
end
//----------------------------------------//
//-------------------�ϰ�4����-------------//
always@(posedge clk_50m or negedge rst)
begin
	if(~rst) begin cnt_k4<=10'b0;end	
	else
		begin
			if(k4_en&&vector_x==VEC_X_799&&vector_y==VEC_y_599)/*��k4_en��Ч��cnt_k3��ʼ������ÿ֡+2*/
				begin												/*���������Ϸ�ʱ����0*/
					if(pause)begin cnt_k4 <= cnt_k4;end/*��ͣ*/
					else
						begin
							if(const_580y-cnt_k4==cnt_chang) 	cnt_k4 <=10'b0;
							else begin  cnt_k4<= cnt_k4+constant_v;end
						end
				end
			else begin cnt_k4 <= cnt_k4;end		
		end
end
//----------------------------------------//
//-------------------�ϰ�5����-------------//
always@(posedge clk_50m or negedge rst)
begin
	if(~rst)begin cnt_k5 <=10'b0;end	
	else
		begin
			if(k5_en&&vector_x==VEC_X_799&&vector_y==VEC_y_599)/*��k5_en��Ч��cnt_k3��ʼ������ÿ֡+2*/
				begin												/*���������Ϸ�ʱ����0*/
					if(pause)begin cnt_k5 <= cnt_k5; end				/*��ͣ*/
					else
						begin
							if(const_580y-cnt_k5==cnt_chang) cnt_k5 <=10'b0;
							else 	begin cnt_k5<= cnt_k5+constant_v;end
						end
				end
			else begin cnt_k5 <= cnt_k5;end		
		end
end
//-----------------------------------------------------------------------------//
//-------------------��������----------------------------------------------------//
always@(posedge clk_50m or negedge rst)
begin
	if(~rst) begin cnt_life<=10'd10;end	
	else
		begin
/*����*/ 	if(!touch_flag && life_en && vector_x==0 && vector_y==0) /*������ʹ����û�����ϰ���cnt_life��ʼ������ÿ֡+2*/
				begin
					if(pause)	cnt_life <=cnt_life;		/*��ͣ*/
					else
						begin
							if(const_heiht+cnt_life<=VEC_y_599)cnt_life <= cnt_life+constant_v;//�½�
							else cnt_life <=10'd10;
						end
				end					
/*����*/ 	else if ( touch_flag && life_en && vector_x==0 && vector_y==0) /*������ʹ���������ϰ���cnt_life��ʼ������ÿ֡-2*/
				begin
					if(pause)	cnt_life <=cnt_life;		/*��ͣ*/
					else
						begin
						if(const_heiht+cnt_life<=VEC_y_599)cnt_life <= cnt_life-constant_v;//����
							else cnt_life <=10'd10;
						end
				end
			else cnt_life <=cnt_life;		
		end
end
//------------------------���������-----------------------------------------------//
reg [1:0]rand_num=2'b00;
reg [3:0]cnt_rand=4'b0000;
reg 	clk_flg=1'b0;	

//--------------���˫���ش���-------------------
//wire pos_clk_flg;
//wire neg_clk_flg;
//pose_neg_trace U330 (
//		.btn(clk_flg), 
//		.pos_btn (pos_clk_flg ),
//		.neg_btn(neg_clk_flg)
//	);
always@(posedge clk_flg)
		begin
			if(cnt_rand==4'd15)cnt_rand<=4'd0;
			else cnt_rand<=cnt_rand+1'b1;
		end
always@*
begin
		//0,3,7,11 :rand_num<=2'd0;
		//4,5,9,14 :rand_num<=2'd1;
		//2,6,10,15:rand_num<=2'd2;
		//1,8,12,13:rand_num<=2'd3;
		case(cnt_rand)
			4'd0 :rand_num=2'd0;
			4'd1 :rand_num=2'd3;
			4'd2 :rand_num=2'd2;
			4'd3 :rand_num=2'd0;
			4'd4 :rand_num=2'd1;
			4'd5 :rand_num=2'd1;
			4'd6 :rand_num=2'd2;
			4'd7 :rand_num=2'd0;
			4'd8 :rand_num=2'd3;
			4'd9 :rand_num=2'd1;
			4'd10:rand_num=2'd2;
			4'd11:rand_num=2'd0;
			4'd12:rand_num=2'd3;
			4'd13:rand_num=2'd3;
			4'd14:rand_num=2'd1;
			4'd15:rand_num=2'd2;
		 default:rand_num=2'd1;
		endcase
end
//----------------------------------------------------------------------//	
reg [1:0] rand_tmp=2'b00;
//reg   clk_flg_flg=1'b0;

always@(posedge clk_flg)
begin	
	rand_tmp<=rand_num;
	//clk_flg_flg=1'b0;
end
//-----------------------------------------------------------

//----------------------------------------------------------
//--------------------------�ϰ�5------------------------------//
always@(posedge clk_frame)
begin
	if (~rst) begin k5_en<=1'b1;k4_en<=1'b0;k3_en<=1'b0;k2_en<=1'b0;k1_en<=1'b0;end
	else
		begin	//
				//clk_flg<=1'b0;
				//if(clk_flg_flg==0)clk_flg=1'b0; else clk_flg=clk_flg;
				//�ϰ�5
				if((k1_en&&(rand_tmp==3)&&(const_580y-cnt_k1==chang_num))
					||
					(k2_en&&(rand_tmp==2)&&(const_580y-cnt_k2==chang_num))
					||
					(k3_en&&(rand_tmp==1)&&(const_580y-cnt_k3==chang_num))
					||
					(k4_en&&(rand_tmp==0)&&(const_580y-cnt_k4==chang_num))
					//||
					//(k5_en && const_580y-cnt_k5==cnt_chang)
					)begin
						//clk_flg=1'b1;
						//if((k5_en && const_580y-cnt_k5==cnt_chang))begin k5_en=1'b0;end
						begin clk_flg<=~clk_flg;k5_en<=1'b1;end
					 end
				else if((k5_en && const_580y-cnt_k5==cnt_chang))begin k5_en<=1'b0;clk_flg<=~clk_flg;end
				else begin  k5_en<=k5_en;end
				//�ϰ�4
				if((k3_en&&(rand_tmp==0)&&(const_580y-cnt_k3==chang_num))
					||
					(k2_en&&(rand_tmp==1)&&(const_580y-cnt_k2==chang_num))
					||
					(k1_en&&(rand_tmp==2)&&(const_580y-cnt_k1==chang_num))
					||
					(k5_en&&(rand_tmp==3)&&(const_580y-cnt_k5==chang_num))
					//||
					//(k4_en && const_580y-cnt_k4==cnt_chang)
				)begin
					//clk_flg=1'b1;
					//if((k4_en && const_580y-cnt_k4==cnt_chang))begin k4_en=1'b0;end
					 begin clk_flg<=~clk_flg;k4_en<=1'b1;end
				 end
				 else if((k4_en && const_580y-cnt_k4==cnt_chang))begin k4_en<=1'b0;clk_flg<=~clk_flg;end
				else begin  k4_en<=k4_en;end
				//�ϰ�3
				if((k1_en&&(rand_tmp==1)&&(const_580y-cnt_k1==chang_num))
					||
					(k4_en&&(rand_tmp==3)&&(const_580y-cnt_k4==chang_num))
					||
					(k2_en&&(rand_tmp==0)&&(const_580y-cnt_k2==chang_num))
					||
					(k5_en&&(rand_tmp==2)&&(const_580y-cnt_k5==chang_num))
					//||
					//(k3_en&&(const_580y-cnt_k3==cnt_chang))
					)begin
						//clk_flg=1'b1;
						//if(k3_en&&(const_580y-cnt_k3==cnt_chang))begin k3_en=1'b0;end
						 begin clk_flg<=~clk_flg;k3_en<=1'b1;end
					 end
				else if(k3_en&&(const_580y-cnt_k3==cnt_chang))begin k3_en<=1'b0;clk_flg<=~clk_flg;end
				else begin  k3_en<=k3_en; end
				//�ϰ�2
				if((k4_en&&(rand_tmp==2)&&(const_580y-cnt_k4==chang_num))
					||
					(k3_en&&(rand_tmp==3)&&(const_580y-cnt_k3==chang_num))
					||
					(k1_en&&(rand_tmp==0)&&(const_580y-cnt_k1==chang_num))
					||
					(k5_en&&(rand_tmp==1)&&(const_580y-cnt_k5==chang_num))
					//||
					//(k2_en&&(const_580y-cnt_k2==cnt_chang))
				)begin
					//clk_flg=1'b1;
					//if(k2_en&&(const_580y-cnt_k2==cnt_chang))begin k2_en=1'b0;end
					begin clk_flg<=~clk_flg;k2_en<=1'b1;end
				 end
				else if(k2_en&&(const_580y-cnt_k2==cnt_chang))begin k2_en<=1'b0;clk_flg<=~clk_flg;end
				else begin  k2_en<=k2_en;end
				//�ϰ�1
				if((k2_en&&(rand_tmp==3)&&(const_580y-cnt_k2==chang_num))
					||
					(k4_en&&(rand_tmp==1)&&(const_580y-cnt_k4==chang_num))
					||
					(k3_en&&(rand_tmp==2)&&(const_580y-cnt_k3==chang_num))
					||
					(k5_en&&(rand_tmp==0)&&(const_580y-cnt_k5==chang_num))
					//||
					//(k1_en && const_580y-cnt_k1==cnt_chang)
					)begin
						//clk_flg=1'b1;
						//if(k1_en && const_580y-cnt_k1==cnt_chang)begin k1_en=1'b0;end
						begin clk_flg<=~clk_flg;k1_en<=1'b1;end
					end
				else if(k1_en && const_580y-cnt_k1==cnt_chang)begin k1_en<=1'b0;clk_flg<=~clk_flg;end
				else begin  k1_en<=k1_en;end
		end	
end
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
/*����ѡ����*/
reg [5:0] cnt_music  =6'b000000;					//���ּ�����
reg [5:0] cnt_music_b=6'b000000;					//��������ģʽ���ּ�����
reg [5:0] cnt_music_f=6'b000000;					//����ģʽ���ּ�����
reg flg_m=1'b0;										//����ģʽ������־
reg flg_m_f=1'b0;										//���ڶ�flg_m����
reg cnt_music01=0;
//--------------------��������ģʽ���ּ���--------------------------//
always@(posedge clk_8hz)
	begin
		if(sw==2'b00)
			begin
				cnt_music01<=cnt_music01+1'b1;
				if(cnt_music01==1'b1)cnt_music_b<=cnt_music_b+1'b1;
				else cnt_music_b<=cnt_music_b;
				end	
		else cnt_music_b<=cnt_music_b+1'b1;//ÿ1/4��0.25��
	end
//-------------------------����ģʽ���ּ���----------------------------------------//
reg cnt_music02=1'b0;
always@(posedge clk_8hz)
	begin
		if(flg_m)
		begin
			flg_m_f=1'b0;
			if(sw==2'b00)
				begin
					cnt_music02<=cnt_music02+1'b1;
					if(cnt_music02==1)cnt_music_f<=cnt_music_f+1'b1;
					else cnt_music_f<=cnt_music_f;
				end	
			else cnt_music_f<=cnt_music_f+1'b1;//ÿ1/4��0.25��

		//cnt_music_f<=cnt_music_f+1'b1;
	 end//�����ϰ�����Ч
		else cnt_music_f<=cnt_music_f;
	end	
//-------------------------����ģʽѡ��-------------------------------------------//
always@(posedge clk_50m)
	begin
		if(~modle)cnt_music<=cnt_music_b;//modle=0,��Ϊ��������ģʽ
		else 		cnt_music<=cnt_music_f;//modle=1,��Ϊ��������ģʽ
	end
//----------����ģ��------------------------------------------------------//
	music U331 ( 
		.key(key),
		.cnt_music(cnt_music)
	);
//-----------------------------------------------------------------------------//
//-----------------------------------------------------------//
reg up_flg=1'b0;//��̫����������־
/*����-----------��ģ��---------��̫��----------��ʾ----------��̫������------------*/
huitailang U332 (
		.rel_xx(rel_xx), 
		.cnt_life(cnt_life), 
		.up_flg(up_flg),
		.vector_x(vector_x), 
		.vector_y(vector_y), 
		.clk_50m(clk_50m), 
		.color(colorOUT),
		.face_RL(face_RL)
);
//------------------------------��ʾ-------------------------------------//
always@*	
	begin
		if(!endgame)
			begin
				if(/*�ϰ���ʾ��������*/
						k1_en
						&&(obstacle1_x1+cnt_k1<vector_x && vector_x<obstacle1_x2+cnt_k1)/*X*/
						&&(const_580y+const_heiht-cnt_k1>vector_y&&vector_y>const_580y-cnt_k1)/*Y */
						|| /*�ϰ�1*/
						k2_en
						&&(obstacle2_x1<vector_x && vector_x<obstacle2_x2)/*X*/
						&&(const_580y+const_heiht-cnt_k2>vector_y&&vector_y>const_580y-cnt_k2)/*Y*/
						|| /*�ϰ�2*/
						k3_en
						&&(obstacle3_x1<vector_x && vector_x<obstacle3_x2)/*X*/
						&&(const_580y+const_heiht-cnt_k3>vector_y&&vector_y>const_580y-cnt_k3)/*Y*/
						||/*�ϰ�3*/
						k4_en
						&&(obstacle4_x1<vector_x && vector_x<obstacle4_x2)/*X*/
						&&(const_580y+const_heiht-cnt_k4>vector_y&&vector_y>const_580y-cnt_k4)/*Y*/
						||/*�ϰ�4*/
						k5_en
						&&(obstacle5_x1-cnt_k5<vector_x && vector_x<obstacle5_x2-cnt_k5)/*X*/
						&&(const_580y+const_heiht-cnt_k5>vector_y&&vector_y>const_580y-cnt_k5)/*Y*/
							/*�ϰ�5*/
						)color <= 8'b00011100;/*�ϰ���ʾ��ɫ*/
				else if((htl_375_x1-rel_xx<=vector_x && vector_x<=htl_425_x2-rel_xx)
						&&(cnt_life <=vector_y && vector_y<cnt_life+50))
							color<=colorOUT;/*�˴�X��Y��һ�����أ�����֮������ж�*/
				else color<=8'hff;//��ɫ����//
			end
	else/*endgame��Ч---------��Ϸ����------��ʾ-----------------END--------------------*/
		begin/*��ʾEND*/
			 //ԭ���ѻ�ľ//
			if(/*��ʾEND��ʼ*/
					200<=vector_x && vector_x<225 && 200 <vector_y && vector_y<400||/*��*/
					225<=vector_x && vector_x<300 && 200 <vector_y && vector_y<225||/*��*/
					225<=vector_x && vector_x<300 && 280 <vector_y && vector_y<315||/*��*/
					225<=vector_x && vector_x<300 && 375<=vector_y && vector_y<400	/*��*//*E*/
					||
					350<=vector_x && vector_x<375 && 200<vector_y && vector_y<400||/*��*/
					425<=vector_x && vector_x<450 && 200<vector_y && vector_y<400||/*��*/
					350<=vector_x && vector_x<450 && 200<vector_y && vector_y<400&&/*б��*//*N*/
					(4*vector_x-vector_y >=1260 && 4*vector_x-vector_y<1320 )
					||
					500<=vector_x && vector_x<525 && 200<vector_y && vector_y<400||/*��*/
					vector_x>=525 
					&& 
					(7000<((vector_x-500)*(vector_x-500)+(vector_y-300)*(vector_y-300))
					&&
					((vector_x-500)*(vector_x-500)+(vector_y-300)*(vector_y-300))<10200)/*��Բ*//*D*/
					)/*��ʾEND��������*/
					color <= 8'hdc;
					else	color <= 8'hff;//��ɫ����
		end/*endgame��Ч*/
	end
//---------------------------------------------------------------------------------------------//	
/*����ʹ�ܱ�־*/
reg life_en_flg=1'b1;
//---------------------------/*��δ����ʱ�ж�С���Ƿ������ϰ���*-------------------------------------//
always@(posedge clk_50m)
begin
			if(flg_m_f==0)begin flg_m<=1'b0; end  //else begin flg_m<=flg_m; end
			if( life_en_flg&&
				((obstacle1_x1+cnt_k1-25<=htl_375_x1-rel_xx && htl_425_x2-rel_xx<=obstacle1_x2+cnt_k1+25)
				&& (const_580y-cnt_k1-cnt_life-htl_heiht_50<=8))/*�����ϰ�1*/
				)begin touch_flag<=1'b1;flg_m<=1'b1; end/*��־��1*/
			//else begin touch_flag<=1'b0;flg_m<=1'b0; end
			//
			else if( life_en_flg&&	
				((obstacle2_x1-25<=htl_375_x1-rel_xx && htl_425_x2-rel_xx<=obstacle2_x2+25)
				&& (const_580y-cnt_k2-cnt_life-htl_heiht_50<=8))/*�����ϰ�2*/
				)begin touch_flag<=1'b1;flg_m<=1'b1; end/*��־��1*/
			//else begin touch_flag<=1'b0;flg_m<=1'b0; end
			//
			else if( life_en_flg&&
				((obstacle3_x1-25<=htl_375_x1-rel_xx && htl_425_x2-rel_xx<=obstacle3_x2+25) 
				&& (const_580y-cnt_k3-cnt_life-htl_heiht_50<=8))/*�����ϰ�3*/
				)begin touch_flag<=1'b1;flg_m<=1'b1; end/*��־��1*/
			//else begin touch_flag<=1'b0;flg_m<=1'b0; end
			//
			else if( life_en_flg&&
				((obstacle4_x1-25<=htl_375_x1-rel_xx && htl_425_x2-rel_xx<=obstacle4_x2+25) 
				&& (const_580y-cnt_k4-cnt_life-htl_heiht_50<=8))/*�����ϰ�4*/
				)begin touch_flag<=1'b1;flg_m<=1'b1; end/*��־��1*/
			//else begin touch_flag<=1'b0;flg_m<=1'b0; end
			//
			else if(life_en_flg&&
				((obstacle5_x1-cnt_k5-25<=htl_375_x1-rel_xx && htl_425_x2-rel_xx<=obstacle5_x2-cnt_k5+25) 
				&& (const_580y-cnt_k5-cnt_life-htl_heiht_50<=8))/*�����ϰ�5*/
				)begin touch_flag<=1'b1;flg_m<=1'b1; end/*��־��1*/
			//
			else begin	touch_flag<=1'b0;end
end
//----------------------------------------------------------------------------------------//
//----------------------------------/*�ж���Ϸ�Ƿ����*/-------------------------------------//
always @(posedge clk_50m or negedge rst)
	begin
		if (~rst)											//��λ*/		
			begin 											//ע�⸴λʱ���������ĳ�ʼֵ
				life_en<=1'b1;							//��λ�� 
				endgame<=1'b0;
				life_en_flg<=1'b1;
				up_flg<=1'b0;
			end
		else
			begin
				 if(life_en&&cnt_life<6)begin life_en_flg<=1'b0;up_flg<=1'b1;end
				 else if( life_en&&((cnt_life>577))) begin life_en<=1'b0;life_en_flg<=1'b0;endgame<=1'b1;end	/*�������£��������Ϸ*/
				 else begin life_en_flg<=life_en_flg;up_flg<=up_flg;life_en<=life_en;endgame<=endgame;end//���������ı����ֵ
			end
	end
//----------------------------------------------------------------------------------------//
/*ģ�����*/	
endmodule
