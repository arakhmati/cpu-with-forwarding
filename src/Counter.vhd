library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

entity Counter is
	 generic(D_WIDTH : integer := 16);
    port ( 
           clk : in  std_logic;
			  we : in std_logic;
           q : out  std_logic_vector (D_WIDTH - 1 downto 0) := (others => '0')
			 );
end Counter;

architecture Behavioral of Counter is

	signal counter_value : std_logic_vector (D_WIDTH - 1 downto 0) := (others => '0');

begin

	process(clk, counter_value)
	begin 
		if rising_edge(clk) then
			if we = '1' then
				counter_value <= counter_value + 1;
			end if;
		end if;
	
		q <= counter_value;
	end process;

end Behavioral;