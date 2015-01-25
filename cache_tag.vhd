LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY cache_tag IS
	PORT (clock : IN	STD_LOGIC;
			we : IN STD_LOGIC;
			addr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			hit : OUT STD_LOGIC);

END cache_tag;

ARCHITECTURE Structure OF cache_tag IS

	TYPE t_cache IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(8 DOWNTO 0);
	
	SIGNAL cache : t_cache;
	SIGNAL aux : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL line_selector : STD_LOGIC_VECTOR(3 DOWNTO 0);

	
BEGIN
	line_selector <= addr(6 DOWNTO 3);
	aux <= cache( CONV_INTEGER( line_selector ));
	hit <= '1' WHEN aux = addr(15 DOWNTO 7) ELSE
			 '0';
	
	PROCESS(clock)
	BEGIN
		IF clock = '0' THEN
			IF we = '1' THEN 
				cache(CONV_INTEGER(line_selector)) <= addr(15 DOWNTO 7);
			END IF;
		END IF;
	END PROCESS;
END Structure;