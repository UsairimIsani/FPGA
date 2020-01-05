/*
--www.21eda.net
--Email: sz21eda@126.com
*/

module div_f (clk_50M,led_out);
input   clk_50M;       //clk 50M
output  led_out;    

reg [24:0] count;  //counter
reg  div_clk;     //
reg  led_out;



//one second
always @ ( posedge clk_50M )
begin
if ( count==25000000 )
 begin
  div_clk<=~div_clk;
   count<=0;
  end
else
  count<=count+1;
  led_out<=~div_clk;   //利用分频计数器得到显示一秒的闪烁效果
end 

endmodule














