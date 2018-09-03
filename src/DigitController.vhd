library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity DigitController is
	generic (FREQUENCY : integer := 10);
	port( 
		clk : in  std_logic;
		sequence : in std_logic_vector(15 downto 0);
		segments : out std_logic_vector(6 downto 0) := (others => '0');
		digits   : out std_logic_vector(3 downto 0)
		);
end DigitController;

architecture Behavioral of DigitController is

	component SegmentDecoder is
		port(
			sub_sequence : in std_logic_vector(3 downto 0);
			segments : out std_logic_vector(6 downto 0)
			);
	end component;

	signal sub_sequence : std_logic_vector(3 downto 0);
	signal clkdiv : std_logic_vector(FREQUENCY downto 0) := (others => '0');
	signal en : std_logic_vector(3 downto 0) := "0111";
	
begin

	SegDecoder : SegmentDecoder port map(sub_sequence, segments);

	-- increases clkdiv every clock cycle
	process (clk) -- create system clock divider
	begin
		if rising_edge(clk) then	
			clkdiv <= clkdiv + 1;
		end if;	    
	end process;
	
	-- runs every 10 clock cycles
	process(clkdiv(FREQUENCY))			   
	begin
	if rising_edge(clkdiv(FREQUENCY)) then
		case en is		
			when "0111"  => 
			   -- outputs en to connect it to segment decoder
				digits <= en; 
				-- changes en so the program can get the next subs                                                                                                                                                                     tring
				en <= "1011";
				sub_sequence(3 downto 0) <= sequence(15 downto 12);
			when "1011"  => 
				-- outputs en to connect it to segment decoder
				digits <= en; 
				-- changes en so the program can get the next substring
				en <= "1101";
				sub_sequence(3 downto 0) <= sequence(11 downto 8);
			when "1101"  =>  
				-- outputs en to connect it to segment decoder
				digits <= en; 
				-- changes en so the program can get the next substring
				en <= "1110";
				sub_sequence(3 downto 0) <= sequence(7 downto 4);
			when "1110"  => 
				-- outputs en to connect it to segment decoder
				digits <= en; 
				-- changes en so the program can get the next substring
				en <= "0111";
				sub_sequence(3 downto 0) <= sequence(3 downto 0);
			when others  =>  
				en <= "0111";
		end case;
	end if;

	end process;

	
end Behavioral;

