LIBRARY ieee;
USE ieee.std_logic_1164.all;



ENTITY EXECUTION1 IS 
	PORT (clock : IN	STD_LOGIC;
			op  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			b : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			z : OUT STD_LOGIC
			
			);

END EXECUTION1;


ARCHITECTURE Structure OF EXECUTION1 IS

	COMPONENT ALU
	PORT (x  : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			y  : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			w  : OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			op : IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			z  : OUT STD_LOGIC);
	END COMPONENT;
BEGIN
-- Aqui va una alu, => encapsular esto dfe aqui aabjo
	ALU1: ALU
	PORT MAP(x => a,
				y => b,
				w => w,
				op => op,
				z => z);
	

END Structure;