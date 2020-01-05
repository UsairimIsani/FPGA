--www.21eda.net
--Email: sz21eda@126.com
--Subtraction   a - b 

--NET "a<0>"  LOC = "P24"  ; # SW 6
--NET "a<1>"  LOC = "P26"  ; # SW 7
--NET "a<2>"  LOC = "P27"  ; # SW 8

--NET "b<0>"  LOC = "P16"  ; # SW 1
--NET "b<1>"  LOC = "P17"  ; # SW 2
--NET "b<2>"  LOC = "P21"  ; # SW 3

--digital tube display
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Jianhua_SMG is

 PORT (
      a    : IN std_logic_vector(2 DOWNTO 0); --SW INPUT¡£  
      b    : IN std_logic_vector(2 DOWNTO 0); --SW INPUT¡£  
      c  : OUT std_logic_vector(7 DOWNTO 0);  --digital tube display
      en : OUT std_logic_vector(7 DOWNTO 0)); --  
end Jianhua_SMG;

architecture Behavioral of Jianhua_SMG is


   SIGNAL c_tmp :  std_logic_vector(2 DOWNTO 0);   

BEGIN
   en<= "00000000" ;  
   c_tmp <= a - b ;   --  110  6
                      --  010  2
                      --  100  4
   PROCESS(c_tmp)
   BEGIN
      CASE c_tmp IS
         WHEN "000" =>
                  c <= "11000000";    --8 421
         WHEN "001" =>
                  c <= "11111001";    --0 110
         WHEN "010" =>
                  c <= "10100100";   --ÊýÂë¹ÜµÄ7¶ÎÂë  
         WHEN "011" =>
                  c <= "10110000";    
         WHEN "100" =>
                  c <= "10011001";    
         WHEN "101" =>
                  c <= "10010010";    
         WHEN "110" =>
                  c <= "10000010";    
         WHEN "111" =>
                  c <= "11111000";    
        
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
   END PROCESS;


end Behavioral;

