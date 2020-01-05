--www.21eda.net
--Email: sz21eda@126.com
--LCD12864 DISPLAY
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LCD12864 is

port(clk,reset:in std_logic;  --clk 50M
     lcd_rs:out std_logic;    --LCD RS
	  lcd_wr:out std_logic;    --LCD WR
	  lcd_e:out std_logic;     --LCD EN
	  lcd_bus:out std_logic_vector(7 downto 0) --LCD DATA
	 --lcd_rst:out std_logic 
	  );  

end LCD12864;

architecture Behavioral of LCD12864 is

type dirve_sta is(clr_lcd,set_bus,clr_disp,set_disp_mod,set_cursor,set_disp_place,send_data,stop); 
  signal current_sta:dirve_sta; 
  signal s_clk:std_logic; 
  signal disp_cnt1:integer range 0 to 8; 
  signal disp_cnt:integer range 0 to 8; 
  type char_rom is array(0 to 5)of std_logic_vector(7 downto 0); 
  constant  volt:char_rom:=(x"00",x"B5",x"E7",x"D1",x"B9",x"3a");--电压的字符代码。 
  constant  freq:char_rom:=(x"00",x"C6",x"B5",x"C2",x"CA",x"3a");--频率的字符代码。 
     
  type data_ram1 is array(0 to 4) of std_logic_vector(7 downto 0); 
  signal volt_v:data_ram1; 
  type data_ram2 is array(0 to 5)of std_logic_vector(7 downto 0);  
  signal freq_v:data_ram2; 

begin

 process(clk) 
	 begin 
	 if clk'event and clk='1' then  
	 volt_V(1)<=x"33"; 
	 volt_V(2)<=x"36"; 
	 volt_V(3)<=X"56"; 
	 freq_v(1)<=x"31"; 
	 freq_v(2)<=x"30"; 
	 freq_v(3)<=x"30"; 
	 freq_v(4)<=x"48"; 
	 freq_v(5)<=x"5A"; 
	 end if; 
	 end process; 
 				div_process:process(clk,reset) 
				            variable count:integer range 0 to 25000; 
								begin 
								if reset='0' then count:=0;s_clk<='1'; 
								elsif rising_edge(clk)then  
								  if count<25000 then count:=count+1; 
								    else count:=0;s_clk<=not s_clk; 
								  end if; 
								end if; 
								end process; 
d:   process(s_clk,reset,clk) 
	variable count:integer range 0 to 100; 
	begin 
	if reset='0'then  current_sta<=set_bus;
	   count:=0; 
	elsif rising_edge(s_clk)then 
	  case current_sta is 
	    when clr_lcd=>if count<6 then count:=count+1; 
		         							-- lcd_rst<='0'; 
							 else count:=0; 
							 end if; 
							 if count<6 then 
							-- lcd_rst<='0';
							 current_sta<=clr_lcd; 
							   
							 else current_sta<=set_bus;     
							-- lcd_rst<='1'; 
							 end if; 
	    when set_bus=> 
		              if count<6 then count:=count+1; 
						   else count:=0; 
							end if; 
							case count is 
							  when 0=>lcd_e<='0'; 
							  when 1=>lcd_rs<='0'; 
							  when 2=>lcd_wr<='0'; 
							  when 3=>lcd_bus<=x"30"; 
							  when 4=>lcd_e<='1'; 
							  when 5=>lcd_e<='0'; 
							  when 6=>current_sta<=clr_disp;count:=0; 
							  when others=>current_sta<=clr_lcd; 
							end case; 
		when clr_disp=> 
		              if count<6 then count:=count+1; 
						  else count:=0; 
						  end if; 
						  case count is 
						    when 0=>lcd_e<='0'; 
						    when 1=>lcd_rs<='0'; 
							 when 2=>lcd_wr<='0'; 
							 when 3=>lcd_bus<=x"0c"; 
							 when 4=>lcd_e<='1'; 
							 when 5=>lcd_e<='0'; 
							 when 6=>current_sta<=set_disp_mod; 
							 when others=>current_sta<=clr_disp;count:=0; 
						 end case; 
	  when set_disp_mod=> 
		              if count<6 then count:=count+1; 
						  else count:=0; 
						  end if; 
						  case count is 
						    when 0=>lcd_e<='0'; 
						    when 1=>lcd_rs<='0'; 
							 when 2=>lcd_wr<='0'; 
							 when 3=>lcd_bus<=x"01"; 
							 when 4=>lcd_e<='1'; 
							 when 5=>lcd_e<='0'; 
							 when 6=>current_sta<=set_cursor; 
							 when others=>current_sta<=clr_disp;count:=0; 
						 end case; 
	 when set_cursor=> 
		              if count<6 then count:=count+1; 
						  else count:=0; 
						  end if; 
						  case count is 
						    when 0=>lcd_e<='0'; 
						    when 1=>lcd_rs<='0'; 
							 when 2=>lcd_wr<='0'; 
							 when 3=>lcd_bus<=x"06"; 
							 when 4=>lcd_e<='1'; 
							 when 5=>lcd_e<='0'; 
							 when 6=>current_sta<=set_disp_place;   
							 when others=>current_sta<=clr_disp;count:=0; 
						 end case; 
	when set_disp_place=> 
		              if count<6 then count:=count+1; 
						  else count:=0; 
						  end if; 
						  case count is 
						    when 0=>lcd_e<='0'; 
						    when 1=>lcd_rs<='0'; 
							 when 2=>lcd_wr<='0'; 
							 when 3=>   if disp_cnt=0 then lcd_bus<=x"80"; 
										elsif disp_cnt=1 then lcd_bus<=x"90"; 
										elsif disp_cnt=2 then lcd_bus<=x"83"; 
										elsif disp_cnt=3 then lcd_bus<=x"93"; 
										end if; 
							         
							 when 4=>lcd_e<='1'; 
							 when 5=>lcd_e<='0'; 
							 when 6=>current_sta<=send_data; 
							 when others=>current_sta<=clr_disp;count:=0; 
						 end case; 
  when send_data=> 
		              if count<8 then count:=count+1; 
						  else count:=0; 
						  end if; 
						  case count is 
						    when 0=>lcd_e<='0'; 
						    when 1=>lcd_rs<='1'; 
							 when 2=>lcd_rs<='1'; 
							 when 3=>lcd_wr<='0'; 
							 when 4=>          if disp_cnt= 0  then lcd_bus<=volt(disp_cnt1);  
							                  elsif disp_cnt=1 then lcd_bus<=freq(disp_cnt1); 
													elsif disp_cnt=2 then lcd_bus<=volt_v(disp_cnt1); 
													elsif disp_cnt=3 then lcd_bus<=freq_v(disp_cnt1); 
													end if; 
 
													  
							 when 5=>lcd_e<='1'; 
							 when 6=>lcd_e<='0'; 
							 when 7=>lcd_e<='0'; 
							 when 8=>--current_sta<=stop; 
							        if disp_cnt=0  then  
									    disp_cnt1<=disp_cnt1+1; 
							          if disp_cnt1<6 then current_sta<=send_data; 
								       else disp_cnt1<=0;disp_cnt<=disp_cnt+1;current_sta<=set_disp_place;--current_sta<=send_data;\ 
								  	     end if; 
									 elsif disp_cnt=1 then 
									    disp_cnt1<=disp_cnt1+1; 
										 if disp_cnt1<6 then current_sta<=send_data; 
										 else disp_cnt<=disp_cnt+1; disp_cnt1<=0;current_sta<=set_disp_place; 
										 end if; 
									 elsif disp_cnt=2 then 
									    disp_cnt1<=disp_cnt1+1; 
										 if disp_cnt1<3  then current_sta<=send_data;		                          
										 else disp_cnt1<=0;disp_cnt<=disp_cnt+1;current_STA<=set_disp_place; 
										 end if; 
									 elsif disp_cnt=3 then 
									    disp_cnt1<=disp_cnt1+1; 
										 if disp_cnt1<5 then current_sta<=send_data; 
										 else disp_cnt1<=0;disp_cnt<=disp_cnt+1;current_sta<=set_disp_place; 
										 end if; 
                            end if; 
							 when others=>current_sta<=clr_disp;count:=0; 
						 end case; 
  when stop=>lcd_bus<="ZZZZZZZZ"; 
  --when others=>current_sta<=clr_lcd; 
  end case; 
  end if; 
  end process; 
                   


end Behavioral;

