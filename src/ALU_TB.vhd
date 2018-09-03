LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.All;

ENTITY ALU_TB IS
END ALU_TB;
 
ARCHITECTURE behavior OF ALU_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
	 generic (Width : integer);
    port(
         x : IN  std_logic_vector(15 downto 0);
         y : IN  std_logic_vector(15 downto 0);
         sel : IN  std_logic_vector(2 downto 0);
         c_in : IN  std_logic;
         z : OUT  std_logic_vector(15 downto 0);
         c_out : OUT  std_logic;
         lt : OUT  std_logic;
         overflow : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(15 downto 0) := (others => '0');
   signal y : std_logic_vector(15 downto 0) := (others => '0');
   signal sel : std_logic_vector(2 downto 0) := (others => '0');
   signal c_in : std_logic := '0';

 	--Outputs
   signal z : std_logic_vector(15 downto 0);
   signal c_out : std_logic;
   signal lt : std_logic;
   signal overflow : std_logic;
 
 
BEGIN
   uut: ALU 
			generic map(16)
			PORT MAP (
          x => x,
          y => y,
          sel => sel,
          c_in => c_in,
          z => z,
          c_out => c_out,
          lt => lt,
          overflow => overflow
        );
		  
   stim_proc: process
   begin		
	
		x <= "1000010111111110";
		y <= "0101101011110001";
		sel <= "000";
		c_in <= '0';
		wait for 20 ns;
		sel <= "001";
		wait for  20 ns;
		sel <= "011";
		wait for  20 ns;
		sel <= "010";
		wait for  20 ns;
		sel <= "101";
		wait for  20 ns;
		c_in <= '1';
		sel <= "100";
		wait for  20 ns;
		sel <= "110";
		wait for  20 ns;
		sel <= "111";
		
		wait for  20 ns;
		x <= "0000010111111110";
		y <= "0001101011110001";
		sel <= "000";
		c_in <= '0';
		wait for  20 ns;
		sel <= "001";
		wait for  20 ns;
		sel <= "011";		
		wait for  20 ns;
		sel <= "010";
		wait for  20 ns;
		sel <= "101";
		wait for  20 ns;
		c_in <= '1';
		sel <= "100";
		wait for  20 ns;
		sel <= "110";
		wait for  20 ns;
		sel <= "111";
		
		wait for  20 ns;
		x <= "1000010111111110";
		y <= "1101101011110001";
		sel <= "000";
		c_in <= '0';
		
		wait for 20 ns;
		sel <= "001";
		wait for  20 ns;
		sel <= "011";
		wait for  20 ns;
		sel <= "010";
		wait for  20 ns;
		sel <= "101";
		wait for  20 ns;
		c_in <= '1';
		sel <= "100";
		wait for  20 ns;
		sel <= "110";
		wait for  20 ns;
		sel <= "111";
		
		wait for  20 ns;
		x <= "0101101011110001";
		y <= "1000010111111110";
		sel <= "000";
		c_in <= '0';
		wait for 20 ns;
		sel <= "001";
		wait for  20 ns;
		sel <= "011";
		wait for  20 ns;
		sel <= "010";
		wait for  20 ns;
		sel <= "101";
		wait for  20 ns;
		c_in <= '1';
		sel <= "100";
		wait for  20 ns;
		sel <= "110";
		wait for  20 ns;
		sel <= "111";
		
		wait for  20 ns;
		x <= "0111101011110001";
		y <= "0111010111111110";
		sel <= "000";
		c_in <= '0';
		wait for 20 ns;
		sel <= "001";
		wait for  20 ns;
		sel <= "011";
		wait for  20 ns;
		sel <= "010";
		wait for  20 ns;
		sel <= "101";
		wait for  20 ns;
		c_in <= '1';
		sel <= "100";
		wait for  20 ns;
		sel <= "110";
		wait for  20 ns;
		sel <= "111";
	
      wait;
   end process;

END;
