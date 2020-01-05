/*
--www.21eda.net
--Email: sz21eda@126.com
--one Digital tube display 0 -> F 
*/
module one_smg_0_f (clk_50M,led_bit,dataout);

input clk_50M;      //clk 50M。
output [7:0] dataout;   //Digital tube display
output led_bit;         //

reg [7:0] dataout;
reg       led_bit;  
reg [28:0] count; //分频计数器
//reg [3:0] count_temp; //分频计数器

//分频计数器
always @ ( posedge clk_50M )
 begin
  count<=count+1;  //计数器自加
 end
 
always  led_bit <= 'b0; //是数码管的位选择处于导通状态

always @ ( count[28:25])

 begin

  case ( count[28:25] )
  //  case ( count[28:25] )这一句希望初学者看明白,
  //  也是分频的关键
  //  在数码管上面显示0到F
  4'b0000:dataout<=8'b11000000;  //0
  4'b0001:dataout<=8'b11111001;
  4'b0010:dataout<=8'b10100100;
  4'b0011:dataout<=8'b10110000;
  4'b0100:dataout<=8'b10011001;
  4'b0101:dataout<=8'b10010010;  
  4'b0110:dataout<=8'b10000010; 
  4'b0111:dataout<=8'b11111000;
  4'b1000:dataout<=8'b10000000;
  4'b1001:dataout<=8'b10010000;
  4'b1010:dataout<=8'b10001000;
  4'b1011:dataout<=8'b10000011;
  4'b1100:dataout<=8'b11000110;
  4'b1101:dataout<=8'b10100001;
  4'b1110:dataout<=8'b10000110;
  4'b1111:dataout<=8'b10001110;  //f
  endcase
 end
endmodule

