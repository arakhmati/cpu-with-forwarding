-- VHDL Code For Debouncer Provided in ENGG2410 - Lab 7

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Debouncer is
	generic (DEBOUNCER_FREQUENCY : integer);
	port ( 
		clk : in  STD_LOGIC;
		button : in  STD_LOGIC;
		debouncedButton : out  STD_LOGIC
		  );
end Debouncer;

architecture Behavioral of Debouncer is
	signal d1, d2, cout : std_logic;
	signal count : std_logic_vector(DEBOUNCER_FREQUENCY downto 0) := (others => '0');
begin


	FF: process(clk)
	begin
		if(clk'event and clk = '1') then
			d1 <= button;
			d2 <= d1;
			if(cout = '1') then
				debouncedButton <= d2;
			end if;
		end if;
	end process;

	CNTR: process(clk)
	begin
		if (clk'event and clk='1') then
			if (cout = '0') then
				count <= count + 1;
			end if;
		end if;
	end process;

	cout <= count(DEBOUNCER_FREQUENCY);

end Behavioral;