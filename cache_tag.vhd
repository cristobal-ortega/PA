LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY cache_tag IS
	PORT (clock : IN	STD_LOGIC;
			addr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			hit : OUT STD_LOGIC);

END cache_tag;

ARCHITECTURE Structure OF cache_tag IS

	TYPE t_cache IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL cache : t_cache;
	SIGNAL aux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
BEGIN
	aux <= cache( CONV_INTEGER( addr(5 DOWNTO 2) ));
	hit <= '1' WHEN aux = addr ELSE
			 '0';
END Structure;