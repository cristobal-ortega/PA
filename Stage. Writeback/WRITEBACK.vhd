LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY WRITEBACK IS 
	PORT (clock : IN	STD_LOGIC;
			data	: IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			data_long : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			e_writeBR_in : IN STD_LOGIC;
			e_writeBR_long_in : IN STD_LOGIC;
			
			e_writeBR_out : OUT STD_LOGIC;
			w : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");

END WRITEBACK;


ARCHITECTURE Structure OF WRITEBACK IS
BEGIN
	--if instr == long, w <= data_long, else w <= data
	w <= data;
	e_writeBR_out <= e_writeBR_in;
	
END Structure;