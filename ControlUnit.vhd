library IEEE;  -- Include the IEEE standard libraries for VHDL
use IEEE.STD_LOGIC_1164.ALL;  -- Use the standard logic package for signals

-- Entity declaration for the Control Unit
entity ControlUnit is
	port(
		clk : in std_logic;  -- Clock input signal
		pc : buffer integer := 0;  -- Program counter, buffered, initial value 0
		x : buffer integer := 1;  -- General-purpose counter x, buffered, initial value 1
		w : buffer integer := 0;  -- General-purpose counter w, buffered, initial value 0
		instruction : in std_logic_vector(15 downto 0);  -- 16-bit instruction input
		readData, regWrite, regRead, aluEnable, writeResult, loadData : out std_logic := '0'  -- Control signals initialized to '0'
	);
end ControlUnit;  -- End of entity declaration

-- Architecture for the Control Unit
architecture ControlUnit_Behavioral of ControlUnit is

	-- Define state types for the finite state machine (FSM)
	type stateTypes is ( fetch_section, decode_section, exe_section, write_section );  
	signal state: stateTypes := fetch_section ;  -- Current state signal, initialized to fetch_section
	
begin

	-- Clocked process to update FSM state on rising edge of clock
	clock_process: process (clk) 
	begin 
		if (rising_edge(clk)) then  -- Triggered on rising edge of clock
			case state is  -- Check the current state
			when fetch_section => state <= decode_section;  -- Move from fetch to decode
			when decode_section => state <= exe_section;  -- Move from decode to execute
			when exe_section =>  -- Execute state
				if (instruction = x"0003") then  -- Check if instruction is of type 0003
					state <= write_section;  -- Move to write section if instruction is 0003
				else
					state <= fetch_section;  -- Otherwise, go back to fetch
				end if;
			when others => state <= write_section ;  -- Default case: go to write_section
			end case;
		end if ;
	end process;  -- End of clock process
	
	-- Process to generate outputs based on current state
	state_process: process (state)
	begin 
		case state is
			----- Fetch Section -----
			when fetch_section =>
				if (pc < 19) then  -- Increment PC if less than 19
					pc <=  pc + 1;  
				elsif (pc = 19) then  -- Reset PC if it reaches 19
					pc <= 0;
				end if;
				regRead <= '1';  -- Enable reading from register during fetch					
				aluEnable <= '0';  -- Disable ALU during fetch
				loadData <= '0';  -- Do not load data during fetch

			----- Decode Section -----
			when decode_section => 
				regRead <= '0';  -- Disable register read during decode
				if (instruction = x"0001") then  -- Instruction type 0001
					readData <= '1';  -- Enable reading data
					if (w < 4 and x < 4) then  -- Check limits for counters
						if (w = 3) then  -- If w equals 3
							x <= x + 1;  -- Increment x
							w <= 1;  -- Reset w to 1
						elsif (w < 3) then  -- If w less than 3
							w <= w + 1;  -- Increment w
						end if;
					else
						w <= 1;  -- Reset w if limits exceeded
						x <= 1;  -- Reset x if limits exceeded
					end if;		
				elsif (instruction = x"0002") then  -- Instruction type 0002
					loadData <= '0';  -- Disable loading data
					readData <= '0';  -- Disable reading data
				elsif (instruction = x"0003") then  -- Instruction type 0003
					aluEnable <= '0';  -- Disable ALU
					loadData <= '0';  -- Disable loading data
					readData <= '0';  -- Disable reading data
				end if;

			----- Execution Section -----					
			when exe_section => 
				readData <= '0';  -- Ensure readData is disabled during execution
				if (instruction = x"0001") then  -- Instruction type 0001
					loadData <= '1';  -- Enable loading data
				elsif (instruction = x"0002") then  -- Instruction type 0002
					aluEnable <= '1';  -- Enable ALU
				elsif (instruction = x"0003") then  -- Instruction type 0003
					writeResult <= '1';  -- Enable writing result
					regWrite <= '1';  -- Enable register write
				end if;

			----- Write Section -----	
			when write_section => 
				writeResult <= '1';  -- Keep write result enabled
				regWrite <= '1';  -- Keep register write enabled
		end case;
	end process;  -- End of state process
	
end ControlUnit_Behavioral;  -- End of architecture
