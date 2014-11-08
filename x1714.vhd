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
			inst  : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	-- Las señales auxiliares para conectar los modulos se nombraran de la siguiente forma: $nombresignal$etapafuente_$estapadestino
	signal instf_fd1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal instfd1_d1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
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
				inst => instfd1_d1);
	
	
END Structure;