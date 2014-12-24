LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY x1714 IS 
	PORT (	datard_m	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_m	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000" ;
				boot		: IN	STD_LOGIC;
				clk		: IN	STD_LOGIC;
				interrupt: IN  STD_LOGIC);
END x1714;

ARCHITECTURE Structure OF x1714 IS

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	
	--Los modulos se nombraran de la siguiente forma: (en Mayusuuculas las etapas) 
	-- nombre del fichero/componente = nombre completo
	-- nombre de la instaciacion en otro nivel = nombre abreviado
	COMPONENT FETCH
	PORT (clock : IN	STD_LOGIC;
			inst  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT FETCH_DECODE1
	PORT (clock : IN	STD_LOGIC;
			inst_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			inst_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT DECODE1
	PORT (clock : IN	STD_LOGIC;
			inst  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			regwrite : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			op		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT DECODE1_EXECUTION1
	PORT (clock : IN	STD_LOGIC;
			op_in  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			op_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT EXECUTION1
	PORT (clock : IN	STD_LOGIC;
			op    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			w		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT EXECUTION1_MEMORY1
	PORT (clock : IN	STD_LOGIC;
			w_in		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w_out		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT MEMORY1
	PORT (clock : IN	STD_LOGIC;
			w		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			data 	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT MEMORY1_WRITEBACK
	PORT (clock : IN	STD_LOGIC;
			data_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_out	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT WRITEBACK
	PORT (clock : IN	STD_LOGIC;
			data   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			regwrite : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	-- Las señales auxiliares para conectar los modulos se nombraran de la siguiente forma: $nombresignal$etapafuente_$estapadestino
	signal instf_fd1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal instfd1_d1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal opd1_d1e1	: STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal opd1e1_e1	: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	signal we1_e1m1	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal we1m1_m1	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal datam1_m1w1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal datam1w1_w1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal regwritew_d1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
BEGIN
	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0
	
	F: FETCH
	PORT MAP(clock => clk,
				inst => instf_fd1);
	
	F_D1: FETCH_DECODE1
	PORT MAP(clock => clk,
				inst_in => instf_fd1,
				inst_out => instfd1_d1);
	
	D1: DECODE1
	PORT MAP(clock => clk,
				inst => instfd1_d1,
				regwrite => regwritew_d1,
				op => opd1_d1e1);
				
	D1_E1: DECODE1_EXECUTION1
	PORT MAP(clock => clk,
				op_in => opd1_d1e1,
				op_out => opd1e1_e1);
	
	E1: EXECUTION1
	PORT MAP(clock => clk,
				op => opd1e1_e1,
				w => we1_e1m1);
				
	E1_M1: EXECUTION1_MEMORY1
	PORT MAP(clock => clk,
				w_in => we1_e1m1,
				w_out => we1m1_m1);
				
	M1: MEMORY1
	PORT MAP(clock => clk,
				w => we1m1_m1,
				data => datam1_m1w1);
				
	M1_W: MEMORY1_WRITEBACK
	PORT MAP(clock => clk,
				data_in => datam1_m1w1,
				data_out => datam1w1_w1);
				
	W: WRITEBACK
	PORT MAP(clock => clk,
				data => datam1w1_w1,
				regwrite => regwritew_d1);
				
END Structure;