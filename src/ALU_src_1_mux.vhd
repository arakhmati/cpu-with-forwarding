library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
use work.components.all;

entity ALU_src_1_mux is
	generic (D_WIDTH : integer);
	port ( 
           hazard          : in  hazard_t;
			  ex_reg_file_out : in  reg_file_out_t;
			  mem_alu_out     : in  alu_out_t;
			  wb_control      : in  wb_control_signals_t;
			  wb_alu_out      : in  alu_out_t;
			  wb_d_mem_output : in  std_logic_vector (D_WIDTH-1 downto 0);
			  alu_in_src_1    : out std_logic_vector (D_WIDTH-1 downto 0) := (others => '0')
			 );
end ALU_src_1_mux;

architecture Behavioral of ALU_src_1_mux is
begin

	process(hazard, ex_reg_file_out, mem_alu_out, wb_alu_out, wb_d_mem_output)
	begin
		if    hazard.wb_ex_1 = '1' then
			if wb_control.op_code = x"4" then -- `LOAD WORD` instruction
				alu_in_src_1 <= wb_d_mem_output;
			else
				alu_in_src_1 <= wb_alu_out.data;
			end if;
		elsif hazard.mem_ex_1 = '1' then
				alu_in_src_1 <= mem_alu_out.data;
		else
				alu_in_src_1 <= ex_reg_file_out.src_1;
		end if;
	end process;
	
end Behavioral;