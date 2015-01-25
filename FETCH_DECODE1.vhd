LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY FETCH_DECODE1 IS 
	PORT (clock : IN	STD_LOGIC;
			stall: IN STD_LOGIC;
			hazard : IN STD_LOGIC;
			inst_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			inst_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	
	);

END FETCH_DECODE1;


ARCHITECTURE Structure OF FETCH_DECODE1 IS

	SIGNAL inst_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "1111000000000000";
BEGIN

	inst_out <= inst_reg;
	
	PROCESS(clock)
	BEGIN
		IF (RISING_EDGE(clock)) AND (stall = '0') AND (hazard = '0')  THEN
			inst_reg <= inst_in;
		END IF;
	END PROCESS;

END Structure;