LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY F2 IS 
	PORT (clock : IN	STD_LOGIC;
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");
END F2;


ARCHITECTURE Structure OF F2 IS
BEGIN
-- F2..F4 adds 1 to the register, Rdst = Rsrc + 4; 
	w <= a + "0000000000000001";
	
END Structure;