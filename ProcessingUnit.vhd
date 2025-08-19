library IEEE;  -- Include the IEEE standard libraries
use IEEE.STD_LOGIC_1164.ALL;  -- Use standard logic package

-- Entity declaration for the ProcessingUnit
entity ProcessingUnit is
	port (
		clk : in std_logic;  -- Clock input
		x, w : in integer;  -- Input counters x and w
		accOut : out integer;  -- Output accumulator value
		writeResult, loadData, aluEnable : in std_logic  -- Control signals
	);
end ProcessingUnit;  -- End of entity

-- Architecture for the ProcessingUnit
architecture ProcessingUnit_Behavioral of ProcessingUnit is
	signal xReg, wReg, acc : integer;  -- Internal registers for x, w, and accumulator

begin 
	-- Main processing logic, triggered on clock
	Processing_unit: process (clk)
	begin 	
		if (rising_edge(clk)) then  -- Trigger actions on rising edge of clock
			
			-- If writeResult is active, output the accumulator value
			if (writeResult = '1') then
				accOut <= acc;
				
			-- If loadData is active, load input values into internal registers
			elsif (loadData = '1') then
				xReg <= x;
				wReg <= w;
				
			-- If ALU is enabled, perform multiplication and add to accumulator
			elsif (aluEnable = '1') then
				acc <= acc + wReg * xReg;
			end if;
			
		end if;  -- End of rising_edge(clk) check
	end process;  -- End of processing unit process
end ProcessingUnit_Behavioral;  -- End of architecture
