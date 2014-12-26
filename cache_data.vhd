LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY cache_data IS
	PORT (clock : IN	STD_LOGIC;
			addr  : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");

END cache_data;

ARCHITECTURE Structure OF cache_data IS

	TYPE t_cache IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL cache : t_cache;
	
BEGIN
	data <= cache( CONV_INTEGER(addr));
END Structure;