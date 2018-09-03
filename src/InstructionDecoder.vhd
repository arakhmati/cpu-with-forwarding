library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity InstructionDecoder is
	generic(
		D_WIDTH : integer := 16
		);
	port ( 
		instruction : in  std_logic_vector(D_WIDTH - 1 downto 0);
		control     : out control_signals_t
		);
end InstructionDecoder;

architecture Behavioral of InstructionDecoder is

	signal op_code : std_logic_vector(3 downto 0);

begin

	process(instruction, op_code)
	begin
		op_code <= instruction(15 downto 12);
		control.op_code <= op_code;
		if op_code = x"0" then
			if instruction(2 downto 0) = o"5" then
				control.alu_in_c_in <= '1'; -- c_in should be 1 for signed subtraction
			else
				control.alu_in_c_in <= '0'; -- otherwise 0
			end if;
			control.reg_file_in_we <= '1';
			control.reg_file_in_sel_dst   <= instruction(11 downto 9); -- dst
			control.reg_file_in_sel_src_1 <= instruction(8 downto 6); -- src_1
			control.reg_file_in_sel_src_2 <= instruction(5 downto 3); -- src_2
			control.alu_in_sel <= instruction(2 downto 0); -- func_code
			control.alu_src_2_sel_mux <=  '0'; -- use reg_file.src_2 as 2nd input of ALU
			control.immediate <= (others => '0');
			control.d_mem_input_we <= '0'; -- do not write to data memory
			control.reg_file_data_in_mux <= '1'; -- Store output of ALU to Register File
			control.disp_reg_we <= '0'; -- Do not store to display register
			
		-- op_code x"1" is reserved for more ALU instructions
			
		elsif op_code = x"2" then -- Shift Logical Left
			control.alu_in_c_in <= '0';
			control.reg_file_in_we <= '1';
			control.reg_file_in_sel_dst   <= instruction(11 downto 9);
			control.reg_file_in_sel_src_1 <= instruction(8 downto 6);
			control.reg_file_in_sel_src_2 <= (others => '0');
			control.alu_in_sel <= o"6";
			control.alu_src_2_sel_mux <=  '1'; -- use immediate as 2nd input of ALU
			control.immediate <= std_logic_vector(resize(signed(instruction(5 downto 0)), D_WIDTH)); -- sign extend
			control.d_mem_input_we <= '0'; -- do not write to data memory
			control.reg_file_data_in_mux <= '1'; -- Store output of ALU to Register File
			control.disp_reg_we <= '0'; -- Do not store to display register
			
		elsif op_code = x"3" then -- Shift Logical Right
			control.alu_in_c_in <= '0';
			control.reg_file_in_we <= '1';
			control.reg_file_in_sel_dst   <= instruction(11 downto 9);
			control.reg_file_in_sel_src_1 <= instruction(8 downto 6);
			control.reg_file_in_sel_src_2 <= (others => '0');
			control.alu_in_sel <= o"7";
			control.alu_src_2_sel_mux <=  '1'; -- use immediate as 2nd input of ALU
			control.immediate <= std_logic_vector(resize(signed(instruction(5 downto 0)), D_WIDTH)); -- sign extend
			control.d_mem_input_we <= '0'; -- do not write to data memory
			control.reg_file_data_in_mux <= '1'; -- Store output of ALU to Register File
			control.disp_reg_we <= '0'; -- Do not store to display register
			
		elsif op_code = x"4" then -- Load Word
			control.alu_in_c_in <= '0';
			control.reg_file_in_we <= '1';
			control.reg_file_in_sel_dst   <= instruction(11 downto 9);
			control.reg_file_in_sel_src_1 <= instruction(8 downto 6);
			control.reg_file_in_sel_src_2 <= (others => '0');
			control.alu_in_sel <= o"4"; -- Select signed addition
			control.alu_src_2_sel_mux <=  '1'; -- use immediate as 2nd input of ALU
			control.immediate <= std_logic_vector(resize(signed(instruction(5 downto 0)), D_WIDTH)); -- sign extend
			control.d_mem_input_we <= '0'; -- do not write to data memory
			control.reg_file_data_in_mux <= '0'; -- Store output of Data Memory to Register File
			control.disp_reg_we <= '0'; -- Do not store to display register
			
		elsif op_code = x"5" then -- Store Word
			control.alu_in_c_in <= '0';
			control.reg_file_in_we <= '0';
			control.reg_file_in_sel_dst   <= (others => '0');
			control.reg_file_in_sel_src_1 <= instruction(8 downto 6);
			control.reg_file_in_sel_src_2 <= instruction(11 downto 9);
			control.alu_in_sel <= o"4"; -- Select signed addition
			control.alu_src_2_sel_mux <=  '1'; -- use immediate as 2nd input of ALU
			control.immediate <= std_logic_vector(resize(signed(instruction(5 downto 0)), D_WIDTH)); -- sign extend
			control.d_mem_input_we <= '1'; -- do not write to data memory
			control.reg_file_data_in_mux <= '0'; -- don`t care
			control.disp_reg_we <= '0'; -- Do not store to display register
			
		elsif op_code = x"6" then -- Load Immediate
			control.alu_in_c_in <= '0';
			control.reg_file_in_we <= '1';
			control.reg_file_in_sel_dst   <= instruction(11 downto 9);
			control.reg_file_in_sel_src_1 <= (others => '0'); -- Select zero register
			control.reg_file_in_sel_src_2 <= (others => '0');
			control.alu_in_sel <= o"4"; -- Select signed addition
			control.alu_src_2_sel_mux <=  '1'; -- use immediate as 2nd input of ALU
			control.immediate <= std_logic_vector(resize(signed(instruction(8 downto 0)), D_WIDTH)); -- sign extend
			control.d_mem_input_we <= '0'; -- do not write to data memory
			control.reg_file_data_in_mux <= '1'; -- Store output of ALU to Register File
			control.disp_reg_we <= '0'; -- Do not store to display register
			
		elsif op_code = x"7" then -- OUT Instruction
			control.alu_in_c_in <= '0';
			control.reg_file_in_we <= '0';
			control.reg_file_in_sel_dst   <= (others => '0');
			control.reg_file_in_sel_src_1 <= instruction(11 downto 9); -- Register to display
			control.reg_file_in_sel_src_2 <= (others => '0'); -- Select zero register
			control.alu_in_sel <= o"1"; -- Select OR
			control.alu_src_2_sel_mux <=  '1'; -- use immediate as 2nd input of ALU
			control.immediate <= (others => '0'); -- sign extend
			control.d_mem_input_we <= '0'; -- do not write to data memory
			control.reg_file_data_in_mux <= '0'; -- don`t care
			control.disp_reg_we <= '1'; -- Store to display register
			
		else -- Not an Instruction
			control.alu_in_c_in <= '0';
			control.reg_file_in_we <= '0';
			control.reg_file_in_sel_dst   <= (others => '0');
			control.reg_file_in_sel_src_1 <= (others => '0'); -- Select zero register
			control.reg_file_in_sel_src_2 <= (others => '0');
			control.alu_in_sel <= (others => '0');
			control.alu_src_2_sel_mux <=  '0'; -- use immediate as 2nd input of ALU
			control.immediate <= (others => '0'); -- sign extend
			control.d_mem_input_we <= '0'; -- do not write to data memory
			control.reg_file_data_in_mux <= '0'; -- Store output of Data Memory to Register File
			control.disp_reg_we <= '0'; -- Do not store to display register
			
		end if;
		
	end process;
	
	
end Behavioral;