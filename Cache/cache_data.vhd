LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY cache_data IS
	PORT (clock : IN	STD_LOGIC;
			bw : IN STD_LOGIC; --1 byte access, 0 word access
			we : IN STD_LOGIC; --write enable
			addr  : IN STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
			wr_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");

END cache_data;

ARCHITECTURE Structure OF cache_data IS

	TYPE t_cache IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	SIGNAL cache : t_cache;
	SIGNAL word_aux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL byte_aux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL line_selector : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL word_selector : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL byte_selector : STD_LOGIC;
	
BEGIN
	line_selector <= addr(6 DOWNTO 3);
	word_selector <= addr(2 DOWNTO 1);
	byte_selector <= addr(0);
	
	
	WITH word_selector SELECT word_aux <= 
		cache( CONV_INTEGER(line_selector))(63 DOWNTO 48) WHEN "11",
		cache( CONV_INTEGER(line_selector))(47 DOWNTO 32) WHEN "10",
		cache( CONV_INTEGER(line_selector))(31 DOWNTO 16) WHEN "01",
		cache( CONV_INTEGER(line_selector))(15 DOWNTO 0) WHEN OTHERS;
		
	WITH byte_selector SELECT byte_aux <=
		"00000000"&word_aux(15 DOWNTO 8) WHEN '1',
		"00000000"&word_aux(7 DOWNTO 0) WHEN OTHERS;
		
	WITH bw SELECT data <=
		byte_aux WHEN '1',
		word_aux WHEN OTHERS;
		
	PROCESS(clock)
	BEGIN
		IF clock = '1' AND we = '1' THEN
				cache(CONV_INTEGER(line_selector)) <= wr_data;
		END IF;
	END PROCESS;
		
END Structure;