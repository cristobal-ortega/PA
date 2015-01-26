LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DECODE_F1 IS 
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			ewritedecod_in : IN STD_LOGIC;
			w_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			rDST_in	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			ewritedecod_out : OUT STD_LOGIC;
			w_out	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			rDST_out	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000");

END DECODE_F1;

ARCHITECTURE Structure OF DECODE_F1 IS
	SIGNAL w_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL ewritedecod_reg : STD_LOGIC;
	SIGNAL rDST_reg : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

BEGIN

	ewritedecod_out <= ewritedecod_reg;
	w_out <= w_reg;
	rDST_out <= rDST_reg;
	
	PROCESS(clock)
	BEGIN
		IF (RISING_EDGE(clock)) AND (stall = '0')  THEN
			ewritedecod_reg <= ewritedecod_in;
			w_reg <= w_in;
			rDST_reg <= rDST_reg;
		END IF;
	END PROCESS;

END Structure;