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
   SIGNAL div_reg                  :  std_logic_vector(15 DOWNTO 0);--��Ƶ����������Ƶֵ�ɲ����ʾ�������Ƶ��õ�Ƶ��8�������ʵ�ʱ��   
   SIGNAL div8_tras_reg            :  std_logic_vector(2 DOWNTO 0);--�üĴ����ļ���ֵ�Ԧ����ʱ��ǰλ�ڵ�ʱ�?  
   SIGNAL div8_rec_reg             :  std_logic_vector(2 DOWNTO 0);  --�Ĵ����ļ���ֵ��Ӧ����ʱ��ǰλ�ڵ�ʱ϶�� 
   SIGNAL state_tras               :  std_logic_vector(3 DOWNTO 0);  -- ����״̬�Ĵ���
   SIGNAL state_rec                :  std_logic_vector(3 DOWNTO 0); -- ����״̬�Ĵ��� 
   SIGNAL clkbaud_tras             :  std_logic; --�Բ�����ΪƵ�ʵķ���ʹ���ź�  
   SIGNAL clkbaud_rec              :  std_logic; --�Բ�����ΪƵ�ʵĽ���ʹ���ź�  
   SIGNAL clkbaud8x                :  std_logic; --��8��������ΪƵ�ʵ�ʱ�ӣ����������ǽ����ͻ����һ��bit��ʱ����ڷ��?��ʱ϶  
   SIGNAL recstart                 :  std_logic; -- ��ʼ���ͱ�־ 
   SIGNAL recstart_tmp             :  std_logic; --��ʼ���ܱ�־  
   SIGNAL trasstart                :  std_logic;   
   SIGNAL rxd_reg1                 :  std_logic; --���ռĴ���1  
   SIGNAL rxd_reg2                 :  std_logic; --���ռĴ���2����Ϊ��������Ϊ�첽�źţ�������������  
   SIGNAL txd_reg                  :  std_logic; --���ͼĴ���  
   SIGNAL rxd_buf                  :  std_logic_vector(7 DOWNTO 0);--�������ݻ���   
   SIGNAL txd_buf                  :  std_logic_vector(7 DOWNTO 0);--�������ݻ���   
   SIGNAL send_state               :  std_logic_vector(2 DOWNTO 0);--ÿΰ�����PC����"Welcome"����������Ƿ���״̬�Ĵ��?  
   SIGNAL cnt_delay                :  std_logic_vector(19 DOWNTO 0);--��ʱȥ��������   
   SIGNAL start_delaycnt           :  std_logic;  --��ʼ��ʱ������־ 
   SIGNAL key_entry1               :  std_logic;  --ȷ���м����±�־ 
   SIGNAL key_entry2               :  std_logic;  --ȷ���м����±�־ 
   --//////////////////////////////////////////////
   CONSTANT  div_par               :  std_logic_vector(15 DOWNTO 0) := "0000000101000101"; 
   --��Ƶ��������ֵ���Ӧ�Ĳ����ʼ�����ã����˲�����Ƶ��ʱ��Ƶ���ǲ������ʵ?�����˴�ֵ��Ӧ9600�Ĳ����ʣ����Ƶ����ʱ�������9600*8	    
   SIGNAL txd_xhdl3                :  std_logic;   

begin

 en <="00000000" ;--7�������ʹ���źŸ�ֵ
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

   PROCESS(clk,rst)  --��Ƶ�õ�8�������ʵ�ʱ��
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
         IF (recstart = '1') THEN  --���տ�ʼ��־
            div8_rec_reg <= div8_rec_reg + "001";--���տ�ʼ��ʱ϶����8�������ʵ�ʱ���¼�1ѭ��    
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
            div8_tras_reg <= div8_tras_reg + "001";--���Ϳ�ʼ��ʱ϶����8�������ʵ�ʱ���¼�1ѭ��    
         END IF;
	   END IF;
      END IF;
   END PROCESS;

   PROCESS(div8_rec_reg)
   BEGIN
      IF (div8_rec_reg = "111") THEN
         clkbaud_rec <= '1'; ---�ڵ�7��ʱ϶������ʹ���ź���Ч�������ݴ���   
      ELSE
         clkbaud_rec <= '0';    
      END IF;
   END PROCESS;

   PROCESS(div8_tras_reg)
   BEGIN
      IF (div8_tras_reg = "111") THEN
         clkbaud_tras <= '1';  --ڵ?��ʱ϶������ʹ���ź���Ч�������ݷ���  
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
               WHEN "0000" =>  --������ʼλ
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
               WHEN "0001" => --���͵�1λ
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0010" =>  --���͵�2λ
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0011" =>  --���͵�3λ
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0100" => --���͵�4λ
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0101" => --���͵�5λ
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0110" => --���͵�6λ
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0111" => --���͵�7λ
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "1000" =>  --���͵�8λ
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "1001" =>  --����ֹͣλ
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

   PROCESS(clkbaud8x,rst)  --����PC��������
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
               IF ((NOT rxd_reg1 AND rxd_reg2) = '1') THEN --��⵽��ʼλ���½��أ��������״̬
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

   PROCESS(rxd_buf)   --�����ܵ��������������ʾ����
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
