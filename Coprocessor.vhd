library IEEE;  -- Include the IEEE standard libraries
use IEEE.STD_LOGIC_1164.ALL;  -- Use standard logic package

-- Entity declaration for the coprocessor
entity Coprocessor is
	port (
		clk: in std_logic;  -- Clock input signal
		coprocessorResult: out integer  -- Output of the coprocessor
		);
end Coprocessor;  -- End of entity

-- Architecture declaration for the coprocessor
architecture Coprocessor_Behavioral of Coprocessor is

	-- Internal signals
	signal instruction :  std_logic_vector(15 downto 0);  -- Current instruction
	signal pc :  integer := -1;  -- Program counter, initialized to -1
	signal x :  integer := 0;  -- Counter x, initialized to 0
	signal w :  integer := -1;  -- Counter w, initialized to -1
	signal x_out, w_out :  integer;  -- Outputs from the register file
	signal readData, regWrite, aluEnable, writeResult, loadData, regRead :  std_logic := '0';  -- Control signals
	signal result :  integer := 0;  -- Result signal from processing unit

	-- ControlUnit Component Declaration
	component ControlUnit is
		port(
			clk : in std_logic;  -- Clock input
			pc : buffer integer := 0;  -- Program counter, buffer type
			x : buffer integer := 1;  -- Counter x, buffer type
			w : buffer integer := 0;  -- Counter w, buffer type
			instruction : in std_logic_vector(15 downto 0);  -- Instruction input
			readData, regWrite, regRead, aluEnable, writeResult, loadData : out std_logic := '0'  -- Control signals
		);
	end component;

	-- RegisterFile Component Declaration
	component RegisterFile is
		port (
			clk: in std_logic;  -- Clock input
			pc : in integer;  -- Program counter input
			i, j: in Integer;  -- Counters x and w as inputs
			x_out : out Integer;  -- Output counter x
			w_out : out Integer;  -- Output counter w
			instruction: out std_logic_vector(15 downto 0);  -- Instruction output
			result : in integer;  -- Result input from processing unit
			readData, regRead, regWrite: in std_logic  -- Control signals inputs
		);
	end component;

	-- ProcessingUnit Component Declaration
	component ProcessingUnit is
		port (
			clk : in std_logic;  -- Clock input
			x, w : in integer;  -- Inputs x and w from register file
			accOut : out integer;  -- Output result to coprocessor
			writeResult, loadData, aluEnable : in std_logic  -- Control signals inputs
		);
	end component;

begin

	-- Instantiate ControlUnit and connect signals
	ControlUnit1: ControlUnit port map (
		clk, pc, x, w, instruction, 
		readData, regWrite, regRead, aluEnable, writeResult, loadData
	);

	-- Instantiate RegisterFile and connect signals
	RegisterFile1: RegisterFile port map (
		clk, pc, x, w, x_out, w_out, instruction, result, 
		readData, regRead, regWrite
	);

	-- Instantiate ProcessingUnit and connect signals
	ProcessingUnit1: ProcessingUnit port map (
		clk, x_out, w_out, coprocessorResult, writeResult, loadData, aluEnable
	);

end Coprocessor_Behavioral;  -- End of architecture
