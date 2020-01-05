/*
www.21eda.net
sz21eda@126.com
Timer frequency.

LED6  LED7 	output	
*/

module DIV_F_F (clk_50M,led_out,f_led_out);
input   clk_50M;              //clk 50M
output  led_out;              // led out
output  f_led_out;            //led out

reg [24:0] count;  //Counter£¬25000000
reg [24:0] f_count;//Counter£¬12500000

reg  div_clk, f_div_clk;
reg  led_out, f_led_out;



//A second
always @ ( posedge clk_50M )
begin
if ( count==25000000 )
 begin
  div_clk<=~div_clk;
   count<=0;
  end
else
  count<=count+1;
  led_out<=~div_clk;
end

//0.5 second
always @ ( posedge clk_50M )
begin
if ( f_count==12500000 )
 begin
  f_div_clk<=~f_div_clk;
   f_count<=0;
  end
else
  f_count<=f_count+1;
  f_led_out<=~f_div_clk;
end

endmodule














