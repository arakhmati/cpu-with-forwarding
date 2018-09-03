library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
use work.components.all;

entity RegID_EX is
    port ( 
           clk             : in  std_logic;
			  id_reg_file_out : in reg_file_out_t;
			  id_control      : in control_signals_t;
			  ex_reg_file_out : out reg_file_out_t;
			  ex_control      : out ex_control_signals_t
			 );
end RegID_EX;

architecture Behavioral of RegID_EX is

begin

	process(clk, id_reg_file_out, id_control)
	begin 
		if rising_edge(clk) then
			ex_reg_file_out.src_1 <= id_reg_file_out.src_1;
			ex_reg_file_out.src_2 <= id_reg_file_out.src_2;
			
			ex_control.op_code               <= id_control.op_code;
			ex_control.reg_file_in_we        <= id_control.reg_file_in_we;
			ex_control.reg_file_in_sel_src_1 <= id_control.reg_file_in_sel_src_1;
			ex_control.reg_file_in_sel_src_2 <= id_control.reg_file_in_sel_src_2;
			ex_control.reg_file_in_sel_dst   <= id_control.reg_file_in_sel_dst;
			ex_control.alu_in_c_in           <= id_control.alu_in_c_in;
			ex_control.alu_in_sel	         <= id_control.alu_in_sel;			 
			ex_control.alu_src_2_sel_mux     <= id_control.alu_src_2_sel_mux;	 
			ex_control.immediate	            <= id_control.immediate;			
			ex_control.d_mem_input_we 	      <= id_control.d_mem_input_we;	
			ex_control.reg_file_data_in_mux  <= id_control.reg_file_data_in_mux;
			ex_control.disp_reg_we           <= id_control.disp_reg_we;
			
		end if;
	end process;
	
end Behavioral;


