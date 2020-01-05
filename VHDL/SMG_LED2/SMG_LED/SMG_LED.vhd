--www.21eda.net
--Email: sz21eda@126.com
--one Digital tube display
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

entity SMG_LED is

port( 
      led_bit :out std_logic;                   --one Digital tube display
      led_out :out std_logic_vector(7 downto 0) --
    ); 
	 
end SMG_LED;

architecture Behavioral of SMG_LED is
begin  
  led_bit<= '0';             --ʹ�����1���ڵ�ͨ״̬
  led_out <="11111001";      --�ڸ�����ܵ�1�Ķ������ȥ
                             --������޸�7�����ֵ������ʾ��Ҫ��ʾ�����ֻ����ַ�

end Behavioral;

