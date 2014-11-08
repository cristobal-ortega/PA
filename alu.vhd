LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY alu IS 
	PORT (x  : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			y  : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			w  : OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			op : IN	STD_LOGIC);
END alu;


ARCHITECTURE Structure OF alu IS
BEGIN

WITH op SELECT 
	w <= y(15 DOWNTO 0) WHEN '0',
		  y(7 DOWNTO 0)&x(7 DOWNTO 0) WHEN OTHERS;
	
END Structure;