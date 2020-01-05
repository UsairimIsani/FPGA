/*
www.21eda.net
sz21eda@126.com
led  display
*/
module ledwater (clk_50M,dataout);

input clk_50M;     //clk 50M INPUT。
output [11:0] dataout;  //LED output，
reg [11:0] dataout;
reg [27:0] count; //counter

//分频计数器
always @ ( posedge clk_50M )
 begin
  count<=count+1;
 end

always @ (  count[27:24] )

 begin
  case ( count[27:24] )
  //  case ( count[27:24] )这一句希望初学者看明白,
  //  也是分频的关键
  //  只有在0的那一位 对应的LED灯才亮。
  0: dataout<=8'b111111111110;
  
  1: dataout<=8'b111111111100;
  
  2: dataout<=8'b111111111000;
  
  3: dataout<=8'b111111110000;
  
  4: dataout<=8'b111111100000;
  
  5: dataout<=8'b111111000000;
  
  6: dataout<=8'b101110000000;
    
  7: dataout<=8'b111100000000; 
  
  
  8: dataout<=8'b000000001111;
  
  9: dataout<=8'b000000011111;
  
  10: dataout<=8'b000000111111;
  
  11: dataout<=8'b000001111111;
  
  12: dataout<=8'b000011111111;
  
  13: dataout<=8'b000111111111;
    
  14: dataout<=8'b001111111111; 
  
  15: dataout<=8'b011111111111;

  endcase
 end
endmodule










