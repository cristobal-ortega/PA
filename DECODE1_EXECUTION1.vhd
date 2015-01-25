LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DECODE1_EXECUTION1 IS 
	PORT (clock    : IN	STD_LOGIC;
			stall    : IN STD_LOGIC;
			
			
			e_writeBR_in : IN STD_LOGIC;
			e_writeBR_long_in : IN STD_LOGIC;
			op_in		: IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			a_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			b_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			
			e_writeBR_out : OUT STD_LOGIC;
			e_writeBR_long_out : OUT STD_LOGIC;
			op_out   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
			a_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			b_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_out : OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			);

END DECODE1_EXECUTION1;


ARCHITECTURE Structure OF DECODE1_EXECUTION1 IS

	SIGNAL e_writeBR_reg : STD_LOGIC := '0';
	SIGNAL e_writeBR_long_reg : STD_LOGIC := '0';
	SIGNAL op_reg   : STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
	SIGNAL a_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL b_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL regDST_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL PC_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL inst_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	

	e_writeBR_out <= e_writeBR_reg;
	e_writeBR_long_out <= e_writeBR_long_reg;
	op_out <= op_reg;
	a_out <= a_reg;
	b_out <= b_reg;
	regDST_out <= regDST_reg;
	PC_out <= PC_reg;
	inst_out <= inst_reg;
	
	PROCESS(clock)
	BEGIN
		IF (RISING_EDGE(clock)) AND (stall = '0')  THEN
			e_writeBR_reg <= e_writeBR_in;
			e_writeBR_long_reg <= e_writeBR_long_in;
			op_reg <= op_in;
			a_reg <= a_in;
			b_reg <= b_in;
			regDST_reg <= regDST_in;
			PC_reg <= PC_in;
			inst_reg <= inst_in;
		END IF;
	END PROCESS;
END Structure;