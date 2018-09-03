library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity DataHazardDetector is
	port ( 
		ex_control  : in  ex_control_signals_t;
		mem_control : in  mem_control_signals_t;
		wb_control  : in  wb_control_signals_t;
		hazard      : out hazard_t := (others => '0')
		);
end DataHazardDetector;

architecture Behavioral of DataHazardDetector is
begin

	process(ex_control, mem_control)
	begin
		if    mem_control.reg_file_in_sel_dst = o"0" or ex_control.reg_file_in_sel_src_1 = o"0"  then
				hazard.mem_ex_1 <= '0';
		elsif    mem_control.reg_file_in_sel_dst = ex_control.reg_file_in_sel_src_1 then
				hazard.mem_ex_1 <= '1';
		else
				hazard.mem_ex_1 <= '0';
		end if;
	end process;
	
	process(ex_control, mem_control)
	begin
		if    mem_control.reg_file_in_sel_dst = o"0" or ex_control.reg_file_in_sel_src_2 = o"0"  then
				hazard.mem_ex_2 <= '0';
		elsif    mem_control.reg_file_in_sel_dst = ex_control.reg_file_in_sel_src_2 then
				hazard.mem_ex_2 <= '1';
		else
				hazard.mem_ex_2 <= '0';
		end if;
	end process;
	
	process(ex_control, wb_control)
	begin
		if    wb_control.reg_file_in_sel_dst = o"0" or ex_control.reg_file_in_sel_src_1 = o"0"  then
				hazard.wb_ex_1 <= '0';
		elsif    wb_control.reg_file_in_sel_dst = ex_control.reg_file_in_sel_src_1 then
				hazard.wb_ex_1 <= '1';
		else
				hazard.wb_ex_1 <= '0';
		end if;
	end process;
	
	process(ex_control, wb_control)
	begin
		if    wb_control.reg_file_in_sel_dst = o"0" or ex_control.reg_file_in_sel_src_2 = o"0"  then
				hazard.wb_ex_2 <= '0';
		elsif    wb_control.reg_file_in_sel_dst = ex_control.reg_file_in_sel_src_2 then
				hazard.wb_ex_2 <= '1';
		else
				hazard.wb_ex_2 <= '0';
		end if;
	end process;
	
	
end Behavioral;