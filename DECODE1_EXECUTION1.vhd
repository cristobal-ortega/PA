LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DECODE1_EXECUTION1 IS 
	PORT (clock    : IN	STD_LOGIC;
			stall    : IN STD_LOGIC;
			ewritedecod_in : IN STD_LOGIC;
			op_in    : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			rega_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regb_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			ewritedecod_out : OUT STD_LOGIC;
			op_out   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
			rega_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regb_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");

END DECODE1_EXECUTION1;


ARCHITECTURE Structure OF DECODE1_EXECUTION1 IS

	SIGNAL ewritedecod_reg : STD_LOGIC;
	SIGNAL op_reg : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL rega_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL regb_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";

BEGIN
	
	ewritedecod_out <= ewritedecod_reg;
	op_out <= op_reg;
	rega_out <= rega_reg;
	regb_out <= regb_reg;
	
	PROCESS(clock)
	BEGIN
		IF (RISING_EDGE(clock)) AND (stall = '0')  THEN
			ewritedecod_reg <= ewritedecod_in;
			op_reg <= op_in;
			rega_reg <= rega_in;
			regb_reg <= regb_in;
		END IF;
	END PROCESS;
END Structure;