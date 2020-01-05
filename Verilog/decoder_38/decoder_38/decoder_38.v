/*
www.21eda.net
sz21eda@126.com

NET "key_in<0>"  LOC = "P16"  ; SW1
NET "key_in<1>"  LOC = "P17"  ; SW2
NET "key_in<2>"  LOC = "P21"  ; SW3
*/

module decoder_38(out,key_in);

output[7:0] out;     // LED INPUT
input[2:0] key_in;   // SW INPUT

reg[7:0] out;
always @(key_in)

begin
case(key_in)
                        
3'd0: out=8'b11111110;  //LED作为状态显示,低电平有效
3'd1: out=8'b11111101;
3'd2: out=8'b11111011;
3'd3: out=8'b11110111;
3'd4: out=8'b11101111;
3'd5: out=8'b11011111;
3'd6: out=8'b10111111;
3'd7: out=8'b01111111;

endcase 
end 
endmodule
