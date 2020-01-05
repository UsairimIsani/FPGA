
----------------------------------------------------------------------------------
--www.21eda.net
--Email: sz21eda@126.com
--Digital tube display

--NET "BM_KG_data<0>"  LOC = "P16"  ; SW1
--NET "BM_KG_data<1>"  LOC = "P17"  ; SW2
--NET "BM_KG_data<2>"  LOC = "P21"  ; SW3
--NET "BM_KG_data<3>"  LOC = "P22"  ; SW4
--NET "BM_KG_data<4>"  LOC = "P23"  ; SW5
--NET "BM_KG_data<5>"  LOC = "P24"  ; SW6
--NET "BM_KG_data<6>"  LOC = "P26"  ; SW7
--NET "BM_KG_data<7>"  LOC = "P27"  ; SW8
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BM_KG_SMG_LED is
PORT ( BM_KG_data  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);   --SW input
       LED7        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   --
       LED7S       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)) ; --output  The 7 segment digital tube
end BM_KG_SMG_LED;

architecture Behavioral of BM_KG_SMG_LED is
 signal BM_KG_temp: std_logic_vector(7 downto 0);
 BEGIN 
  PROCESS( BM_KG_data ) 
  BEGIN 
     LED7 <="00000000" ;      --
	 
     BM_KG_temp<= BM_KG_data  ;
  CASE  BM_KG_temp  IS 
   WHEN "11111110" =>  LED7S <= "11111001";    --  1
   WHEN "11111101" =>  LED7S <= "10100100";    --  2
   WHEN "11111011" =>  LED7S <= "10110000";    --  3
   WHEN "11110111" =>  LED7S <= "10011001";    --  4
   WHEN "11101111" =>  LED7S <= "10010010";    --  5
   WHEN "11011111" =>  LED7S <= "10000010";    --  6
   WHEN "10111111" =>  LED7S <= "11111000";    --  7
   WHEN "01111111" =>  LED7S <= "10000000";    --  8
   WHEN OTHERS =>  LED7S <= "11000000";        --  0
   END CASE ; 
  END PROCESS ; 
  
end Behavioral;
