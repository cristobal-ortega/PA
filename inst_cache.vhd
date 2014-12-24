LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY inst_cache IS
	PORT (clock : IN	STD_LOGIC;
			pc  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");

END inst_cache;

ARCHITECTURE Structure OF inst_cache IS

	TYPE t_cache IS ARRAY(3 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL cache : t_cache;
	SIGNAL aux : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	
BEGIN
	aux <= pc(3 DOWNTO 0);
	inst <= cache(  TO_INTEGER(UNSIGNED(pc(3 DOWNTO 0))) )(15 DOWNTO 0);
END Structure;