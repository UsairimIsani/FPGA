--www.21eda.net
--Email: sz21eda@126.com
--USB-TTL COM 
--PC to board ,0 1 2 3 4 5 6 7 8 9 
--board to PC 21EDA
-- if you press k2 ,your PC will receive 21EDA
--USB-TTL . TX -> P115 , RX -> P116
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is

 PORT (
      clk                     : IN std_logic;   --50M INPUT
      rst                     : IN std_logic;   --RESET 
      rxd                     : IN std_logic;   --RX 
      txd                     : OUT std_logic;  --TX  
      en                      : OUT std_logic_vector(7 DOWNTO 0); -- 
      seg_data                : OUT std_logic_vector(7 DOWNTO 0); --Digital tube display  
      key_input               : IN std_logic);   --KEY INPUT 
		
end UART;

architecture Behavioral of UART is



   --//////////////////inner reg////////////////////
   SIGNAL div_reg                  :  std_logic_vector(15 DOWNTO 0);--分频计数器，分频值由波特率决定。分频后得到频率8倍波特率的时钟   
   SIGNAL div8_tras_reg            :  std_logic_vector(2 DOWNTO 0);--该寄存器的计数值对Ψ⑺褪钡鼻拔挥诘氖倍?  
   SIGNAL div8_rec_reg             :  std_logic_vector(2 DOWNTO 0);  --寄存器的计数值对应接收时当前位于的时隙数 
   SIGNAL state_tras               :  std_logic_vector(3 DOWNTO 0);  -- 发送状态寄存器
   SIGNAL state_rec                :  std_logic_vector(3 DOWNTO 0); -- 接受状态寄存器 
   SIGNAL clkbaud_tras             :  std_logic; --以波特率为频率的发送使能信号  
   SIGNAL clkbaud_rec              :  std_logic; --以波特率为频率的接受使能信号  
   SIGNAL clkbaud8x                :  std_logic; --以8倍波特率为频率的时钟，它的作用是将发送或接受一个bit的时钟芷诜治?个时隙  
   SIGNAL recstart                 :  std_logic; -- 开始发送标志 
   SIGNAL recstart_tmp             :  std_logic; --开始接受标志  
   SIGNAL trasstart                :  std_logic;   
   SIGNAL rxd_reg1                 :  std_logic; --接收寄存器1  
   SIGNAL rxd_reg2                 :  std_logic; --接收寄存器2，因为接收数据为异步信号，故用两级缓存  
   SIGNAL txd_reg                  :  std_logic; --发送寄存器  
   SIGNAL rxd_buf                  :  std_logic_vector(7 DOWNTO 0);--接受数据缓存   
   SIGNAL txd_buf                  :  std_logic_vector(7 DOWNTO 0);--发送数据缓存   
   SIGNAL send_state               :  std_logic_vector(2 DOWNTO 0);--每伟醇鳳C发送"Welcome"字馐欠⑺妥刺拇嫫?  
   SIGNAL cnt_delay                :  std_logic_vector(19 DOWNTO 0);--延时去抖计数器   
   SIGNAL start_delaycnt           :  std_logic;  --开始延时计数标志 
   SIGNAL key_entry1               :  std_logic;  --确定有键按下标志 
   SIGNAL key_entry2               :  std_logic;  --确定有键按下标志 
   --//////////////////////////////////////////////
   CONSTANT  div_par               :  std_logic_vector(15 DOWNTO 0) := "0000000101000101"; 
   --分频参数，其值由杂Φ牟ㄌ芈始扑愣茫创瞬问制档氖敝悠德适遣ū短芈实?倍，此处值对应9600的波特率，即制党龅氖敝悠率是9600*8	    
   SIGNAL txd_xhdl3                :  std_logic;   

begin

 en <="00000000" ;--7段数码管使能信号赋值
   txd <= txd_xhdl3;

   txd_xhdl3 <= txd_reg ;

   PROCESS(clk,rst)
   BEGIN
      
      IF (NOT rst = '1') THEN
         cnt_delay <= "00000000000000000000";    
         start_delaycnt <= '0';    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (start_delaycnt = '1') THEN
            IF (cnt_delay /= "11000011010100000000") THEN
               cnt_delay <= cnt_delay + "00000000000000000001";    
            ELSE
               cnt_delay <= "00000000000000000000";    
               start_delaycnt <= '0';    
            END IF;
         ELSE
            IF ((NOT key_input='1') AND (cnt_delay = "00000000000000000000")) THEN
               start_delaycnt <= '1';    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clk,rst)
   BEGIN
      
      IF (NOT rst = '1') THEN
         key_entry1 <= '0';    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (key_entry2 = '1') THEN
            key_entry1 <= '0';    
         ELSE
            IF (cnt_delay = "11000011010100000000") THEN
               IF (NOT key_input = '1') THEN
                  key_entry1 <= '1';    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clk,rst)
   BEGIN
      
      IF (NOT rst = '1') THEN
         div_reg <= "0000000000000000";    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (div_reg = div_par - "0000000000000001") THEN
            div_reg <= "0000000000000000";    
         ELSE
            div_reg <= div_reg + "0000000000000001";    
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clk,rst)  --分频得到8倍波特率的时钟
   BEGIN
      
      IF (NOT rst = '1') THEN
         clkbaud8x <= '0';    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (div_reg = div_par - "0000000000000001") THEN
            clkbaud8x <= NOT clkbaud8x;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clkbaud8x,rst)
   BEGIN
      IF (NOT rst = '1') THEN
         div8_rec_reg <= "000";    
      ELSE IF(clkbaud8x'EVENT AND clkbaud8x = '1') THEN
         IF (recstart = '1') THEN  --接收开始标志
            div8_rec_reg <= div8_rec_reg + "001";--接收开始后，时隙数在8倍波特率的时钟下加1循环    
         END IF;
	   END IF;
      END IF;
   END PROCESS;

   PROCESS(clkbaud8x,rst)
   BEGIN
      IF (NOT rst = '1') THEN
         div8_tras_reg <= "000";    
      ELSE IF(clkbaud8x'EVENT AND clkbaud8x = '1') THEN
         IF (trasstart = '1') THEN
            div8_tras_reg <= div8_tras_reg + "001";--发送开始后，时隙数在8倍波特率的时钟下加1循环    
         END IF;
	   END IF;
      END IF;
   END PROCESS;

   PROCESS(div8_rec_reg)
   BEGIN
      IF (div8_rec_reg = "111") THEN
         clkbaud_rec <= '1'; ---在第7个时隙，接收使能信号有效，将数据打入   
      ELSE
         clkbaud_rec <= '0';    
      END IF;
   END PROCESS;

   PROCESS(div8_tras_reg)
   BEGIN
      IF (div8_tras_reg = "111") THEN
         clkbaud_tras <= '1';  --诘?个时隙，发送使能信号有效，将数据发出  
      ELSE
         clkbaud_tras <= '0';    
      END IF;
   END PROCESS;

   PROCESS(clkbaud8x,rst)
   BEGIN
      IF (NOT rst = '1') THEN
         txd_reg <= '1';    
         trasstart <= '0';    
         txd_buf <= "00000000";    
         state_tras <= "0000";    
         send_state <= "000";    
         key_entry2 <= '0';    
      ELSE IF(clkbaud8x'EVENT AND clkbaud8x = '1') THEN
         IF (NOT key_entry2 = '1') THEN
            IF (key_entry1 = '1') THEN
               key_entry2 <= '1';    
               txd_buf <= "00110010";   --"2"
            END IF;
         ELSE
            CASE state_tras IS
               WHEN "0000" =>  --发送起始位
                        IF ((NOT trasstart='1') AND (send_state < "111") ) THEN
                           trasstart <= '1';    
                        ELSE
                           IF (send_state < "111") THEN
                              IF (clkbaud_tras = '1') THEN
                                 txd_reg <= '0';    
                                 state_tras <= state_tras + "0001";    
                              END IF;
                           ELSE
                              key_entry2 <= '0';    
                              state_tras <= "0000";    
                           END IF;
                        END IF;
               WHEN "0001" => --发送第1位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0010" =>  --发送第2位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0011" =>  --发送第3位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0100" => --发送第4位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0101" => --发送第5位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0110" => --发送第6位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0111" => --发送第7位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "1000" =>  --发送第8位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "1001" =>  --发送停止位
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= '1';    
                           txd_buf <= "01010101";    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "1111" =>
                        IF (clkbaud_tras = '1') THEN
                           state_tras <= state_tras + "0001";    
                           send_state <= send_state + "001";    
                           trasstart <= '0';    
                           CASE send_state IS
                              WHEN "000" =>
                                       txd_buf <= "00110001";  --"1"   
                              WHEN "001" =>
                                       txd_buf <= "01000101";  --"E"   
                              WHEN "010" =>
                                       txd_buf <= "01000100";  --"D"  
                              WHEN "011" =>
                                       txd_buf <= "01000001";   --A"  

                              WHEN "100" =>
                                       txd_buf <= "00001010";  --"huanghang"  
                                       
                              WHEN OTHERS  =>
                                       txd_buf <= "00000000";  
                              
                           END CASE;
                        END IF;
               WHEN OTHERS  =>
                        IF (clkbaud_tras = '1') THEN
                           state_tras <= state_tras + "0001";    
                           trasstart <= '1';    
                        END IF;
               
            END CASE;
         END IF;
      END IF;
	END IF;
   END PROCESS;

   PROCESS(clkbaud8x,rst)  --接受PC机的数据
   BEGIN
      IF (NOT rst = '1') THEN
         rxd_reg1 <= '0';    
         rxd_reg2 <= '0';    
         rxd_buf <= "00000000";    
         state_rec <= "0000";    
         recstart <= '0';    
         recstart_tmp <= '0';    
      ELSE IF(clkbaud8x'EVENT AND clkbaud8x = '1') THEN
         rxd_reg1 <= rxd;    
         rxd_reg2 <= rxd_reg1;    
         IF (state_rec = "0000") THEN
            IF (recstart_tmp = '1') THEN
               recstart <= '1';    
               recstart_tmp <= '0';    
               state_rec <= state_rec + "0001";    
            ELSE
               IF ((NOT rxd_reg1 AND rxd_reg2) = '1') THEN --检测到起始位的下降沿，进入接受状态
                  recstart_tmp <= '1';    
               END IF;
            END IF;
         ELSE
            IF (state_rec >= "0001" AND state_rec<="1000") THEN
               IF (clkbaud_rec = '1') THEN
                  rxd_buf(7) <= rxd_reg2;    
                  rxd_buf(6 DOWNTO 0) <= rxd_buf(7 DOWNTO 1);    
                  state_rec <= state_rec + "0001";    
               END IF;
            ELSE
               IF (state_rec = "1001") THEN
                  IF (clkbaud_rec = '1') THEN
                     state_rec <= "0000";    
                     recstart <= '0';    
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
	END IF;
   END PROCESS;

   PROCESS(rxd_buf)   --将接受的数据用数码管显示出来
   BEGIN
      CASE rxd_buf IS
         WHEN "00110000" =>
                  seg_data <= "11000000";    
         WHEN "00110001" =>
                  seg_data <= "11111001";    
         WHEN "00110010" =>
                  seg_data <= "10100100";    
         WHEN "00110011" =>
                  seg_data <= "10110000";    
         WHEN "00110100" =>
                  seg_data <= "10011001";    
         WHEN "00110101" =>
                  seg_data <= "10010010";    
         WHEN "00110110" =>
                  seg_data <= "10000010";    
         WHEN "00110111" =>
                  seg_data <= "11111000";    
         WHEN "00111000" =>
                  seg_data <= "10000000";    
         WHEN "01000001" =>
                  seg_data <= "10010000";    
         WHEN "01000010" =>
                  seg_data <= "10001000";    
         WHEN "01000011" =>
                  seg_data <= "10000011";    
         WHEN "01000100" =>
                  seg_data <= "11000110";    
         WHEN "01000101" =>
                  seg_data <= "10100001";    
         WHEN "01000110" =>
                  seg_data <= "10000110";    
         WHEN "01000111" =>
                  seg_data <= "10001110";    
         WHEN OTHERS  =>
                  seg_data <= "11111111";    
      
      END CASE;
   END PROCESS;

end Behavioral;

