LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY DATA_HAZARDS IS 
	PORT (clock : IN	STD_LOGIC;
			regSRCa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regSRCb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_E: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			d_hazard : OUT STD_LOGIC
			
			);

END DATA_HAZARDS;


ARCHITECTURE Structure OF DATA_HAZARDS IS

	
BEGIN

	PROCESS(clock)
	BEGIN
		d_hazard <= "0";
		IF ( (regSRCa = regDST_E) OR (regSRCa = regDST_C) OR (regSRCa = regDST_F1) OR (regSRCa = regDST_F2) OR (regSRCa = regDST_F3) OR (regSRCa = regDST_F4) OR (regSRCa = regDST_F5) ) THEN 
			d_hazard <= "1";
		END IF;
		IF ( (regSRCb = regDST_E) OR (regSRCb = regDST_C) OR (regSRCb = regDST_F1) OR (regSRCb = regDST_F2) OR (regSRCb = regDST_F3) OR (regSRCb = regDST_F4) OR (regSRCb = regDST_F5) ) THEN
			d_hazard <= "1";
		END IF;
	END PROCESS;

END Structure;