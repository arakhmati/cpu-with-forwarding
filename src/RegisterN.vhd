library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

entity RegisterN is
	 generic(Width : integer);
    port ( 
           clk : in  std_logic;
           we : in  std_logic;
			  d : in  std_logic_vector (Width - 1 downto 0);
           q : out  std_logic_vector (Width - 1 downto 0) := (others => '0')
			 );
end RegisterN;

architecture Behavioral of RegisterN is

begin

	process(clk, we, d)
	begin 
		if rising_edge(clk) then
			if(we = '1') then
				q <= d;
			end if;
		end if;
	end process;

end Behavioral;