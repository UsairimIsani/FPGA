--www.21eda.net
--Email: sz21eda@126.com

--NET "a"  LOC = "P114"  ;  K3
--NET "b"  LOC = "P112"  ;  K2
--NET "c"  LOC = "P45"  ;
--NET "sel"  LOC = "P16"  ; sw1

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX_2_1 is

	port(    a :in std_logic;   --SW INPUT
	         b :in std_logic;   --SW INPUT
	         sel:in std_logic;  --SLECT
	         c:out std_logic);  --LED
end MUX_2_1;

architecture Behavioral of MUX_2_1 is

begin
process(sel,a,b)
begin
	if(sel='1')then    --当SEL脚为1时。将a的输入状态 在LED上显示
		c<=a;
	else               --当SEL脚为0时。将b的输入状态 在LED上显示
		c<=b;
	end if;
end process;

end Behavioral;

