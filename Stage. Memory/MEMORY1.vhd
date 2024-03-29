LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MEMORY1 IS 
	PORT (clock : IN	STD_LOGIC;
			instr_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			op_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			w 		 : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			mem_ready : IN STD_LOGIC;
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			mem_bus : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0);
			data	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			hit	 : OUT STD_LOGIC := '0'
			);

END MEMORY1;


ARCHITECTURE Structure OF MEMORY1 IS
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
	SIGNAL we_aux : STD_LOGIC;
	SIGNAL hit_aux : STD_LOGIC;
	SIGNAL hit_store_buffer : STD_LOGIC;
	SIGNAL addr_store_buffer : STD_LOGIC_VECTOR(12 DOWNTO 0);
	SIGNAL store_buffer : STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL data_load : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
BEGIN

	DCD: cache_data
	PORT MAP(clock => clock,
				bw => op_in(0),
				we => we_aux,
				addr => w(6 DOWNTO 0),
				wr_data => mem_bus,
				data => data_load);
				
	DCT: cache_tag
	PORT MAP(clock => clock,
				we => we_aux,
				addr => pc,
				hit => hit_aux);

	PROCESS(clock)
	BEGIN
		IF (clock = '1' AND hit_store_buffer = '1' AND op_in(3 DOWNTO 1) = "001" ) THEN
				store_buffer(15 DOWNTO 0) <= w;
		ELSIF ( clock = '1' AND hit_store_buffer = '0' AND op_in(3 DOWNTO 1) = "001") THEN
				--mem_bus <= store_buffer;
		END IF;
	END PROCESS;
	mem_bus <= (OTHERS => 'Z');
	hit_store_buffer <= '1' WHEN addr_store_buffer = w(15 DOWNTO 3) ELSE '0';
	we_aux <= '1' WHEN mem_ready = '1' AND op_in(3 DOWNTO 1) = "000" ELSE '0';
	hit <= '1' WHEN hit_aux = '1' OR  op_in(3 DOWNTO 1) /= "000" ELSE '0';
	
	WITH op_in(3 DOWNTO 1) SELECT data <= data_load WHEN "000",
                                                 w WHEN OTHERS;
END Structure;