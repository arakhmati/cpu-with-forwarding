library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

entity RegIF_ID is
	 generic(Width : integer);
    port ( 
           clk : in  std_logic;
			  d : in  std_logic_vector (Width - 1 downto 0);
           q : out  std_logic_vector (Width - 1 downto 0) := (others => '0')
			 );
end RegIF_ID;

architecture Behavioral of RegIF_ID is

begin

	process(clk, d)
	begin 
		if rising_edge(clk) then
			q <= d;
		end if;
	end process;
	
end Behavioral;