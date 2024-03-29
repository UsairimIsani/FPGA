--www.21eda.net
--Email: sz21eda@126.com
--state_machine
--	state0--state1--state2--state3--state4--state5--state6-state7--state0
--Digital tube display
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity state_machine is

 PORT (
      clk  : IN std_logic;   --CLK 50M
      rst : IN std_logic;    --RESET
      c   : OUT std_logic_vector(7 DOWNTO 0);   --Digital tube display
      en   : OUT std_logic_vector(7 DOWNTO 0));    

end state_machine;

architecture Behavioral of state_machine is

   CONSTANT  state0   :  std_logic_vector(2 DOWNTO 0) := "000";    
   CONSTANT  state1  :  std_logic_vector(2 DOWNTO 0) := "001";    
   CONSTANT  state2  :  std_logic_vector(2 DOWNTO 0) := "010";    
   CONSTANT  state3  :  std_logic_vector(2 DOWNTO 0) := "011";    
   CONSTANT  state4 :  std_logic_vector(2 DOWNTO 0) := "100";    
   CONSTANT  state5 :  std_logic_vector(2 DOWNTO 0) := "101";    
   CONSTANT  state6   :  std_logic_vector(2 DOWNTO 0) := "110";    
   CONSTANT  state7   :  std_logic_vector(2 DOWNTO 0) := "111";    
   SIGNAL    state    :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL    cnt      :  std_logic_vector(24 DOWNTO 0);    

BEGIN
   en <= "00000000" ;

   PROCESS(clk,rst)
   BEGIN     
      IF (NOT rst = '1') THEN
         state <= state0;    
         cnt <= "0000000000000000000000000";    
      ELSIF(clk'EVENT AND clk='1')THEN
         cnt <= cnt + "000000000000000000000001";    
         IF (cnt = "1111111111111111111111111") THEN
            CASE state IS
               WHEN state0 =>
                        state <= state1;    
               WHEN state1 =>
                        state <= state2;    
               WHEN state2 =>
                        state <= state3;    
               WHEN state3 =>
                        state <= state4;    
               WHEN state4 =>
                        state <= state5;    
               WHEN state5 =>
                        state <= state6;    
               WHEN state6 =>
                        state <= state7;    
               WHEN state7 =>
                        state <= state0;    
               WHEN OTHERS =>
                        NULL;
               
            END CASE;
         END IF;
      END IF;
   END PROCESS;

   PROCESS(state)
   BEGIN
      CASE state IS
         WHEN state0 =>
                  c <= "11000000";    
         WHEN state1 =>
                  c <= "11111001";    
         WHEN state2 =>
                  c <= "10100100";    
         WHEN state3 =>
                  c <= "10110000";    
         WHEN state4 =>
                  c <= "10011001";    
         WHEN state5 =>
                  c <= "10010010";    
         WHEN state6 =>
                  c <= "10000010";   
         WHEN state7 =>
                  c <= "11111000";    
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
   END PROCESS;
end Behavioral;

