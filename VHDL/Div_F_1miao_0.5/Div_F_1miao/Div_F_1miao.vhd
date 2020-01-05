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

port(clk        :in std_logic;    --����ϵͳʱ��
     miao_out   :out std_logic;   --���1hzʱ���ź�,LED����һ���ڱ仯һ��
     f_miao_out :out std_logic);  --���2hzʱ���ź�,LED����һ���ڱ仯����
	  
end Div_F_1miao;

architecture Behavioral of Div_F_1miao is

begin 
p1:process(clk)
variable cnt:integer range 0 to 24999999;  --��Ƶϵ��Ϊ24999999
variable ff:std_logic;
begin
if clk'event and clk='1' then
if cnt<24999999 then
cnt:=cnt+1;
else
cnt:=0;
ff:=not ff;  --����
--0.5��ĸߵ�ƽ����0.5��ĵ͵�ƽ����1����
--�ߵ�ƽ�ڼ䣬LED�������͵�ƽ�ڼ�,LED��
end if;
end if;
miao_out<=ff;
end process p1;

p2:process(clk)
     variable cnn:integer range 0 to 12499999;  --��Ƶϵ��Ϊ12499999
variable dd:std_logic;
begin
if clk'event and clk='1' then
if cnn<12499999 then
cnn:=cnn+1;
else
cnn:=0;
dd:=not dd;  --����
--0.25��ĸߵ�ƽ����0.25��ĵ͵�ƽ����1����
--�ߵ�ƽ�ڼ䣬LED�������͵�ƽ�ڼ�,LED��
end if;
end if;
f_miao_out <=dd;
end process p2;
end Behavioral;

