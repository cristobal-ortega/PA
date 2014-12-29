LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY EXECUTION1 IS 
	PORT (clock : IN	STD_LOGIC;
			op  : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			b : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");

END EXECUTION1;


ARCHITECTURE Structure OF EXECUTION1 IS
BEGIN
-- Aqui va una alu, => encapsular esto dfe aqui aabjo
	WITH op SELECT w <= 
		a+b WHEN "0100",
		a-b WHEN "0101",
		a+b WHEN OTHERS;
END Structure;