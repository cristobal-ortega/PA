LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MEMORY1_WRITEBACK IS 
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			ewritedecod_in : IN STD_LOGIC;
			data_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			ewritedecod_out : OUT STD_LOGIC;
			data_out	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");

END MEMORY1_WRITEBACK;


ARCHITECTURE Structure OF MEMORY1_WRITEBACK IS
	SIGNAL data_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL ewritedecod_reg : STD_LOGIC;
BEGIN

	ewritedecod_out <= ewritedecod_reg;
	data_out <= data_reg;
	
	PROCESS(clock)
	BEGIN
		IF (RISING_EDGE(clock)) AND (stall = '0')  THEN
			ewritedecod_reg <= ewritedecod_in;
			data_reg <= data_in;
		END IF;
	END PROCESS;
END Structure;