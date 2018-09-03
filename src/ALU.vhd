library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.components.all;

entity ALU is
	generic(
		D_WIDTH    : integer := 16;
		ALU_SEL_SIZE : integer := 3
		);
	port( 
		input : in alu_in_t;
		output: out alu_out_t
		);
end ALU;

architecture Behavioral of ALU is

	signal xTemp : std_logic_vector (D_WIDTH downto 0);
	signal yTemp : std_logic_vector (D_WIDTH downto 0);	
	signal zTemp : std_logic_vector (D_WIDTH downto 0);
	
	-- Input Signals
	signal x, y : std_logic_vector (D_WIDTH - 1 downto 0);
	signal sel  : std_logic_vector (ALU_SEL_SIZE - 1 downto 0);
	signal c_in : std_logic;
	
	-- Output Signals
	signal z : std_logic_vector (D_WIDTH - 1 downto 0);
	signal c_out : std_logic;
	signal overflow : std_logic;
	signal lt : std_logic;
	
begin

	x <= input.src_1;
	y <= input.src_2;
	sel <= input.sel;
	c_in <= input.c_in;

	process(x, y, sel, c_in, xTemp, yTemp, zTemp)
	begin 
		xTemp <= "XXXXXXXXXXXXXXXXX";
		yTemp <= "XXXXXXXXXXXXXXXXX";
		zTemp <= "XXXXXXXXXXXXXXXXX";
		overflow <= '0';
		c_out <= '0';
		
		if sel = "000" then -- and
			z <= x and y;
			
		elsif sel = "001" then -- or
			z <= x or y;
			
		elsif sel = "010" then -- xor
			z <= x xor y;
			
		elsif sel = "011" then -- unsigned addition
			xTemp(D_WIDTH - 1 downto 0) <= x;
			xTemp(D_WIDTH) <= '0';
			yTemp(D_WIDTH - 1 downto 0) <= y;
			yTemp(D_WIDTH) <= '0';
			
			zTemp <= xTemp + yTemp + c_in;
			z <= zTemp(D_WIDTH - 1 downto 0);
			
			if(zTemp(D_WIDTH) = '1') then
				overflow <= '1';
				c_out <= '1';
			end if;
			
		elsif sel = "100" then -- signed addition
			xTemp(D_WIDTH - 1 downto 0) <= x;
			xTemp(D_WIDTH) <= x(D_WIDTH - 1);
			yTemp(D_WIDTH - 1 downto 0) <= y;
			yTemp(D_WIDTH) <= y(D_WIDTH - 1);
			
			zTemp <= std_logic_vector(signed(xTemp) + signed(yTemp)) + c_in;
			z <= zTemp(D_WIDTH - 1 downto 0);
			
			if((x(D_WIDTH - 1) = '1' and y(D_WIDTH - 1) = '1' and zTemp(D_WIDTH - 1) ='0') or (x(D_WIDTH - 1) = '0' and y(D_WIDTH - 1) = '0' and zTemp(D_WIDTH - 1) ='1')) then
				overflow <= '1';
				c_out <= zTemp(D_WIDTH);
			end if;
			
		elsif sel = "101" then -- signed substract (beq)
			xTemp(D_WIDTH - 1 downto 0) <= x;
			xTemp(D_WIDTH) <= x(D_WIDTH - 1);
			yTemp(D_WIDTH - 1 downto 0) <= NOT y;
			yTemp(D_WIDTH) <= NOT y(D_WIDTH - 1); 
			
			zTemp <= std_logic_vector(signed(xTemp) + signed(yTemp)) + c_in;
			z <= zTemp(D_WIDTH - 1 downto 0);
			
			if(((x(D_WIDTH - 1) = '1' and y(D_WIDTH - 1) = '0' and zTemp(D_WIDTH - 1) ='0')) or ((x(D_WIDTH - 1) = '0' and y(D_WIDTH - 1) = '1' and zTemp(D_WIDTH - 1) ='1'))) then
				overflow <= '1';
			end if;
			
		elsif sel = "110" then -- Shift Logical Left
			z <= std_logic_vector(signed(x) sll conv_integer(y));
			
		else -- Shift Logical Right
			z <= std_logic_vector(signed(x) srl conv_integer(y));
			
		end if;
		if(signed(x) < signed(y)) then
			lt <= '1';
		else
			lt <= '0';
		end if;
	end process;
	
	output.data <= z;
	output.c_out <= c_out;
	output.overflow <= overflow;
	output.lt <= lt;
	
end Behavioral;

