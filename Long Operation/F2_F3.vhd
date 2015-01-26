LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY F2_F3 IS 
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			e_writeBR_in : IN STD_LOGIC;
			w_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_in	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_in		: IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			
			e_writeBR_out : OUT STD_LOGIC;
			w_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_out	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_out		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"
			
			);

END F2_F3;

ARCHITECTURE Structure OF F2_F3 IS
	
	SIGNAL e_writeBR_reg : STD_LOGIC;
	SIGNAL w_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL regDST_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL PC_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL inst_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL op_reg   : STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";

BEGIN

	e_writeBR_out <= e_writeBR_reg;
	op_out <= op_reg;
	w_out <= w_reg;
	rDST_out <= regDST_reg;
	PC_out <= PC_reg;
	inst_out <= inst_reg;
	
	PROCESS(clock)
	BEGIN
		IF (RISING_EDGE(clock)) AND (stall = '0')  THEN
			e_writeBR_reg <= e_writeBR_in;
			op_reg <= op_in;
			w_reg <= w_in;
			regDST_reg <= rDST_in;
			PC_reg <= PC_in;
			inst_reg <= inst_in;
	
		END IF;
	END PROCESS;

END Structure;