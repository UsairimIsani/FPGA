`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:25:12 09/09/2010 
// Design Name: 
// Module Name:    VGA_DISPLAY 
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
module VGA_DISPLAY
(CLK,   
CTL,   
RED,   
GREEN,   
BLUE,   
HS,  
VS);   
  input CLK;   
  input [1:0] CTL;   
  output [2:0] RED,GREEN;   
  output [1:0] BLUE;   
  output HS,VS;   
     
  reg HS,VS;   
  reg [11:0] HS_CNT;// �м���   
  reg [9:0] VS_CNT;//������   
  reg [2:0] RED,GREEN;   
  reg [1:0] BLUE;   
  reg [2:0] RED_H=3'b000,GREEN_H=3'b000;   
  reg [1:0] BLUE_H=2'b00;   
  reg [2:0] RED_V=3'b000,GREEN_V=3'b000;   
  reg [1:0] BLUE_V=2'b00;   
  
     
  always @(posedge CLK)   
  begin   
      if(857<=HS_CNT&&HS_CNT<=977) HS<=0;//����HS�ź�   
       else HS<=1;   
      if(HS_CNT==1039)  begin                   
              HS_CNT<=0;    
              if(VS_CNT==665)    VS_CNT<=0;//VS����   
              else VS_CNT<=VS_CNT+1; end               
        else HS_CNT<=HS_CNT+1;//HS����   
        if(638<=VS_CNT&&VS_CNT<=644) VS<=0;//����VS�ź�   
        else VS<=1;             
     end   
  
     
  always @(posedge CLK)   
  begin   
    if((0<=HS_CNT&&HS_CNT<=266)&&(0<=VS_CNT&&VS_CNT<=599)) {RED_H,GREEN_H,BLUE_H} <=8'b0000_0011;   
    else if((267<=HS_CNT&&HS_CNT<=534)&&(0<=VS_CNT&&VS_CNT<=599)) {RED_H,GREEN_H,BLUE_H} <=8'b1110_0000;   
        else if((534<=HS_CNT&&HS_CNT<=799)&&(0<=VS_CNT&&VS_CNT<=599)) {RED_H,GREEN_H,BLUE_H} <=8'b0001_1100;   
           else  {RED_H,GREEN_H,BLUE_H} <=8'b0000_0000;   
  end   
  always @(posedge CLK)   
  begin   
    if((0<=HS_CNT&&HS_CNT<=799)&&(0<=VS_CNT&&VS_CNT<=199)) {RED_V,GREEN_V,BLUE_V} <=8'b0000_0011;   
    else if((0<=HS_CNT&&HS_CNT<=799)&&(200<=VS_CNT&&VS_CNT<=399)) {RED_V,GREEN_V,BLUE_V} <=8'b1110_0000;   
        else if((0<=HS_CNT&&HS_CNT<=799)&&(400<=VS_CNT&&VS_CNT<=599)) {RED_V,GREEN_V,BLUE_V} <=8'b0001_1100;   
           else  {RED_V,GREEN_V,BLUE_V} <=8'b0000_0000;   
  end   
     
     
  always @(CTL or RED_H or GREEN_H or BLUE_H or RED_V or GREEN_V or BLUE_V)   
  begin   
   case(CTL) //������ʾģʽ   
     2'b00: begin {RED,GREEN,BLUE} = {RED_H,GREEN_H,BLUE_H} ; end //����   
     2'b01: begin {RED,GREEN,BLUE} = {RED_V,GREEN_V,BLUE_V} ; end//����   
     2'b10: begin {RED,GREEN,BLUE} = {RED_H,GREEN_H,BLUE_H}+{RED_V,GREEN_V,BLUE_V} ; end //����   
     2'b11: begin {RED,GREEN,BLUE} = {RED_H,GREEN_H,BLUE_H}-{RED_V,GREEN_V,BLUE_V} ; end   
   endcase   
  end  

//��������CSDN���ͣ�ת�������������http://blog.csdn.net/chevroletss/archive/2010/01/15/5195987.aspx

endmodule
