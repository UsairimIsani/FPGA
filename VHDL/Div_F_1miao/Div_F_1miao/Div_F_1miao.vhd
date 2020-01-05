--www.21eda.net
--Email: sz21eda@126.com
--A second signal. With the counter
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Div_F_1miao is

port(clk      :in std_logic;  --CLK 50M INPUT
     miao_out :out std_logic);  --LED OUTPUT  led display
	  
end Div_F_1miao;

architecture Behavioral of Div_F_1miao is

begin 
 process(clk)
variable cnt:integer range 0 to 24999999;  --frequency division 24 999 999
variable ff:std_logic;                              -- 50 000 000
begin
    if clk'event and clk='1' then
    if cnt<24999999 then
      cnt:=cnt+1;
    else
    cnt:=0;
    ff:=not ff;  --反向  
    --0.5秒的高电平加上0.5秒的低电平就是1秒钟
	 --高电平期间，LED不亮，低电平期间,LED亮
    end if;
   end if;
    miao_out<= not ff ;  --反向
end process ;
end Behavioral;

