LIBRARY ieee;  -- Include the IEEE standard libraries
USE ieee.std_logic_1164.ALL;  -- Use the standard logic package for signals

-- Entity declaration for the testbench
ENTITY Coprocessor_TestBench IS
END Coprocessor_TestBench;  -- No ports needed for testbench

-- Architecture for the testbench
ARCHITECTURE Coprocessor_Behavior of Coprocessor_TestBench IS 

    -- Component declaration of the Coprocessor under test
    COMPONENT Coprocessor
    PORT(
         clk : IN  std_logic;  -- Clock input for the coprocessor
         coprocessorResult: out integer  -- Output result from the coprocessor
        );
    END COMPONENT;
    
    -- Signal declarations for connecting to the component
    signal clk : std_logic := '0';  -- Clock signal, initialized to 0
    signal coprocessorResult: integer;  -- Signal to capture the coprocessor's output

BEGIN

    -- Instantiate the coprocessor under test (UUT)
    uut: Coprocessor PORT MAP (
        clk => clk,  -- Connect testbench clock to component clock
        coprocessorResult => coprocessorResult  -- Connect coprocessor output to testbench signal
    );

    -- Generate a simple clock signal that toggles every 5 ns
    clk <= not clk after 5 ns;

END;  -- End of architecture
