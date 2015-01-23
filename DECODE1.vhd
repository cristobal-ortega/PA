LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY DECODE1 IS 
	PORT (clock : IN	STD_LOGIC;
			e_writeBR : IN STD_LOGIC; -- Permision to write in the register bank
			e_writeBR_long : IN STD_LOGIC; -- Permision to write in the register bank
			regDST : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			inst  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			
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
	b <= reg_bank(CONV_INTEGER(inst(7 DOWNTO 4))); 
	WITH inst(15 DOWNTO 12) SELECT e_writeBR_out <= 
													'1' WHEN "0100", --add
													'1' WHEN "0101", --sub
													'1' WHEN "0001", --lb
													'0' WHEN OTHERS;
	
	PROCESS(clock)
	BEGIN
		IF clock = '0' AND e_writeBR = '1' THEN
			reg_bank(CONV_INTEGER(regDST)) <= w;
		END IF;
	END PROCESS;

END Structure;