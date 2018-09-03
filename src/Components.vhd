library IEEE;
use IEEE.STD_LOGIC_1164.all;

package Components is

	constant D_WIDTH             : integer := 16;
	constant A_WIDTH             : integer := 8;
	constant N_REGISTERS         : integer := 3;
	constant FREQUENCY           : integer := 1;
	constant DEBOUNCER_FREQUENCY : integer := 1;
	constant ALU_SEL_SIZE        : integer := 3;
	
	type reg_file_in_t is record
		we        : std_logic;
		sel_src_1 : std_logic_vector (N_REGISTERS - 1 downto 0);
		sel_src_2 : std_logic_vector (N_REGISTERS - 1 downto 0);
		sel_dst   : std_logic_vector (N_REGISTERS - 1 downto 0);
		data      : std_logic_vector (D_WIDTH - 1 downto 0);
	end record;
	
	type reg_file_out_t is record
		src_1 :  std_logic_vector (D_WIDTH - 1 downto 0);
		src_2 :  std_logic_vector (D_WIDTH - 1 downto 0);
	end record;
	
	type mem_in_t is record
		we   : std_logic;
		addr : std_logic_vector (A_WIDTH - 1 downto 0);
		data : std_logic_vector (D_WIDTH - 1 downto 0);
	end record;
	
	type alu_in_t is record
		src_1 : std_logic_vector (D_WIDTH - 1 downto 0);
		src_2 : std_logic_vector (D_WIDTH - 1 downto 0);
		sel   : std_logic_vector (ALU_SEL_SIZE - 1 downto 0);
		c_in  : std_logic;
	end record;
	
	type alu_out_t is record
		data     :  std_logic_vector (D_WIDTH - 1 downto 0);
		c_out    :  std_logic;
		overflow :  std_logic;
		lt       :  std_logic;
	end record;
	
	type hazard_t is record
		mem_ex_1 : std_logic;
		mem_ex_2 : std_logic;
		wb_ex_1  : std_logic;
		wb_ex_2  : std_logic;
	end record;
	
	type control_signals_t is record
		op_code               : std_logic_vector(3 downto 0);
		alu_in_c_in           : std_logic;
		reg_file_in_we			 : std_logic;
		reg_file_in_sel_src_1 : std_logic_vector (N_REGISTERS - 1 downto 0);
		reg_file_in_sel_src_2 : std_logic_vector (N_REGISTERS - 1 downto 0);
		reg_file_in_sel_dst   : std_logic_vector (N_REGISTERS - 1 downto 0);
		alu_in_sel				 : std_logic_vector (ALU_SEL_SIZE - 1 downto 0);
		alu_src_2_sel_mux		 : std_logic;
		immediate				 : std_logic_vector (D_WIDTH - 1 downto 0);
		d_mem_input_we 		 : std_logic;
		reg_file_data_in_mux  : std_logic;
		disp_reg_we           : std_logic;
	end record;
	
	-- EX Controls
	type ex_control_signals_t is record
		op_code               : std_logic_vector(3 downto 0);
		reg_file_in_we			 : std_logic;
		reg_file_in_sel_src_1 : std_logic_vector (N_REGISTERS - 1 downto 0);
		reg_file_in_sel_src_2 : std_logic_vector (N_REGISTERS - 1 downto 0);
		reg_file_in_sel_dst   : std_logic_vector (N_REGISTERS - 1 downto 0);
		alu_in_c_in           : std_logic;
		alu_in_sel				 : std_logic_vector (ALU_SEL_SIZE - 1 downto 0);
		alu_src_2_sel_mux		 : std_logic;
		immediate				 : std_logic_vector (D_WIDTH - 1 downto 0);
		d_mem_input_we 		 : std_logic;
		reg_file_data_in_mux  : std_logic;
		disp_reg_we           : std_logic;
	end record;
	
	-- MEM Controls
	type mem_control_signals_t is record
		op_code               : std_logic_vector(3 downto 0);
		reg_file_in_we			 : std_logic;
		reg_file_in_sel_dst   : std_logic_vector (N_REGISTERS - 1 downto 0);
		d_mem_input_we 		 : std_logic;
		reg_file_data_in_mux  : std_logic;
		disp_reg_we           : std_logic;
	end record;
	
	-- WB Controls
	type wb_control_signals_t is record
		op_code               : std_logic_vector(3 downto 0);
		reg_file_in_we			 : std_logic;
		reg_file_in_sel_dst   : std_logic_vector (N_REGISTERS - 1 downto 0);
		reg_file_data_in_mux  : std_logic;
		disp_reg_we           : std_logic;
	end record;
	
	component Debouncer is
		generic (DEBOUNCER_FREQUENCY : integer);
		port ( 
			clk : in  STD_LOGIC;
			button : in  STD_LOGIC;
			debouncedButton : out  STD_LOGIC
			  );
	end component;

	component RegisterN is
		generic (WIDTH : integer);
		port ( 
             clk : in  std_logic;
             we : in  std_logic;
			    d : in  std_logic_vector(WIDTH - 1 downto 0);
             q : out  std_logic_vector(WIDTH - 1 downto 0)
			  );
	end component;
	
	component Counter is
		generic(D_WIDTH : integer);
		port ( 
           clk : in  std_logic;
			  we : in std_logic;
           q : out  std_logic_vector (D_WIDTH - 1 downto 0) := (others => '0')
			 );
	end component;
	
	component InstructionDecoder is
		generic(
			D_WIDTH : integer
		);
		port ( 
			instruction : in   std_logic_vector(D_WIDTH - 1 downto 0);
			control     : out control_signals_t
		);
	end component;

	component ALU is
		generic(
			D_WIDTH      : integer;
			ALU_SEL_SIZE : integer
			);
		port( 
			input : in alu_in_t;
			output: out alu_out_t
			);
	end component;
	
	component InstructionMemory is
		generic (
			 D_WIDTH : integer := 16;
			 A_WIDTH : integer := 8
			 ); 
		port (
			 clk    : in  std_logic; 
			 input  : in mem_in_t;
			 output : out std_logic_vector(D_WIDTH-1 downto 0)
		);
	end component;
	
	component DataMemory is
		generic (
			D_WIDTH : integer;
			A_WIDTH : integer
			);
		port (
			clk    : in std_logic;
			input  : in mem_in_t;
			output : out std_logic_vector(D_WIDTH-1 downto 0)
			);
	end component;
	
	component DigitController is
		generic (FREQUENCY : integer);
		port( 
			clk      : in  std_logic;
			sequence : in std_logic_vector(15 downto 0);
			segments : out std_logic_vector(6 downto 0);
			digits   : out std_logic_vector(3 downto 0)
			);
	end component;
	
	component RegisterFile is
	generic (
			N_REGISTERS : integer;
			D_WIDTH : integer
			);
	port ( 
			clk    : in   std_logic;
			input  : in  reg_file_in_t;
			output : out reg_file_out_t
			);
	end component;
	
	
-------------------------------------------------------------------
 -- REG IF/ID
	component RegIF_ID is
		generic (WIDTH : integer);
		port ( 
             clk : in  std_logic;
				 d : in  std_logic_vector(WIDTH - 1 downto 0);
             q : out  std_logic_vector(WIDTH - 1 downto 0)
			  );
	end component;
	
-- Reg ID/EX
	component RegID_EX is
    port ( 
           clk             : in  std_logic;
			  id_reg_file_out : in reg_file_out_t;
			  id_control      : in control_signals_t;
			  ex_reg_file_out : out reg_file_out_t;
			  ex_control      : out ex_control_signals_t
			 );
	end component;


-- Reg EX/MEM
	component RegEX_MEM is
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
	end component;

-- Reg MEM/WB
	component RegMEM_WB is
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
	end component;
	
	component DataHazardDetector is
	port ( 
		ex_control  : in  ex_control_signals_t;
		mem_control : in  mem_control_signals_t;
		wb_control  : in  wb_control_signals_t;
		hazard      : out hazard_t := (others => '0')
		);
	end component;
	
	component ALU_src_1_mux is
		generic (D_WIDTH : integer);
		port ( 
           hazard          : in  hazard_t;
			  ex_reg_file_out : in  reg_file_out_t;
			  mem_alu_out     : in  alu_out_t;
			  wb_control      : in  wb_control_signals_t;
			  wb_alu_out      : in  alu_out_t;
			  wb_d_mem_output : in  std_logic_vector (D_WIDTH-1 downto 0);
			  alu_in_src_1    : out std_logic_vector (D_WIDTH-1 downto 0)
			 );
	end component;
	
	component ALU_src_2_mux is
		generic (D_WIDTH : integer);
		port ( 
           hazard          : in  hazard_t;
			  ex_control      : in  ex_control_signals_t;
			  ex_reg_file_out : in  reg_file_out_t;
			  mem_alu_out     : in  alu_out_t;
			  wb_control      : in  wb_control_signals_t;
			  wb_alu_out      : in  alu_out_t;
			  wb_d_mem_output : in  std_logic_vector (D_WIDTH-1 downto 0);
			  alu_in_src_2    : out std_logic_vector (D_WIDTH-1 downto 0)
			 );
	end component;


end Components;

package body Components is

 
end Components;
