/*
www.21eda.net
sz21eda@126.com
MUX  
NET "a"  LOC = "P22"  ;    	 SW4 SELECT

NET "a[0]"  LOC = "P16"  ;     SW1
NET "a[1]"  LOC = "P17"  ;     SW2

NET "b[0]"  LOC = "P26"  ;
NET "b[1]"  LOC = "P27"  ;

NET "c[0]"  LOC = "P81"  ;
NET "c[1]"  LOC = "P80"  ;
NET "c[2]"  LOC = "P79"  ;
NET "c[3]"  LOC = "P78"  ;
NET "c[4]"  LOC = "P75"  ;
NET "c[5]"  LOC = "P74"  ;
NET "c[6]"  LOC = "P12"  ;
NET "c[7]"  LOC = "P14"  ;
NET "en"  LOC = "P82"  ;
*/

module mux(a,b,c,d,en);

input a;        //拨码开关的 4     作为A的输入
                //多路选择器，a为1则选择b，为0则选择c
              
input[2:0]b;    //拨码开关的 1 2 3 作为B的输入
input[2:0]c;    //拨码开关的 6 7 8 作为C的输入
output[7:0] d;  //7段码显示的段码

reg[7:0] d;
output en;

wire[3:0] d_tmp;

assign en=0;

assign d_tmp=a? b:c;

always@(d_tmp)
begin

//下面是7段码显示的段码
	case(d_tmp)
		4'b0000:
			d=8'b11000000;
		4'b0001:
			d=8'b11111001;
		4'b0010:
			d=8'b10100100;
		4'b0011:
			d=8'b10110000;
		4'b0100:
			d=8'b10011001;
		4'b0101:
			d=8'b10010010;
		4'b0110:
			d=8'b10000010;
		4'b0111:
			d=8'b11111000;
		4'b1000:
			d=8'b10000000;
		4'b1001:
			d=8'b10010000;
		4'b1010:
			d=8'b10001000;
		4'b1011:
			d=8'b10000011;
		4'b1100:
			d=8'b11000110;
		4'b1101:
			d=8'b10100001;
		4'b1110:
			d=8'b10000110;
		4'b1111:
			d=8'b10001110;
	 endcase
end
endmodule 