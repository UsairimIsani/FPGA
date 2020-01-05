--www.21eda.net
--Email: sz21eda@126.com
--8 3 encoded
--NET "data_in<0>"  LOC = "P16"  ;  SW1
--NET "data_in<1>"  LOC = "P17"  ;  SW2
--NET "data_in<2>"  LOC = "P21"  ;  SW3
--NET "data_in<3>"  LOC = "P22"  ;  SW4
--NET "data_in<4>"  LOC = "P23"  ;  SW5
--NET "data_in<5>"  LOC = "P24"  ;  SW6
--NET "data_in<6>"  LOC = "P26"  ;  SW7
--NET "data_in<7>"  LOC = "P27"  ;  SW8

--NET "data_out<0>"  LOC = "P44"  ;
--NET "data_out<1>"  LOC = "P45"  ;
--NET "data_out<2>"  LOC = "P46"  ;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BianMa_8_3 is

port(     data_in  :in std_logic_vector(7 downto 0);  -- SW input
	       data_out :out std_logic_vector( 2 downto 0));  --LED output

end BianMa_8_3;

architecture Behavioral of BianMa_8_3 is

begin
data_out<="000"  when  data_in="11111110" else
		   "001" when data_in="11111101"else      --输入数据低电平有效
		   "010" when data_in="11111011"else      --注意每一次只能有一个为低电平
		   "011" when data_in="11110111"else
		   "100" when data_in="11101111"else
		   "101" when data_in="11011111"else
		   "110" when data_in="10111111"else
		   "111" when data_in="01111111"else
		   "XXX" when data_in="11111111";

end Behavioral;

