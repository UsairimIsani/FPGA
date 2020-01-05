----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:07:39 09/08/2010 
-- Design Name: 
-- Module Name:    digital_clock - Behavioral 
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
--在DE2板上验证   时钟频率有点高，可以在clk_count中增加位数作调整 
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digital_clock is

port(clk:in std_logic;--系统时钟
      key:in std_logic_vector(3 downto 0);
      seg:out std_logic_vector(7 downto 0);--段码
      q:out std_logic;
      seg_sel:out std_logic_vector(5 downto 0));--位选


end digital_clock;

architecture Behavioral of digital_clock is

component xd is
    port(cin,clk:in std_logic;
         q:out std_logic);
end component;
 signal sel:std_logic_vector(2 downto 0);
 signal clk1,clk2:std_logic;
 signal a0,a1,a2,a3,a4,a5,a6,x1,x2,x3,x4,x5,x6:std_logic_vector(3 downto 0):="0000";
 signal ns,disp:std_logic_vector(3 downto 0);--ns 临时信号
 signal wei:integer range 3 to 6;
 signal mode:std_logic:='0';


begin
---------------------------------------------
  process(clk)         --一次分频,100ms延时
   variable cnt:integer range 0 to 5000000;
    begin
     if clk'event and clk ='1' then cnt:=cnt+1;
       if cnt<2500000 then clk1<='0';
         elsif cnt<5000000 then clk1<='1';
         else cnt:=0;clk1<='0';
      end if;
     end if;
  end process;
-------------------------------------------
text1:for j in 0 to 3 generate
u1:xd port map(key(j),clk,ns(j));
end generate text1;
-------------------------------------------
process(clk,ns)
begin
   if clk='1' and clk'event then
   if ns(0)='1' and mode='0' then
--            x1<=a1;x2<=a2;
            x3<=a3;x4<=a4;x5<=a5;x6<=a6;
   wei<=3;mode<='1';
   elsif ns(0)='1' and mode='1' then
             mode<='0';
 elsif mode='1' then
    if ns(1)='1' then
     if wei>=6 then
        wei<=3;
     else
        wei<=wei+1;
     end if;
    end if;
 if ns(2)='1' then 
      case wei is
--        when 1=>if (x1<9) then x1<=x1+1;
--                     else x1<="0000";
--                  end if;
--        when 2=>if (x2<6) then x2<=x2+1;
--                      else x2<="0000";
--                  end if;
        when 3=>if (x3<9) then x3<=x3+1;
                     else x3<="0000";
                  end if;
        when 4=>if (x4<5) then x4<=x4+1;
                      else x4<="0000";
                  end if;
        when 5=>if (x5<9 and x6<2 ) then x5<=x5+1;
                     elsif (x5=9 and x6<2)then x5<="0000";
                     elsif (x5<3 and x6=2)then x5<="0000";
         else x5<=x5+1;
                  end if;
        when 6=>if (x6<2) then x6<=x6+1;
                      else x6<="0000";
                  end if;
     end case;
  end if;
 if ns(3)='1' then 
      case wei is
--        when 1=>if (x1>0) then x1<=x1-1;
--                     else x1<="1001";
--                  end if;
--        when 2=>if (x2>0) then x2<=x2-1;
--                      else x2<="0110";
--                  end if;
        when 3=>if (x3>0) then x3<=x3-1;
                     else x3<="1001";
                  end if;
        when 4=>if (x4>0) then x4<=x4-1;
                      else x4<="0110";
                  end if;
        when 5=>if (x5>0 ) then x5<=x5-1;
                     elsif (x6=2)then x5<="0100";
                     else x5<="1001";
                  end if;
        when 6=>if (x6>0) then x6<=x6-1;
                      else x6<="0010";
                  end if;
     end case;
  end if;
   end if;
end if;
end process;  
-------------------------------------------
process(clk1,ns)
 begin
if ns(0)='1' and mode='1' then
--    a1<=x1;a2<=x2;
      a3<=x3;a4<=x4;a5<=x5;a6<=x6;
elsif  clk1'event and clk1='1' then  
      a0<=a0+1; --毫秒百位
       if (a0 >=9) then
         a1<=a1+1;a0 <="0000";--秒个位
         if (a1 >=9) then
           a2<=a2+1;a1 <="0000";--秒十位
           if (a2 >=5) then
             a3<=a3+1;a2 <="0000";--分个位
             if (a3 >=9) then
              a4<=a4+1;a3 <="0000";--分十位
              if (a4 >=5) then
                a5<=a5+1;a4 <="0000";--时个位
                 if (a5>=9 and a6<2) then
                   a6<=a6+1;a5 <="0000";--时十位
                    elsif(a6>=2 and a5>=3) then
                       a1<="0000";a2<="0000";a3<="0000";
                       a4<="0000";a5<="0000";a6<="0000";
                 end if;
               end if;
             end if;
           end if;
         end if;
        end if;
    end if;    
end process;
------------------------------------------
  process(clk)  --0.5ms延时,用于扫描
   variable cnt1:integer range 0 to 2500;
    begin
     if clk'event and clk ='1' then cnt1:=cnt1+1;
       if cnt1<1250 then clk2<='0';
         elsif cnt1<2500 then clk2<='1';
         else cnt1:=0;clk2<='0';
      end if;
     end if;
  end process;
------------------------------------------
process(clk2)          --扫描显示
 begin
  if clk2'event and clk2='1' then
      sel<=sel+1;
if a0<5 then
   Q<='1';
   if mode='0' then
      case sel is
        when"010"=>disp<=a1;seg_sel<="111110";
        when"011"=>disp<=a2;seg_sel<="111101";
        when"100"=>disp<=a3;seg_sel<="111011";
        when"101"=>disp<=a4;seg_sel<="110111";
        when"110"=>disp<=a5;seg_sel<="101111";
        when"111"=>disp<=a6;seg_sel<="011111";
        when others=>disp<="0000";
      end case;
   else
       case sel is
        when"010"=>disp<=a1;seg_sel<="111110";
        when"011"=>disp<=a2;seg_sel<="111101";
        when"100"=>disp<=x3;seg_sel<="111011";
        when"101"=>disp<=x4;seg_sel<="110111";
        when"110"=>disp<=x5;seg_sel<="101111";
        when"111"=>disp<=x6;seg_sel<="011111";
        when others=>disp<="0000";
      end case;
  end if;
else
Q<='0';
if mode='1' then
 case sel is
        when"010"=>disp<=a1;seg_sel<="111110";
        when"011"=>disp<=a2;seg_sel<="111101";
        when"100"=>if wei=3 then
                      disp<="1111";
                      else disp<=x3;
                   end if;
                   seg_sel<="111011";
        when"101"=>if wei=4 then
                      disp<="1111";
                      else disp<=x4;
                   end if;
                   seg_sel<="110111";
        when"110"=>if wei=5 then
                      disp<="1111";
                      else disp<=x5;
                   end if;
                   seg_sel<="101111";
        when"111"=>if wei=6 then
                      disp<="1111";
                      else disp<=x6;
                   end if;
                   seg_sel<="011111";
        when others=>disp<="0000";
      end case;
else
 case sel is
        when"010"=>disp<=a1;seg_sel<="111110";
        when"011"=>disp<=a2;seg_sel<="111101";
        when"100"=>disp<=a3;seg_sel<="111011";
        when"101"=>disp<=a4;seg_sel<="110111";
        when"110"=>disp<=a5;seg_sel<="101111";
        when"111"=>disp<=a6;seg_sel<="011111";
        when others=>disp<="0000";
      end case;
end if;
end if;
end if;
end process;
---------------------------------
process(disp)             --共阳译码
 begin
   case disp is
    when"0000"=>seg<="11000000";--0
    when"0001"=>seg<="11111001";--1
    when"0010"=>seg<="10100100";--2
    when"0011"=>seg<="10110000";--3
    when"0100"=>seg<="10011001";--4
    when"0101"=>seg<="10010010";--5
    when"0110"=>seg<="10000010";--6
    when"0111"=>seg<="11111000";--7
    when"1000"=>seg<="10000000";--8
    when"1001"=>seg<="10010000";--9
    when others=>seg<="11111111";
   end case;
 end process;


end Behavioral;

