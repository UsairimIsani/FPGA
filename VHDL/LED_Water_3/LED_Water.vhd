--www.21eda.net
--Email: sz21eda@126.com
--LED dsiplay

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity LED_Water is
                                      
     PORT(
          clk:in STD_LOGIC;          --clk 50M                          
          led1:out STD_LOGIC_VECTOR(11 DOWNTO 0));    --LED output 
			 
end LED_Water;
--/////////////////////////////////////////////////////
architecture Behavioral of LED_Water is
SIGNAL clk1 :std_logic;                                       
BEGIN                                                                  
P1:PROCESS (clk)                                              
VARIABLE count:INTEGER RANGE  0 TO 9999999;
BEGIN                                                                
    IF clk'EVENT AND clk='1' THEN                            --��ʱ�����������ص���ʱִ���������
       IF count<=4999999 THEN                           
          clk1<='0';                                          --��count<=4999999ʱdivls=0����count��1
          count:=count+1;                          
        ELSIF count>=4999999 AND count<=9999999 THEN            --��ount>=4999999 ���� count<=9999998ʱ
               clk1<='1';                                            --                             
               count:=count+1;                                --clk1=1����count��1
        ELSE count:=0;                                        --��count>=4999999ʱ����count1
        END IF;                                                      
     END IF;                                          
END PROCESS ;        
  
---------------------------------------------------------
P2:PROCESS(clk1)                                              
variable count1:INTEGER RANGE 0 TO 17;                         --��������ͱ�������������
BEGIN                                                                --                                                 
IF clk1'event AND clk1='1'THEN                                 --��ʱ�����������ص���ʱִ���������
   if count1<=17 then                                          --��COUNT1<=8ʱִ���������
      if count1=16 then                                        --��COUNT1=7ʱ��COUNT1����
         count1 :=0;                                                 --
      end if;                                                            --
      CASE count1 IS                                             --CASE�������LED1��ֵ
      WHEN 0=>led1<="000000000000";                        --���ε������������
      WHEN 1=>led1<="111000000111";                        -- 
      WHEN 2=>led1<="111100001111";                        --
      WHEN 3=>led1<="111110011111";                        --
      WHEN 4=>led1<="111111111111";                        --
      WHEN 5=>led1<="111110011111";                        --
      WHEN 6=>led1<="111100001111";                        --
      WHEN 7=>led1<="111000000111"; 	
	   WHEN 8=>led1<="110000000011";                        --���ε������������
      WHEN 9=>led1<="110001100011";                        -- 
      WHEN 10=>led1<="110011110011";                        --
      WHEN 11=>led1<="110111111011";                        --
      WHEN 12=>led1<="111111111111";                        --
      WHEN 13=>led1<="111110011111";                        --
      WHEN 14=>led1<="111100001111";                        --
      WHEN 15=>led1<="111000000111"; 	
      WHEN OTHERS=>led1<="111111111111";              
      END CASE;                                                     
      count1:=count1+1;                                   
    end if;                                                                     
end if;                                                                        
end process;        

end Behavioral;
