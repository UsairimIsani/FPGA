/*
--www.21eda.net
--Email: sz21eda@126.com
--one Digital tube display 
*/
module one_smg_led (led_bit,dataout);

output [7:0] dataout;   //
output led_bit;         //one Digital tube display 

reg [7:0] dataout;
reg       led_bit;  

 always  led_bit <= 'b0; //

 always  dataout<=8'b11000000; //�޸�7���룬������ʾ��ͬ���ַ�
                       //��ʵ���ʼ�����������ʾ0

endmodule

