library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
use work.components.all;

entity ALU_src_2_mux is
	generic (D_WIDTH : integer);
	port ( 
           hazard          : in  hazard_t;
			  ex_control      : in  ex_control_signals_t;
			  ex_reg_file_out : in  reg_file_out_t;
			  mem_alu_out     : in  alu_out_t;
			  wb_control      : in  wb_control_signals_t;
			  wb_alu_out      : in  alu_out_t;
			  wb_d_mem_output : in std_logic_vector (D_WIDTH-1 downto 0);
			  alu_in_src_2    : out std_logic_vector (D_WIDTH-1 downto 0) := (others => '0')
			 );
end ALU_src_2_mux;

architecture Behavioral of ALU_src_2_mux is
begin

	process(hazard, ex_control, ex_reg_file_out, mem_alu_out, wb_alu_out, wb_d_mem_output)
	begin
		if ex_control.alu_src_2_sel_mux = '0' then  -- alu src2 mux
			if    hazard.wb_ex_2 = '1' then
				if wb_control.op_code = x"4" then -- `LOAD WORD` instruction
					alu_in_src_2 <= wb_d_mem_output;
				else
					alu_in_src_2 <= wb_alu_out.data;
				end if;
			elsif hazard.mem_ex_2 = '1' then
					alu_in_src_2 <= mem_alu_out.data;
			else
				alu_in_src_2 <= ex_reg_file_out.src_2;
			end if;
		else
			alu_in_src_2 <= ex_control.immediate;
		end if;
	end process;
	
end Behavioral;