/*
www.21eda.net
sz21eda@126.com
Division 
Digital tube display
NET "a[0]"  LOC = "P16"  ; SW1
NET "a[1]"  LOC = "P17"  ; SW2
NET "a[2]"  LOC = "P21"  ; SW3

NET "b[0]"  LOC = "P24"  ; SW5
NET "b[1]"  LOC = "P26"  ; SW6
NET "b[2]"  LOC = "P27"  ; SW7
*/


module div(a,b,c,en);

input[2:0] a,b;//SW INPUT
output[7:0] c;  //Digital tube display
reg[7:0] c;
output[7:0] en;

reg[3:0] c_tmp;//商（整数部分）
reg[2:0] temp_reg;//计算的中间结果寄存器
integer i;

assign en=0;

always@(a or b or temp_reg)
begin
	temp_reg=0;
	c_tmp=0;
	if(b==0)
		c_tmp=4'he;
	else begin
		if(a[2]>=b) begin
			c_tmp[2]=1;
			temp_reg[2]=a[2]-b;
		 end
		else begin
			c_tmp[2]=0;
			temp_reg[2]=a[2];
		 end
		if({temp_reg[2],a[1]}>=b) begin
			c_tmp[1]=1;
			temp_reg[2:1]={temp_reg[2],a[1]}-b;
		 end
		else begin
			c_tmp[1]=0;
			temp_reg[2:1]={temp_reg[2],a[1]};
		 end
		if({temp_reg[2:1],a[0]}>=b) begin
			c_tmp[0]=1;
			temp_reg=0;
		 end
		else begin
			c_tmp[0]=0;
			temp_reg=0;
		end
	 end
end
			
			
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