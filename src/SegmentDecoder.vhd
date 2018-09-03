library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SegmentDecoder is
	port(
		sub_sequence : in std_logic_vector(3 downto 0) := (others => '0');
		segments : out std_logic_vector(6 downto 0) := (others => '0')
		);
end SegmentDecoder;

architecture DataFlow of SegmentDecoder is

begin

	-- top segement
	segments(0) <= NOT((NOT sub_sequence(2) AND not sub_sequence(0)) or (not sub_sequence(3) 
		and sub_sequence(1)) or (sub_sequence(2) and sub_sequence(1)) or (sub_sequence(3) 
		and not sub_sequence(1) and not sub_sequence(0)) or (sub_sequence(3) and not sub_sequence(2) 
		and not sub_sequence(1)) OR (not sub_sequence(3) and sub_sequence(2) and not sub_sequence(1) and  sub_sequence(0)));
			
	-- top right segement
	segments(1) <= NOT((not sub_sequence(3) and not sub_sequence(1) and not sub_sequence(0)) 
		or (not sub_sequence(3) and sub_sequence(1) and sub_sequence(0)) 
		or (sub_sequence(3) and not sub_sequence(1) and sub_sequence(0)) 
		or (not sub_sequence(2) and not sub_sequence(1)) or (not sub_sequence(2) and not sub_sequence(0)));
		
	-- bottom right segement
	segments(2) <= NOT((not sub_sequence(2) and not sub_sequence(1)) or (not sub_sequence(2) 
		and sub_sequence(0)) or (not sub_sequence(1) and sub_sequence(0))
		or (not sub_sequence(3) and sub_sequence(2)) or (sub_sequence(3) and not sub_sequence(2)));
	
	-- bottom segement	
	segments(3) <= NOT((not sub_sequence(2) and not sub_sequence(1) and not sub_sequence(0)) or (not sub_sequence(2) 
		and sub_sequence(1) and sub_sequence(0)) or (not sub_sequence(3) and sub_sequence(1) and not sub_sequence(0)) 
		or (sub_sequence(2) and not sub_sequence(1) and sub_sequence(0)) or (sub_sequence(3) and sub_sequence(2) 
		and not sub_sequence(0)) or (sub_sequence(3) and not sub_sequence(1)));
	
	-- bottom left segement
	segments(4) <= NOT((not sub_sequence(2) and not sub_sequence(0)) or (sub_sequence(1) and not sub_sequence(0)) 
		or (sub_sequence(3) and sub_sequence(2)) or (sub_sequence(3) and sub_sequence(1)));					
	
	-- top left segement
	segments(5) <= NOT((not sub_sequence(1) and not sub_sequence(0)) or (not sub_sequence(3) and sub_sequence(2)) 
		or (sub_sequence(3) and sub_sequence(1)) or (sub_sequence(3) and not sub_sequence(2)));
			
	-- middle segment
	segments(6) <= NOT((NOT sub_sequence(3) AND sub_sequence(2) AND NOT sub_sequence(1)) OR (sub_sequence(3) AND NOT sub_sequence(2))
		OR (sub_sequence(3) AND sub_sequence(0)) OR (sub_sequence(3) AND sub_sequence(1)) OR(NOT sub_sequence(2) AND sub_sequence(1))
		OR(sub_sequence(1) AND NOT sub_sequence(0)));

end DataFlow;
