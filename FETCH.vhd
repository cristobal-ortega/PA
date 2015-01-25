LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY FETCH IS 
	PORT (clock : IN	STD_LOGIC;
			
	
			w	 : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			z : IN STD_LOGIC;
			mem_ready : IN STD_LOGIC;
			instr_jmp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			mem_bus : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			hit 	: OUT STD_LOGIC;
			inst  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			hazard: IN STD_LOGIC := '0';
			stall: IN STD_LOGIC := '0';
			pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			
			);

END FETCH;

ARCHITECTURE Structure OF FETCH IS
	COMPONENT cache_data
	  	PORT (clock : IN	STD_LOGIC;
 			bw : IN STD_LOGIC; --1 byte access, 0 word access
 			we : IN STD_LOGIC; --write enable
			addr  : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			wr_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
 			data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	COMPONENT cache_tag
  	PORT (clock : IN	STD_LOGIC;
 			we : IN STD_LOGIC;
 			addr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
 			hit : OUT STD_LOGIC);
	END COMPONENT;
	
	signal pc : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL we : STD_LOGIC; --write enable
 	SIGNAL hit_aux : STD_LOGIC;
BEGIN

	we <= mem_ready AND NOT(hit_aux);
	ICD: cache_data
  	PORT MAP(clock => clock,
 				bw => '0',
 				we => we,
 				addr => pc(6 DOWNTO 0),
				wr_data => mem_bus,
  				data => inst);
				
	ICT: cache_tag
	PORT MAP(clock => clock,
 				we => we,
  				addr => pc,
 				hit => hit_aux);

	hit <= hit_aux;
	pc_out <= pc;
	PROCESS(clock)
	BEGIN
		IF(RISING_EDGE(clock)) THEN
			IF hazard = '0' AND stall = '0' THEN
				pc <= STD_LOGIC_VECTOR( UNSIGNED(pc) + 2);
			END IF;
			IF instr_jmp = "0111" AND z /= '0' THEN
				pc <= w;
			END IF;
		END IF;
	END PROCESS;
				
END Structure;