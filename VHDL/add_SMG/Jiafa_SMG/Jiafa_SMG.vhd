--www.21eda.net
--Email: sz21eda@126.com
--a add b , Digital tube display
--NET "a<0>"  LOC = "P24"  ; # SW 6
--NET "a<1>"  LOC = "P26"  ; # SW 7
--NET "a<2>"  LOC = "P27"  ; # SW 8

--NET "b<0>"  LOC = "P16"  ; # SW 1
--NET "b<1>"  LOC = "P17"  ; # SW 2
--NET "b<2>"  LOC = "P21"  ; # SW 3
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Jiafa_SMG is

  PORT (
      a  : IN std_logic_vector(2 DOWNTO 0);    -- sw input  
      b  : IN std_logic_vector(2 DOWNTO 0);    -- sw input  
      c  : OUT std_logic_vector(7 DOWNTO 0);   -- The 7 segment digital tube
      en : OUT std_logic_vector(7 DOWNTO 0));   
		
end Jiafa_SMG;

architecture Behavioral of Jiafa_SMG is



   SIGNAL c_tmp :  std_logic_vector(3 DOWNTO 0);   

BEGIN
   en <= "00000000" ;
   c_tmp <=('0'&a)+b;

   PROCESS(c_tmp)
   BEGIN
      CASE c_tmp IS
         WHEN "0000" =>
                  c <= "11000000";    
         WHEN "0001" =>
                  c <= "11111001";    
         WHEN "0010" =>
                  c <= "10100100";    
         WHEN "0011" =>
                  c <= "10110000";    
         WHEN "0100" =>
                  c <= "10011001";    
         WHEN "0101" =>
                  c <= "10010010";    
         WHEN "0110" =>
                  c <= "10000010";    
         WHEN "0111" =>
                  c <= "11111000";    
         WHEN "1000" =>
                  c <= "10000000";    
         WHEN "1001" =>
                  c <= "10010000";    
         WHEN "1010" =>
                  c <= "10001000";    
         WHEN "1011" =>
                  c <= "10000011";    
         WHEN "1100" =>
                  c <= "11000110";    
         WHEN "1101" =>
                  c <= "10100001";    
         WHEN "1110" =>
                  c <= "10000110";    
         WHEN "1111" =>
                  c <= "10001110";    
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
   END PROCESS;


end Behavioral;

