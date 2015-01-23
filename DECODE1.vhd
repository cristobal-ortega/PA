LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY DECODE1 IS 
	PORT (clock : IN	STD_LOGIC;
			e_writeBR : IN STD_LOGIC; -- Permision to write in the register bank
			e_writeBR_long : IN STD_LOGIC; -- Permision to write in the register bank
			regDST : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_long : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			inst  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w_long	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			e_writeBR_out : OUT STD_LOGIC; -- Decoded instruction writes the regiter bank
			e_writeBR_long_out : OUT STD_LOGIC; -- Decoded instruction writes the regiter bank
			op		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			a : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			b : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			regDST_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			);

END DECODE1;


ARCHITECTURE Structure OF DECODE1 IS

	TYPE t_regbank IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL reg_bank : t_regbank;
BEGIN
	op <= inst(15 DOWNTO 12);
	a <= reg_bank(CONV_INTEGER(inst(11 DOWNTO 8))); 
	
	WITH inst(15 DOWNTO 12) SELECT b <= B"00000000" & inst(7 DOWNTO 0) WHEN "0111", -- JUMP BNZ
													reg_bank(CONV_INTEGER(inst(7 DOWNTO 4))) WHEN OTHERS ;
		
	WITH inst(15 DOWNTO 12) SELECT e_writeBR_out <= 
													'1' WHEN "0100", -- ADD
													'1' WHEN "0101", -- SUB
													'1' WHEN "0110", -- CMP
													'1' WHEN "0001", -- Load Byte
													'1' WHEN "0000", -- Load Word
													'1' WHEN "1000", -- Long Instruction
													'0' WHEN OTHERS;
													
	regDST_out <= inst(3 DOWNTO 0);
	
	PROCESS(clock)
	BEGIN
		IF clock = '0' THEN
			IF e_writeBR = '1' THEN 
				reg_bank(CONV_INTEGER(regDST)) <= w;
			END IF;
			IF e_writeBR_long = '1' THEN
				reg_bank(CONV_INTEGER(regDST_long)) <= w_long;
		END IF;
	END PROCESS;

END Structure;