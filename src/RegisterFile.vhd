library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.components.all;

entity RegisterFile is
	generic (
			N_REGISTERS : integer := 3;
			D_WIDTH : integer := 16
			);
	port ( 
			clk    : in   std_logic;
			input  : in reg_file_in_t;
			output : out reg_file_out_t
			);
end RegisterFile;

architecture Behavioral of RegisterFile is

	type mem_type is array(0 to 2**N_REGISTERS-1) of std_logic_vector(D_WIDTH - 1 downto 0);
	signal registers: mem_type:=
		( others => (others => '0') ); -- Initalized all registers to 0
	
	signal input_data : std_logic_vector(D_WIDTH - 1 downto 0);
	
begin

	-- R0 is a Zero Register
	input_data <= (others => '0') when input.sel_dst = o"0" else input.data;

	process(clk, registers, input, input_data)
	begin
		if rising_edge(clk) then
			if input.we = '1' then
				registers(conv_integer(input.sel_dst)) <= input_data;
			end if;
		end if;
			
		output.src_1 <= registers(conv_integer(input.sel_src_1));
		output.src_2 <= registers(conv_integer(input.sel_src_2));
	end process;
	
end Behavioral;



