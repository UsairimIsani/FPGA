/*
--www.21eda.net
--Email: sz21eda@126.com
--I2C read write
--NET "data_in<0>"  LOC = "P16"  ;  SW1  INPUT
--NET "data_in<1>"  LOC = "P17"  ;  SW2
--NET "data_in<2>"  LOC = "P21"  ;  SW3
--NET "data_in<3>"  LOC = "P22"  ;  SW4

-- Digital tube display

*/

module i2c(clk,rst,data_in,scl,sda,wr_input,rd_input,lowbit,en,seg_data);

input clk,rst;
output scl;//I2C时钟线
inout  sda;//I2C数据线
input[3:0] data_in;//拨码开关输入想写入EEPROM的数据
input wr_input;//要求写的输入
input rd_input;//要求读的输入
output lowbit; //输出一个低电平给矩阵键盘的某一行
output[1:0] en;//数码管使能
output[7:0] seg_data;//数码管段数据
reg[7:0] seg_data;


reg scl;
reg[1:0] en;

reg[7:0] seg_data_buf;
reg[11:0] cnt_scan;
reg sda_buf;//sda输入输出数据缓存
reg link;   //sda输出标志
reg phase0,phase1,phase2,phase3;//一个scl时钟周期的四个相位阶段，将一个scl周期分为4段
//phase0对应scl的上升沿时刻，phase2对应scl的下降沿时刻，phase1对应从scl高电平的中间时刻，phase2对应从scl低电平的中间时刻，
reg[7:0] clk_div;//分频计数器
reg[1:0] main_state;
reg[2:0] i2c_state;//对i2c操作的状态
reg[3:0] inner_state;//i2c每一操作阶段内部状态
reg[19:0] cnt_delay;//按键延时计数器
reg start_delaycnt;//按键延时开始
reg[7:0] writeData_reg,readData_reg;//要写的数据的寄存器和读回数据的寄存器
reg[7:0] addr;//被操作的EEPROM字节的地址

parameter div_parameter=100;// 分频系数，AT24C02最大支持400K时钟速率

parameter start=4'b0000, //开始
		  first=4'b0001, //第1位
		  second=4'b0010,//第2位
		  third=4'b0011, //第3位
		  fourth=4'b0100, //第4位
		  fifth=4'b0101, //第5位
		  sixth=4'b0110, //第6位
		  seventh=4'b0111, //第7位
		  eighth=4'b1000, //第8位
		  ack=4'b1001,   //确认位
		  stop=4'b1010; //结束位
		
parameter ini=3'b000, //初始化EEPROM状态
		  sendaddr=3'b001, //发送地址状态
		  write_data=3'b010, //写数据状态?
		  read_data=3'b011, //读数据状态
		  read_ini=6'b100; //发送读信息状态

assign lowbit=0;
assign sda=(link)? sda_buf:1'bz;

always@(posedge clk or negedge rst)
begin
	if(!rst)
		cnt_delay<=0;
	else begin
		if(start_delaycnt) begin
			if(cnt_delay!=20'd800000)
				cnt_delay<=cnt_delay+1;
			else
				cnt_delay<=0;
		 end
	 end
end

always@(posedge clk or negedge rst)
begin
	if(!rst) begin
		clk_div<=0;
		phase0<=0;
		phase1<=0;
		phase2<=0;
		phase3<=0;
	 end
	else begin
		if(clk_div!=div_parameter-1)
			clk_div<=clk_div+1;
		else
			clk_div<=0;
		if(phase0)
			phase0<=0;	
		else if(clk_div==99) 
			phase0<=1;
		if(phase1)
			phase1<=0;
		else if(clk_div==24)
			phase1<=1;
		if(phase2)
			phase2<=0;
		else if(clk_div==49)
			phase2<=1;
		if(phase3)
			phase3<=0;
		else if(clk_div==74)
			phase3<=1;
	 end
end


///////////////////////////EEPROM操作部分/////////////
always@(posedge clk or negedge rst)
begin
	if(!rst) begin
		start_delaycnt<=0;
		main_state<=2'b00;
		i2c_state<=ini;
		inner_state<=start;
		scl<=1;
		sda_buf<=1;
		link<=0;
		writeData_reg<=5;
		readData_reg<=0;
		addr<=10;
	 end
	else begin
		case(main_state)
			2'b00: begin  //等待读写要求
				writeData_reg<=data_in;
				scl<=1;
				sda_buf<=1;
				link<=0;
				inner_state<=start;
				i2c_state<=ini;
				if((cnt_delay==0)&&(!wr_input||!rd_input))
						start_delaycnt<=1;
				else if(cnt_delay==20'd800000) begin
						start_delaycnt<=0;
						if(!wr_input)
							main_state<=2'b01;
						else if(!rd_input)
							main_state<=2'b10;
				 end
			 end
			2'b01: begin  //向EEPROM写入数据
				if(phase0)
					scl<=1;
				else if(phase2)
					scl<=0;
			
				case(i2c_state)
					ini: begin   //初始化EEPROM
						case(inner_state)
							start: begin
								if(phase1) begin
									link<=1;
									sda_buf<=0;
								 end
								if(phase3&&link) begin
									inner_state<=first;
									sda_buf<=1;
									link<=1;
								 end
							 end
							first: 
								if(phase3) begin
									sda_buf<=0;
									link<=1;
									inner_state<=second;
								 end
							second:
								if(phase3) begin
									sda_buf<=1;
									link<=1;
									inner_state<=third;
								 end
							third:
								if(phase3) begin
									sda_buf<=0;
									link<=1;
									inner_state<=fourth;
								 end
							fourth:
								if(phase3) begin
									sda_buf<=0;
									link<=1;
									inner_state<=fifth;
								 end
							fifth:
								if(phase3) begin
									sda_buf<=0;
									link<=1;
									inner_state<=sixth;
								 end
							sixth:
								if(phase3) begin
									sda_buf<=0;
									link<=1;
									inner_state<=seventh;
								 end
							seventh:
								if(phase3) begin
									sda_buf<=0;
									link<=1;
									inner_state<=eighth;
								 end
							eighth:
								if(phase3) begin
									link<=0;
									inner_state<=ack;
								 end
							ack: begin
								if(phase0) 
									sda_buf<=sda;
								if(phase1) begin
									if(sda_buf==1) 
										main_state<=3'b000;
								 end
								if(phase3) begin
									link<=1;
									sda_buf<=addr[7];
									inner_state<=first;
									i2c_state<=sendaddr;
								 end
							 end
						 endcase
					 end
					sendaddr: begin  //送相应字节的地址
						case(inner_state)
							first: 
								if(phase3) begin
									link<=1;
									sda_buf<=addr[6];
									inner_state<=second;
								 end
							second:
								if(phase3) begin
									link<=1;
									sda_buf<=addr[5];
									inner_state<=third;
								 end
							third:
								if(phase3) begin
									link<=1;
									sda_buf<=addr[4];
									inner_state<=fourth;
								 end
							fourth:
								if(phase3) begin
									link<=1;
									sda_buf<=addr[3];
									inner_state<=fifth;
								 end
							fifth:
								if(phase3) begin
									link<=1;
									sda_buf<=addr[2];
									inner_state<=sixth;
								 end
							sixth:
								if(phase3) begin
									link<=1;
									sda_buf<=addr[1];
									inner_state<=seventh;
								 end
							seventh:
								if(phase3) begin
									link<=1;
									sda_buf<=addr[0];
									inner_state<=eighth;
								 end
							eighth:
								if(phase3) begin
									link<=0;
									inner_state<=ack;
								 end
							ack: begin
								if(phase0) 
									sda_buf<=sda;
								if(phase1) begin
									if(sda_buf==1) 
										main_state<=3'b000;
								 end
								if(phase3) begin
									link<=1;
									sda_buf<=writeData_reg[7];
									inner_state<=first;
									i2c_state<=write_data;
								 end
							 end
						 endcase
					 end
					write_data: begin //写入数据
						case(inner_state)
							first: 
								if(phase3) begin
									link<=1;
									sda_buf<=writeData_reg[6];
									inner_state<=second;
								 end
							second:
								if(phase3) begin
									link<=1;
									sda_buf<=writeData_reg[5];
									inner_state<=third;
								 end
							third:
								if(phase3) begin
									link<=1;
									sda_buf<=writeData_reg[4];
									inner_state<=fourth;
								 end
							fourth:
								if(phase3) begin
									link<=1;
									sda_buf<=writeData_reg[3];
									inner_state<=fifth;
								 end
							fifth:
								if(phase3) begin
									link<=1;
									sda_buf<=writeData_reg[2];
									inner_state<=sixth;
								 end
							sixth:
								if(phase3) begin
									link<=1;
									sda_buf<=writeData_reg[1];
									inner_state<=seventh;
								 end
							seventh:
								if(phase3) begin
									link<=1;
									sda_buf<=writeData_reg[0];
									inner_state<=eighth;
								 end
							eighth:
								if(phase3) begin
									link<=0;
									inner_state<=ack;
								 end
							ack: begin
								if(phase0) 
									sda_buf<=sda;
								if(phase1) begin
									if(sda_buf==1) 
										main_state<=2'b00;
								 end
								else if(phase3) begin
									link<=1;
									sda_buf<=0;
									inner_state<=stop;
								 end
							 end
							stop: begin
								if(phase1)
									sda_buf<=1;
								if(phase3) 
									main_state<=2'b00;
							 end
						 endcase
					 end
					default:
						main_state<=2'b00;
				 endcase
			 end
			2'b10: begin  //读EEPROM
				if(phase0)
					scl<=1;
				else if(phase2)
					scl<=0;
					
				case(i2c_state)
				ini: begin   //初始化EEPROM
					case(inner_state)
						start: begin
							if(phase1) begin
								link<=1;
								sda_buf<=0;
							 end
							if(phase3&&link) begin
								inner_state<=first;
								sda_buf<=1;
								link<=1;
							 end
						 end
						first: 
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=second;
							 end
						second:
							if(phase3) begin
								sda_buf<=1;
								link<=1;
								inner_state<=third;
							 end
						third:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=fourth;
							 end
						fourth:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=fifth;
							 end
						fifth:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=sixth;
							 end
						sixth:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=seventh;
							 end
						seventh:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=eighth;
							 end
						eighth:
							if(phase3) begin
								link<=0;
								inner_state<=ack;
							 end
						ack: begin
							if(phase0) 
								sda_buf<=sda;
							if(phase1) begin
								if(sda_buf==1) 
									main_state<=2'b00;
							 end
							if(phase3) begin
								link<=1;
								sda_buf<=addr[7];
								inner_state<=first;
								i2c_state<=sendaddr;
							end
						 end
					endcase
				end
				sendaddr: begin  //送相应要读字节的地址
					case(inner_state)
						first: 
							if(phase3) begin
								link<=1;
								sda_buf<=addr[6];
								inner_state<=second;
							 end
						second:
							if(phase3) begin
								link<=1;
								sda_buf<=addr[5];
								inner_state<=third;
							 end
						third:
							if(phase3) begin
								link<=1;
								sda_buf<=addr[4];
								inner_state<=fourth;
							 end
						fourth:
							if(phase3) begin
								link<=1;
								sda_buf<=addr[3];
								inner_state<=fifth;
							 end
						fifth:
							if(phase3) begin
								link<=1;
								sda_buf<=addr[2];
								inner_state<=sixth;
							 end
						sixth:
							if(phase3) begin
								link<=1;
								sda_buf<=addr[1];
								inner_state<=seventh;
							 end
						seventh:
							if(phase3) begin
								link<=1;
								sda_buf<=addr[0];
								inner_state<=eighth;
							 end
						eighth:
							if(phase3) begin
								link<=0;
								inner_state<=ack;
							 end
						ack: begin
							if(phase0) 
								sda_buf<=sda;
							if(phase1) begin
								if(sda_buf==1) 
									main_state<=2'b00;
							 end
							if(phase3) begin
								link<=1;
								sda_buf<=1;
								inner_state<=start;
								i2c_state<=read_ini;
							 end
						 end
					 endcase
				 end
				read_ini: begin  //发出读要求
					case(inner_state)
						start: begin
							if(phase1) begin
								link<=1;
								sda_buf<=0;
							 end
							if(phase3&&link) begin
								inner_state<=first;
								sda_buf<=1;
								link<=1;
							 end
						 end
						first: 
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=second;
							 end
						second:
							if(phase3) begin
								sda_buf<=1;
								link<=1;
								inner_state<=third;
							 end
						third:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=fourth;
							 end
						fourth:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=fifth;
							 end
						fifth:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=sixth;
							 end
						sixth:
							if(phase3) begin
								sda_buf<=0;
								link<=1;
								inner_state<=seventh;
							end
						seventh:
							if(phase3) begin
								sda_buf<=1;
								link<=1;
								inner_state<=eighth;
							 end
						eighth:
							if(phase3) begin
								link<=0;
								inner_state<=ack;
							 end
						ack: begin
							if(phase0) 
								sda_buf<=sda;
							if(phase1) begin
								if(sda_buf==1) 
									main_state<=2'b00;
							 end
							if(phase3) begin
								link<=0;
								inner_state<=first;
								i2c_state<=read_data;
							 end
						 end
					endcase
				end
				read_data: begin  //读出数据
					case(inner_state)
						first: begin
							if(phase0)
								sda_buf<=sda;
							if(phase1) begin
								readData_reg[7:1]<=readData_reg[6:0];
								readData_reg[0]<=sda;
							 end
							if(phase3)
								inner_state<=second;
						 end
						second: begin
							if(phase0)
								sda_buf<=sda;
							if(phase1) begin
								readData_reg[7:1]<=readData_reg[6:0];
								readData_reg[0]<=sda;
							 end
							if(phase3)
								inner_state<=third;
						 end
						third: begin
							if(phase0)
								sda_buf<=sda;
							if(phase1) begin
								readData_reg[7:1]<=readData_reg[6:0];
								readData_reg[0]<=sda;
							 end
							if(phase3)
								inner_state<=fourth;							
						 end
						fourth: begin
							if(phase0)
								sda_buf<=sda;
							if(phase1) begin
								readData_reg[7:1]<=readData_reg[6:0];
								readData_reg[0]<=sda;
							 end
							if(phase3)
								inner_state<=fifth;							
						 end
						fifth: begin
							if(phase0)
								sda_buf<=sda;
							if(phase1) begin
								readData_reg[7:1]<=readData_reg[6:0];
								readData_reg[0]<=sda;
							 end
							if(phase3)
								inner_state<=sixth;							
						 end
						sixth: begin
							if(phase0)
								sda_buf<=sda;
							if(phase1) begin
								readData_reg[7:1]<=readData_reg[6:0];
								readData_reg[0]<=sda;
							 end
							if(phase3)
								inner_state<=seventh;								
						 end
						seventh: begin
							if(phase0)
								sda_buf<=sda;
							if(phase1) begin
								readData_reg[7:1]<=readData_reg[6:0];
								readData_reg[0]<=sda;
							 end
							if(phase3)
								inner_state<=eighth;								
						 end
						eighth: begin
							if(phase0)
								sda_buf<=sda;
							if(phase1) begin
								readData_reg[7:1]<=readData_reg[6:0];
								readData_reg[0]<=sda;
							 end
							if(phase3) 
								inner_state<=ack;
						 end
						ack: begin
							if(phase3) begin
								link<=1;
								sda_buf<=0;
								inner_state<=stop;
							 end
						 end
						stop: begin
							if(phase1) 
								sda_buf<=1;
							if(phase3) 
								main_state<=2'b00;
						 end
					 endcase
				 end
			 endcase
		end
	 endcase
 end
end
				
///////////////////////////数码管显示部分/////////////					
always@(posedge clk or negedge rst)
begin
	if(!rst) begin
		cnt_scan<=0;
		en<=2'b10;
	 end
	else begin
		cnt_scan<=cnt_scan+1;							
		if(cnt_scan==12'hfff)
			en<=~en;
	 end
end

always@(writeData_reg or readData_reg or en)
begin
	case(en)
		2'b10:
			seg_data_buf=writeData_reg;
		2'b01:
			seg_data_buf=readData_reg;
		default:
			seg_data_buf=0;
	 endcase
end

always@(seg_data_buf)
begin	
	case(seg_data_buf)
		8'b0000_0000:
			seg_data=8'b11000000;
		8'b0000_0001:
			seg_data=8'b11111001;
		8'b0000_0010:
			seg_data=8'b10100100;
		8'b0000_0011:
			seg_data=8'b10110000;
		8'b0000_0100:
			seg_data=8'b10011001;
		8'b0000_0101:
			seg_data=8'b10010010;
		8'b0000_0110:
			seg_data=8'b10000010;
		8'b0000_0111:
			seg_data=8'b11111000;
		8'b0000_1000:
			seg_data=8'b10000000;
		8'b0000_1001:
			seg_data=8'b10010000;
		8'b0000_1010:
			seg_data=8'b10001000;
		8'b0000_1011:
			seg_data=8'b10000011;
		8'b0000_1100:
			seg_data=8'b11000110;
		8'b0000_1101:
			seg_data=8'b10100001;
		8'b0000_1110:
			seg_data=8'b10000110;
		8'b0000_1111:
			seg_data=8'b10001110;
		default:
			seg_data=8'b1111_1111;
	 endcase
end
endmodule 
				

