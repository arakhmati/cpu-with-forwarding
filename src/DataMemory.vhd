library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.components.all;

entity DataMemory is
	generic (
		 D_WIDTH : integer := 16;
		 A_WIDTH : integer := 8
		 ); 
	port (
		 clk    : in  std_logic; 
		 input  : in mem_in_t;
		 output : out std_logic_vector(D_WIDTH-1 downto 0)
	);
end DataMemory;

architecture Behavioural of DataMemory is

	type memType is array(0 to 2**A_WIDTH-1) of std_logic_vector(D_WIDTH-1 downto 0);
	signal memory: memType:=
		 (
		 x"0002",
		 others => (others => '0') 
		 );
		 
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if(input.we = '1') then
				memory(conv_integer(input.addr)) <= input.data;
			end if;
		end if;
	end process;

	output <= memory(conv_integer(input.addr));
end Behavioural;