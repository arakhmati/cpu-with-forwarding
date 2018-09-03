library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.components.all;

entity TopLevel is
	port ( 
		clk        : in  std_logic;
		manual_clk : in  std_logic;
		segments   : out std_logic_vector(6 downto 0) := (others => '0');
		digits     : out std_logic_vector(3 downto 0) := (others => '0')
		);
end TopLevel;

architecture Structural of TopLevel is

	-- Debouncer Signals
	signal debounced_clk : std_logic;
	
	-- Program Counter Signals
	signal pc_out : std_logic_vector (A_WIDTH-1 downto 0);
	
	-- Instruction Memory Signals
	signal i_mem_input  : mem_in_t;
	signal instruction : std_logic_vector (D_WIDTH-1 downto 0);
	
	-- Data Memory Signals
	signal d_mem_input  : mem_in_t;
	signal d_mem_output : std_logic_vector (D_WIDTH-1 downto 0);
	
	-- ALU Signals
	signal alu_in_src_1, alu_in_src_2 : std_logic_vector (D_WIDTH-1 downto 0);
	signal alu_in  : alu_in_t;
	signal alu_out : alu_out_t;
	
	-- Display Signals
	signal display_reg_out : std_logic_vector (D_WIDTH-1 downto 0);
	
	-- Control Signals
	signal id_control : control_signals_t;
	
	-- Register file
	signal reg_file_in  : reg_file_in_t;
	signal reg_file_out : reg_file_out_t;
	
	-- IF
	signal if_instruction : std_logic_vector (D_WIDTH-1 downto 0);
	
	-- ID
	signal id_instruction : std_logic_vector (D_WIDTH-1 downto 0);
	
	-- EX
	signal ex_reg_file_out : reg_file_out_t;
	signal ex_control      : ex_control_signals_t;
	
	-- MEM
	signal mem_alu_out : alu_out_t;
	signal mem_control : mem_control_signals_t;
	signal mem_reg_file_out : reg_file_out_t;
	
	-- WB
	signal wb_alu_out : alu_out_t;
	signal wb_control : wb_control_signals_t;
	signal wb_reg_file_out : reg_file_out_t;
	signal wb_d_mem_output : std_logic_vector (D_WIDTH-1 downto 0);
	
	-- Hazard Detector
	signal hazard : hazard_t;
	
	-- Stall signal
	signal stall : std_logic;
	
begin

	Deb : Debouncer generic map (DEBOUNCER_FREQUENCY) port map(clk, manual_clk, debounced_clk);

	-- Increment program counter only if the instruction is not `LOAD WORD`
	stall <= '1' when id_control.op_code = x"4" else '0';
	ProgramCounter : Counter generic map(A_WIDTH) port map(debounced_clk, not stall, pc_out);
	
	-- IF -----------------------------------------------------------------------------------------------------------------------
	i_mem_input.we   <= '0';
	i_mem_input.addr <= pc_out;
	i_mem_input.data <= (others => '0');
	IMemory : InstructionMemory generic map(D_WIDTH, A_WIDTH) port map(debounced_clk, i_mem_input, instruction);
	
	 -- Stall the pipeline on `LOAD WORD` instruction
	if_instruction <= x"ffff" when stall = '1' else instruction;
	
	-- Reg IF/ID-----------------------------------------------------------------------------------------------------------------------
	IF_ID : RegIF_ID generic map(D_WIDTH) port map(debounced_clk, if_instruction, id_instruction);
	-- ID -------------------------------------------------------------------------------------------------------------------------
	Decoder: InstructionDecoder generic map(D_WIDTH) port map(id_instruction, id_control);
	reg_file_in.we        <= wb_control.reg_file_in_we;
	reg_file_in.sel_src_1 <= id_control.reg_file_in_sel_src_1;
	reg_file_in.sel_src_2 <= id_control.reg_file_in_sel_src_2;
	reg_file_in.sel_dst   <= wb_control.reg_file_in_sel_dst;
	reg_file_in.data      <= wb_d_mem_output when wb_control.reg_file_data_in_mux = '0' else wb_alu_out.data; -- reg file data in mux
	RegFile : RegisterFile generic map(N_REGISTERS, D_WIDTH) port map(debounced_clk, reg_file_in, reg_file_out);
	
	-- Reg ID/EX -----------------------------------------------------------------------------------------------------------------------
	ID_EX : RegID_EX port map(debounced_clk, reg_file_out, id_control, ex_reg_file_out, ex_control);
	-- EX -------------------------------------------------------------------------------------------------------------------------
	
	-- Muxes for selecting ALU inputs and resolve data hazards
	ALU_src_1_m : ALU_src_1_mux generic map(D_WIDTH) port map(hazard, ex_reg_file_out, mem_alu_out, 
																				wb_control, wb_alu_out, wb_d_mem_output, alu_in_src_1);
	ALU_src_2_m : ALU_src_2_mux generic map(D_WIDTH) port map(hazard, ex_control, ex_reg_file_out, mem_alu_out, 
																				wb_control, wb_alu_out, wb_d_mem_output, alu_in_src_2);
	
	alu_in.src_1 <= alu_in_src_1;
	alu_in.src_2 <= alu_in_src_2;
	alu_in.sel   <= ex_control.alu_in_sel;
	alu_in.c_in  <= ex_control.alu_in_c_in;
	ArithLogicUnit : ALU generic map(D_WIDTH, ALU_SEL_SIZE) port map(alu_in, alu_out);
	
	
	-- EX/MEM -----------------------------------------------------------------------------------------------------------------------
	EX_MEM : RegEX_MEM generic map(D_WIDTH) port map(debounced_clk, ex_reg_file_out,  alu_out,     ex_control, 
																						 mem_reg_file_out, mem_alu_out, mem_control);
	-- MEM -------------------------------------------------------------------------------------------------------------------------
	d_mem_input.we   <= mem_control.d_mem_input_we;
	d_mem_input.addr <= mem_alu_out.data(A_WIDTH - 1 downto 0);
	d_mem_input.data <= mem_reg_file_out.src_2;
	DMemory : DataMemory generic map(D_WIDTH, A_WIDTH) port map(debounced_clk, d_mem_input, d_mem_output);
	
	-- Reg MEM/WB -----------------------------------------------------------------------------------------------------------------------
	MEM_WB : RegMEM_WB generic map(D_WIDTH) port map(debounced_clk, mem_reg_file_out, mem_alu_out, d_mem_output,    mem_control,
															                      wb_reg_file_out,  wb_alu_out,  wb_d_mem_output, wb_control);
	-- WB -------------------------------------------------------------------------------------------------------------------------
	DisplayRegister : RegisterN generic map(D_WIDTH) port map(clk, wb_control.disp_reg_we, wb_alu_out.data, display_reg_out);
	DigControl : DigitController generic map(FREQUENCY) port map(clk, display_reg_out, segments, digits);
	
--	-- Hazard Detector ------------------------------------------------------------------------------------------------------------------
	DHDetector : DataHazardDetector port map(ex_control, mem_control, wb_control, hazard);
	
end Structural;