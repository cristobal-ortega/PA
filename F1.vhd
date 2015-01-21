LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY F1 IS 
	PORT (clock : IN	STD_LOGIC;
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");
END F1;


ARCHITECTURE Structure OF F1 IS
BEGIN
-- F1 does nothing
	w <= a;
	
END Structure;