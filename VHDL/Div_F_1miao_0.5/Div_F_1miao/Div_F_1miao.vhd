--www.21eda.net
--Email: sz21eda@126.com
--A second signal. With the counter
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

entity Div_F_1miao is

port(clk        :in std_logic;    --输入系统时钟
     miao_out   :out std_logic;   --输出1hz时钟信号,LED会在一秒内变化一次
     f_miao_out :out std_logic);  --输出2hz时钟信号,LED会在一秒内变化两次
	  
end Div_F_1miao;

architecture Behavioral of Div_F_1miao is

begin 
p1:process(clk)
variable cnt:integer range 0 to 24999999;  --分频系数为24999999
variable ff:std_logic;
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
miao_out<=ff;
end process p1;

p2:process(clk)
     variable cnn:integer range 0 to 12499999;  --分频系数为12499999
variable dd:std_logic;
begin
if clk'event and clk='1' then
if cnn<12499999 then
cnn:=cnn+1;
else
cnn:=0;
dd:=not dd;  --反向
--0.25秒的高电平加上0.25秒的低电平就是1秒钟
--高电平期间，LED不亮，低电平期间,LED亮
end if;
end if;
f_miao_out <=dd;
end process p2;
end Behavioral;

