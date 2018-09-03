LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY TopLevel_TB IS
END TopLevel_TB;
 
ARCHITECTURE behavior OF TopLevel_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TopLevel
    PORT(
         clk : IN  std_logic;
			manual_clk : IN std_logic;
         segments : OUT  std_logic_vector(6 downto 0);
         digits : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal manual_clk : std_logic := '0';

 	--Outputs
   signal segments : std_logic_vector(6 downto 0) := "0000000";
   signal digits : std_logic_vector(3 downto 0) := "0000";

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TopLevel port map (clk, manual_clk, segments, digits);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	 -- Clock process definitions
   manual_clk_process :process
   begin
		manual_clk <= '0';
		wait for clk_period;
		manual_clk <= '1';
		wait for clk_period;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 1000 ns;
	end process;

END;
