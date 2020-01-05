----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:16:22 09/08/2010 
-- Design Name: 
-- Module Name:    xd - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
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

entity xd is

  port(cin,clk:in std_logic;
         q:out std_logic);

end xd;

architecture Behavioral of xd is

begin
process(clk)
variable i:integer range 0 to 35001;
begin
 if (clk'event and clk='1')then
  if(cin='0')then
    if(i<35000)then i:=i+1;
      elsif(i=35000)then
         q<='1';
         i:=i+1;
     else
         q<='0';
       end if;
     else i:=0;q<='0';
  end if;
 end if;
end process;


end Behavioral;

