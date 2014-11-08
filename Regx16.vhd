LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY Regx16 IS 
	PORT (x     : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			clock : IN	STD_LOGIC;
			w		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
END Regx16;


ARCHITECTURE Structure OF Regx16 IS
	signal REG : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000" ;
BEGIN
	REG <= x WHEN( clock = '1' );
	w <= REG;
END Structure;