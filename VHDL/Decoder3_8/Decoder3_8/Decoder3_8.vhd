--www.21eda.net
--Email: sz21eda@126.com
--3-8 decoder

--NET "A"  LOC = "P16"  ; SW1  INPUT
--NET "B"  LOC = "P17"  ; SW2
--NET "C"  LOC = "P21"  ; SW3
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder3_8 is

PORT(
		A, B, C :  IN	STD_LOGIC; -- SW INPUT 
		Y       : OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)); --LED OUTPUT
end Decoder3_8;

architecture Behavioral of Decoder3_8 is

SIGNAL indata: STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	indata <= C&B&A;
encoder:
	PROCESS (indata)
	BEGIN
		
			CASE indata IS
				WHEN "000"=>Y<="11111110";
				WHEN "001"=>Y<="11111101";
				WHEN "010"=>Y<="11111011";
				WHEN "011"=>Y<="11110111";
				WHEN "100"=>Y<="11101111";
				WHEN "101"=>Y<="11011111";
				WHEN "110"=>Y<="10111111";
				WHEN "111"=>Y<="01111111";
				WHEN OTHERS =>Y<="XXXXXXXX";
			END CASE;
	END PROCESS encoder;
end Behavioral;

