/*
www.21eda.net
sz21eda@126.com
NET "key[0]"  LOC = "P111"  ;  k1
NET "key[1]"  LOC = "P112"  ;  k2
NET "key[2]"  LOC = "P114"  ;  k3
NET "key[3]"  LOC = "P15"  ;   k4

Digital tube display
*/

module key_led(clk_50M,key,duan_ma,wei_ma);

input clk_50M;         //CLK  50M��
input [3:0] key;       //KEY INPUT
output [3:0] wei_ma;   //
output [7:0] duan_ma;  //Digital tube display

wire [3:0] key;
reg [7:0] duan_ma;
reg [3:0] wei_ma;
reg [3:0] key_temp;  //������һ���Ĵ���

always @ (posedge clk_50M )
begin
key_temp<=key;     //�Ѽ����ֵ�����Ĵ���
case ( key_temp )
4'b1110:duan_ma<=8'b1111_1001;    //����//KEY1����ȥ��ʾ1
4'b1101:duan_ma<=8'b1010_0100;    //����//KEY2����ȥ��ʾ2
4'b1011:duan_ma<=8'b1011_0000;    //����//KEY3����ȥ��ʾ3
4'b0111:duan_ma<=8'b1001_1001;    //����//KEY4����ȥ��ʾ4
endcase
end


always @ ( posedge clk_50M )
begin
case( key_temp )
4'b0111:wei_ma<=4'b0111;  //λѡ�ź�
4'b1011:wei_ma<=4'b1011;
4'b1101:wei_ma<=4'b1101;
4'b1110:wei_ma<=4'b1110;
endcase
end
endmodule


