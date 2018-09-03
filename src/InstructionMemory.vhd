library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.components.all;

entity InstructionMemory is
	generic (
		 D_WIDTH : integer := 16;
		 A_WIDTH : integer := 8
		 ); 
	port (
		 clk    : in  std_logic; 
		 input  : in mem_in_t;
		 output : out std_logic_vector(D_WIDTH-1 downto 0)
	);
end InstructionMemory;

architecture Behavioural of InstructionMemory is

	type memType is array(0 to 2**A_WIDTH-1) of std_logic_vector(D_WIDTH-1 downto 0);
	signal memory: memType:=
	(
		 x"4" & o"1" & o"0" & o"00",       -- LW   R1, R0(0)    R1=2  
		 x"0" & o"2" & o"1" & o"1" & o"3", -- UADD R2, R1, R1   R2=2+2=4   DATA HAZARD
		 x"3" & o"3" & o"2" & o"02",       -- SRL  R3, R2, 2    R3=4/4=1   DATA HAZARD
		 x"0" & o"1" & o"2" & o"3" & o"5", -- SUB  R1, R2, R3   R1=4-1=3   DATA HAZARD
		 x"5" & o"1" & o"0" & o"00",       -- SW   R1, R0(0)    mem[0]=3   DATA HAZARD
		 x"6" & o"4" & o"005",             -- Li   R4, 5        R4=5
		 x"0" & o"4" & o"4" & o"4" & o"4", -- SADD R4, R4, R4   R4=10
		 x"7" & o"1" & o"000",             -- OUT  R1  3
		 x"7" & o"2" & o"000",             -- OUT  R2  4
		 x"7" & o"3" & o"000",             -- OUT  R3  1  
		 x"7" & o"4" & o"000",             -- OUT  R4  10    
		  others => (others => '0') 
   );
		 
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if(input.we = '1') then
				memory(conv_integer(input.addr)) <= input.data;
			end if;
		end if;
	end process;

	output <= memory(conv_integer(input.addr));
	
end Behavioural;