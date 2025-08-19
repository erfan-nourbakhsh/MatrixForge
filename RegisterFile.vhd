library IEEE;  -- Include IEEE standard libraries
use IEEE.STD_LOGIC_1164.ALL;  -- Use the standard logic package for signals

-- Entity declaration for the RegisterFile
entity RegisterFile is
	port (
		 clk: in std_logic;  -- Clock input
		 pc : in integer;  -- Program counter input
		 i, j: in Integer;  -- Indexes to select matrix elements
		 x_out : out Integer;  -- Output value from x matrix
		 w_out : out Integer;  -- Output value from w matrix
		 instruction: out std_logic_vector(15 downto 0);  -- Output instruction
		 result : in integer := 0;  -- Input result to be written
		 readData, regRead, regWrite: in std_logic  -- Control signals
	);	
end RegisterFile;  -- End of entity

-- Architecture for RegisterFile
architecture RegisterFile_Behavioral of RegisterFile is	
	-- Internal signal to store result when writing
	signal regResult: integer;

	-- Define a 3x3 integer array type for x and w
	type data3x3 is array (1 to 3, 1 to 3) of integer;

	-- Initialize x matrix with specific values
	signal x: data3x3 := ((255, 200, 100), (5, 46, 180), (100, 200, 300));

	-- Initialize w matrix with specific values
	signal w: data3x3 := ((1, 0 , -1),(1, 0 , -1),(1, 0 , -1));

	-- Define an array type for 19 instructions of 16 bits each
	type data19x16 is array (1 to 19) of std_logic_vector(15 downto 0);

	-- Initialize instruction memory with a sequence of instructions
	signal regInstruction :data19x16 := (
	1 => x"0001",
	2 => x"0002",
	3 => x"0001",
	4 => x"0002",
	5 => x"0001",
	6 => x"0002",
	7 => x"0001",
	8 => x"0002",
	9 => x"0001",
	10 => x"0002",
	11 => x"0001",
	12 => x"0002",
	13 => x"0001",
	14 => x"0002",
	15 => x"0001",
	16 => x"0002",
	17 => x"0001",
	18 => x"0002",
	19 => x"0003"
	);

begin

	-- Process to fetch instruction based on program counter
	fetch_section: process (clk)
	begin 
		if(rising_edge(clk)) then  -- Trigger on clock rising edge
			if (regRead = '1') then  -- If regRead is active
				instruction <= regInstruction(pc);  -- Output the instruction from memory
			end if;
		end if;
	end process;  -- End of fetch process
	
	-- Process to write the result into internal register
	write_section: process(clk)
	begin 
		if (rising_edge(clk)) then  -- Trigger on clock rising edge
			if (regWrite = '1') then  -- If regWrite is active
				regResult <= result;  -- Store the incoming result
			end if;
		end if;
	end process;  -- End of write process
	
	-- Process to read x and w matrix values based on indexes
	read_section : process (clk)
	begin 
		if (rising_edge(clk)) then  -- Trigger on clock rising edge
			if (readData = '1') then  -- If readData is active
				x_out <= x(i, j);  -- Output x matrix value at (i,j)
				w_out <= w(i, j);  -- Output w matrix value at (i,j)
			end if;
		end if;
	end process;  -- End of read process
	
end RegisterFile_Behavioral;  -- End of architecture
