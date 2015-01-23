LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY FETCH IS 
	PORT (clock : IN	STD_LOGIC;
			hit 	: OUT STD_LOGIC;
			inst  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			
			);

END FETCH;

ARCHITECTURE Structure OF FETCH IS
	COMPONENT cache_data
	PORT (clock : IN	STD_LOGIC;
			addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			data  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT cache_tag
	PORT (clock : IN	STD_LOGIC;
			addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			hit  : OUT STD_LOGIC);
	END COMPONENT;
	
	signal pc : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
BEGIN

	ICD: cache_data
	PORT MAP(clock => clock,
				addr => pc(5 DOWNTO 2),
				data => inst);
				
	ICT: cache_tag
	PORT MAP(clock => clock,
				addr => pc,
				hit => hit);

	pc_out <= pc;
	PROCESS(clock)
	BEGIN
		IF(RISING_EDGE(clock)) THEN
			pc <= STD_LOGIC_VECTOR( UNSIGNED(pc) + 4);
		END IF;
	END PROCESS;
				
END Structure;