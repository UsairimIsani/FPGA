/*
www.21eda.net
sz21eda@126.com
--a sub b , Digital tube display
--NET "a<0>"  LOC = "P24"  ; # SW 6
--NET "a<1>"  LOC = "P26"  ; # SW 7
--NET "a<2>"  LOC = "P27"  ; # SW 8

--NET "b<0>"  LOC = "P16"  ; # SW 1
--NET "b<1>"  LOC = "P17"  ; # SW 2
--NET "b<2>"  LOC = "P21"  ; # SW 3*/

module jianfa_sub(a,b,c,en);

input[2:0] a;  //sw input
input[2:0] b;  //sw input
output[7:0] c;  // Digital tube display
reg[7:0] c;
output en;

wire[3:0] c_tmp;

assign en=0;
assign c_tmp=a-b;

always@(c_tmp)
begin
	case(c_tmp)
		4'b0000:
			c=8'b11000000;
		4'b0001:
			c=8'b11111001;
		4'b0010:
			c=8'b10100100;
		4'b0011:
			c=8'b10110000;
		4'b0100:
			c=8'b10011001;
		4'b0101:
			c=8'b10010010;
		4'b0110:
			c=8'b10000010;
		4'b0111:
			c=8'b11111000;
		4'b1000:
			c=8'b10000000;
		4'b1001:
			c=8'b10010000;
		4'b1010:
			c=8'b10001000;
		4'b1011:
			c=8'b10000011;
		4'b1100:
			c=8'b11000110;
		4'b1101:
			c=8'b10100001;
		4'b1110:
			c=8'b10000110;
		4'b1111:
			c=8'b10001110;
	 endcase
end
endmodule 