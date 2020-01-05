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
output scl;//I2Cʱ����
inout  sda;//I2C������
input[3:0] data_in;//���뿪��������д��EEPROM������
input wr_input;//Ҫ��д������
input rd_input;//Ҫ���������
output lowbit; //���һ���͵�ƽ��������̵�ĳһ��
output[1:0] en;//�����ʹ��
output[7:0] seg_data;//����ܶ�����
reg[7:0] seg_data;


reg scl;
reg[1:0] en;

reg[7:0] seg_data_buf;
reg[11:0] cnt_scan;
reg sda_buf;//sda����������ݻ���
reg link;   //sda�����־
reg phase0,phase1,phase2,phase3;//һ��sclʱ�����ڵ��ĸ���λ�׶Σ���һ��scl���ڷ�Ϊ4��
//phase0��Ӧscl��������ʱ�̣�phase2��Ӧscl���½���ʱ�̣�phase1��Ӧ��scl�ߵ�ƽ���м�ʱ�̣�phase2��Ӧ��scl�͵�ƽ���м�ʱ�̣�
reg[7:0] clk_div;//��Ƶ������
reg[1:0] main_state;
reg[2:0] i2c_state;//��i2c������״̬
reg[3:0] inner_state;//i2cÿһ�����׶��ڲ�״̬
reg[19:0] cnt_delay;//������ʱ������
reg start_delaycnt;//������ʱ��ʼ
reg[7:0] writeData_reg,readData_reg;//Ҫд�����ݵļĴ����Ͷ������ݵļĴ���
reg[7:0] addr;//��������EEPROM�ֽڵĵ�ַ

parameter div_parameter=100;// ��Ƶϵ����AT24C02���֧��400Kʱ������

parameter start=4'b0000, //��ʼ
		  first=4'b0001, //��1λ
		  second=4'b0010,//��2λ
		  third=4'b0011, //��3λ
		  fourth=4'b0100, //��4λ
		  fifth=4'b0101, //��5λ
		  sixth=4'b0110, //��6λ
		  seventh=4'b0111, //��7λ
		  eighth=4'b1000, //��8λ
		  ack=4'b1001,   //ȷ��λ
		  stop=4'b1010; //����λ
		
parameter ini=3'b000, //��ʼ��EEPROM״̬
		  sendaddr=3'b001, //���͵�ַ״̬
		  write_data=3'b010, //д����״̬?
		  read_data=3'b011, //������״̬
		  read_ini=6'b100; //���Ͷ���Ϣ״̬

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


///////////////////////////EEPROM��������/////////////
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
			2'b00: begin  //�ȴ���дҪ��
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
			2'b01: begin  //��EEPROMд������
				if(phase0)
					scl<=1;
				else if(phase2)
					scl<=0;
			
				case(i2c_state)
					ini: begin   //��ʼ��EEPROM
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
					sendaddr: begin  //����Ӧ�ֽڵĵ�ַ
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
					write_data: begin //д������
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
			2'b10: begin  //��EEPROM
				if(phase0)
					scl<=1;
				else if(phase2)
					scl<=0;
					
				case(i2c_state)
				ini: begin   //��ʼ��EEPROM
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
				sendaddr: begin  //����ӦҪ���ֽڵĵ�ַ
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
				read_ini: begin  //������Ҫ��
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
				read_data: begin  //��������
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
				
///////////////////////////�������ʾ����/////////////					
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
				
