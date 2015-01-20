LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU IS 
	PORT (x  : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			y  : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			w  : OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			op : IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			z  : OUT STD_LOGIC);
END ALU;


ARCHITECTURE Structure OF ALU IS

	SIGNAL waux : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL add  : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL sub  : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
BEGIN
	add <= x+y;
	sub <= x-y;

	WITH op SELECT waux <= 
		add WHEN "0100", --add
		sub WHEN "0101", --sub
		sub WHEN "0110", --cmp
		sub WHEN "0111", --bnz
		add WHEN OTHERS;
		
	--Mucho ojo con esto: si z ejecuta antes k se ponga w, esto va a dar mal, hay que testear
	z <= not (waux(0) or waux(1) or waux(2) or waux(3) or waux(4) or waux(5) or waux(6) or waux(7) or waux(8) or waux(9) or waux(10) or waux(11) or waux(13) or waux(14) or waux(15) );
	w <= waux;
	
END Structure;