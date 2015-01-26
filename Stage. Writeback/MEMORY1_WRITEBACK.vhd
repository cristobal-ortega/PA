LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MEMORY1_WRITEBACK IS 
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			
			e_writeBR_in : IN STD_LOGIC;
			data_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			instr_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			op_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			
			e_writeBR_out : OUT STD_LOGIC;
			data_out	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			instr_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			op_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			
			);

END MEMORY1_WRITEBACK;


ARCHITECTURE Structure OF MEMORY1_WRITEBACK IS

	SIGNAL e_writeBR_reg : STD_LOGIC;
	SIGNAL op_reg   : STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
	SIGNAL regDST_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL PC_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL inst_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL data_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
BEGIN

	e_writeBR_out <= e_writeBR_reg;
	data_out <= data_reg;
	regDST_out <= regDST_reg;
	PC_out <= PC_reg;
	instr_out <= inst_reg;
	op_out <= op_reg;

	
	PROCESS(clock)
	BEGIN
		IF (RISING_EDGE(clock)) AND (stall = '0')  THEN
			e_writeBR_reg <= e_writeBR_in;
			data_reg <= data_in;
			op_reg <= op_in;
			regDST_reg <= regDST_in;
			PC_reg <= PC_in;
			inst_reg <= instr_in;
		END IF;
	END PROCESS;
END Structure;