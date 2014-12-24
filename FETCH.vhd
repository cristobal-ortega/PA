LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FETCH IS 
	PORT (clock : IN	STD_LOGIC;
			inst  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");

END FETCH;

ARCHITECTURE Structure OF FETCH IS
	COMPONENT inst_cache
	PORT (clock : IN	STD_LOGIC;
			pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			inst  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	signal pc : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
BEGIN
	IC: inst_cache
	PORT MAP(clock => clock,
				pc => pc,
				inst => inst);
END Structure;