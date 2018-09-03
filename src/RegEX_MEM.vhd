library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
use work.components.all;

entity RegEX_MEM is
	 generic (WIDTH : integer);
    port ( 
           clk              : in  std_logic;
			  ex_reg_file_out  : in reg_file_out_t;
			  ex_alu_out       : in alu_out_t;
			  ex_control       : in ex_control_signals_t;
			  mem_reg_file_out : out reg_file_out_t;
			  mem_alu_out      : out alu_out_t;
			  mem_control      : out mem_control_signals_t
			 );
end RegEX_MEM;

architecture Behavioral of RegEX_MEM is

begin

	process(clk, ex_alu_out, ex_control)
	begin 
		if rising_edge(clk) then
			mem_reg_file_out.src_1 <= ex_reg_file_out.src_1;
			mem_reg_file_out.src_2 <= ex_reg_file_out.src_2;
		
			mem_alu_out.data     <= ex_alu_out.data;
			mem_alu_out.c_out    <= ex_alu_out.c_out;
			mem_alu_out.overflow <= ex_alu_out.overflow;
			mem_alu_out.lt       <= ex_alu_out.lt;
					
			mem_control.op_code              <= ex_control.op_code;
			mem_control.reg_file_in_we       <= ex_control.reg_file_in_we;
			mem_control.reg_file_in_sel_dst  <= ex_control.reg_file_in_sel_dst;
			mem_control.d_mem_input_we 	   <= ex_control.d_mem_input_we;	
			mem_control.reg_file_data_in_mux <= ex_control.reg_file_data_in_mux;
			mem_control.disp_reg_we          <= ex_control.disp_reg_we;
			
			
		end if;
	end process;
	
end Behavioral;


