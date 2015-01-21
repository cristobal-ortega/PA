LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY DECODE1 IS 
	PORT (clock : IN	STD_LOGIC;
			e_writeBR : IN STD_LOGIC; -- Permision to write in the register bank
			regDST : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			inst  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			e_writeBR_out : OUT STD_LOGIC; -- Decoded instruction writes the regiter bank
			op		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			reg_a : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			reg_b : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);

END DECODE1;


ARCHITECTURE Structure OF DECODE1 IS

	TYPE t_regbank IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL reg_bank : t_regbank;
BEGIN
	op <= inst(15 DOWNTO 12);
	reg_a <= reg_bank(CONV_INTEGER(inst(11 DOWNTO 8))); 
	reg_b <= reg_bank(CONV_INTEGER(inst(7 DOWNTO 4))); 
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