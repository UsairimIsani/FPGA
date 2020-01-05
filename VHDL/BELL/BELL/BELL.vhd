--www.21eda.net
--Email: sz21eda@126.com
--Drive BELL
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BELL is
  PORT (
      clk  : IN std_logic;          --clk input 50M
      rst  : IN std_logic;          --RESET INPUT��
      out_bit  : OUT std_logic);    --BELL output
end BELL;

architecture Behavioral of BELL is

   SIGNAL clk_div1   :  std_logic_vector(3 DOWNTO 0);   --��Ƶ��Ƶ����������ƵΪ4M
   SIGNAL clk_div2   :  std_logic_vector(12 DOWNTO 0);  --���׷�Ƶ���������ɻ�Ƶ��Ƶ������������ 
   SIGNAL cnt        :  std_logic_vector(21 DOWNTO 0);  --�����׷���ʱ�䳤�̼����� 
   SIGNAL state      :  std_logic_vector(2 DOWNTO 0);   
   --���������ķ�Ƶϵ��
   CONSTANT  duo   :  std_logic_vector(12 DOWNTO 0) :="0111011101110";     
   CONSTANT  lai  :  std_logic_vector(12 DOWNTO 0) := "0110101001101";    
   CONSTANT  mi   :  std_logic_vector(12 DOWNTO 0) := "0101111011010";    
   CONSTANT  fa    :  std_logic_vector(12 DOWNTO 0) := "0101100110001";    
   CONSTANT  suo   :  std_logic_vector(12 DOWNTO 0) := "0100111110111";    
   CONSTANT  la    :  std_logic_vector(12 DOWNTO 0) := "0100011100001";    
   CONSTANT  xi    :  std_logic_vector(12 DOWNTO 0) := "0011111101000";    
   CONSTANT  duo1   :  std_logic_vector(12 DOWNTO 0) := "0011101110111";   
   SIGNAL out_bit_tmp :std_logic; 
begin

 out_bit<=out_bit_tmp;
   PROCESS(clk,rst)
   BEGIN
      
      IF (NOT rst = '1') THEN
         clk_div1 <= "0000";    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (clk_div1 /= "1001") THEN
            clk_div1 <= clk_div1 + "0001";    
         ELSE
            clk_div1 <= "0000";    
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clk,rst)
   BEGIN
    
      IF (NOT rst = '1') THEN
         clk_div2 <= "0000000000000";    
         state <= "000";    
         cnt <= "0000000000000000000000";    
         out_bit_tmp <= '0';    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (clk_div1 = "1001") THEN
            CASE state IS
               WHEN "000" =>             --�����ࡱ
                        cnt <= cnt + "0000000000000000000001";    
                        IF (cnt = "1111111111111111111111") THEN
                           state <= "001";    
                        END IF;
                        IF (clk_div2 /= duo) THEN
                           clk_div2 <= clk_div2 + "0000000000001";    
                        ELSE
                           clk_div2 <= "0000000000000";    
                           out_bit_tmp <= NOT out_bit_tmp;    
                        END IF;
               WHEN "001" =>             --��������
                        cnt <= cnt + "0000000000000000000001";    
                        IF (cnt = "1111111111111111111111") THEN
                           state <= "010";    
                        END IF;
                        IF (clk_div2 /=lai) THEN
                           clk_div2 <= clk_div2 + "0000000000001";    
                        ELSE
                           clk_div2 <= "0000000000000";    
                           out_bit_tmp <= NOT out_bit_tmp;    
                        END IF;
               WHEN "010" =>             --��"�ס�
                        cnt <= cnt + "0000000000000000000001";    
                        IF (cnt = "1111111111111111111111") THEN
                           state <= "011";    
                        END IF;
                        IF (clk_div2 /=mi) THEN
                           clk_div2 <= clk_div2 + "0000000000001";    
                        ELSE
                           clk_div2 <= "0000000000000";    
                           out_bit_tmp <= NOT out_bit_tmp;    
                        END IF;
               WHEN "011" =>             --��"����
                        cnt <= cnt + "0000000000000000000001";    
                        IF (cnt = "1111111111111111111111") THEN
                           state <= "100";    
                        END IF;
                        IF (clk_div2 /=fa) THEN
                           clk_div2 <= clk_div2 + "0000000000001";    
                        ELSE
                           clk_div2 <= "0000000000000";    
                           out_bit_tmp <= NOT out_bit_tmp;    
                        END IF;
               WHEN "100" =>            --��"��   
                        cnt <= cnt + "0000000000000000000001";    
                        IF (cnt = "1111111111111111111111") THEN
                           state <= "101";    
                        END IF;
                        IF (clk_div2 /=suo) THEN
                           clk_div2 <= clk_div2 + "0000000000001";    
                        ELSE
                           clk_div2 <= "0000000000000";    
                           out_bit_tmp <= NOT out_bit_tmp;    
                        END IF;
               WHEN "101" =>            --��"����
                        cnt <= cnt + "0000000000000000000001";    
                        IF (cnt = "1111111111111111111111") THEN
                           state <= "110";    
                        END IF;
                        IF (clk_div2 /= la) THEN
                           clk_div2 <= clk_div2 + "0000000000001";    
                        ELSE
                           clk_div2 <= "0000000000000";    
                           out_bit_tmp <= NOT out_bit_tmp;    
                        END IF;
               WHEN "110" =>            --��"����
                        cnt <= cnt + "0000000000000000000001";    
                        IF (cnt = "1111111111111111111111") THEN
                           state <= "111";    
                        END IF;
                        IF (clk_div2 /= xi) THEN
                           clk_div2 <= clk_div2 + "0000000000001";    
                        ELSE
                           clk_div2 <= "0000000000000";    
                           out_bit_tmp <= NOT out_bit_tmp;    
                        END IF;
               WHEN "111" =>            --��"�ࡰ��������
                        cnt <= cnt + "0000000000000000000001";    
                        IF (cnt = "1111111111111111111111") THEN
                           state <= "000";    
                        END IF;
                        IF (clk_div2 /= duo1) THEN
                           clk_div2 <= clk_div2 + "0000000000001";    
                        ELSE
                           clk_div2 <= "0000000000000";    
                           out_bit_tmp <= NOT out_bit_tmp;    
                        END IF;
               WHEN OTHERS =>
                        NULL;
               
            END CASE;
         END IF;
      END IF;
   END PROCESS;

end Behavioral;
