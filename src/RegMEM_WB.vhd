library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
use work.components.all;

entity RegMEM_WB is
	 generic (WIDTH : integer);
    port ( 
           clk                    : in  std_logic;
			  mem_reg_file_out       : in reg_file_out_t;
			  mem_alu_out            : in alu_out_t;
			  mem_d_mem_output       : in std_logic_vector (D_WIDTH-1 downto 0);
			  mem_control            : in mem_control_signals_t;
			  wb_reg_file_out        : out reg_file_out_t;
			  wb_alu_out             : out alu_out_t;
			  wb_d_mem_output        : out std_logic_vector (D_WIDTH-1 downto 0);
			  wb_control             : out wb_control_signals_t
			 );
end RegMEM_WB;

architecture Behavioral of RegMEM_WB is

begin

	process(clk, mem_alu_out, mem_d_mem_output, mem_control)
	begin 
		if rising_edge(clk) then
			wb_reg_file_out.src_1 <= mem_reg_file_out.src_1;
			wb_reg_file_out.src_2 <= mem_reg_file_out.src_2;
		
			wb_alu_out.data     <= mem_alu_out.data;
			wb_alu_out.c_out    <= mem_alu_out.c_out;
			wb_alu_out.overflow <= mem_alu_out.overflow;
			wb_alu_out.lt       <= mem_alu_out.lt;
					
			wb_control.op_code              <= mem_control.op_code;
			wb_control.reg_file_in_we       <= mem_control.reg_file_in_we;
			wb_control.reg_file_in_sel_dst  <= mem_control.reg_file_in_sel_dst;
			wb_control.reg_file_data_in_mux <= mem_control.reg_file_data_in_mux;
			wb_control.disp_reg_we          <= mem_control.disp_reg_we;
			
			wb_d_mem_output <= mem_d_mem_output;
			
		end if;
	end process;
	
end Behavioral;


