LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY STRUCTURAL_HAZARDS IS 
	PORT (clock : IN	STD_LOGIC;
			instF3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			instD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			s_hazard : OUT STD_LOGIC
			);

END STRUCTURAL_HAZARDS;


ARCHITECTURE Structure OF STRUCTURAL_HAZARDS IS

	
BEGIN

	PROCESS(clock)
	BEGIN
		s_hazard <= '0';
		IF ( (instF3 = "1000") )  THEN
			--IF F3 stage has a real long operation and in decode we have a loadW/loadB or ADD/sub
			IF ( (instD = "0100") OR (instD = "0101") OR (instD = "0000") OR (instD = "0001") ) THEN
				s_hazard <= '1';
			END IF;
		END IF;
	END PROCESS;

END Structure;