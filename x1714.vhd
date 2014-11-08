LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY x1714 IS 
	PORT (	datard_m	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_m	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
				boot		: IN	STD_LOGIC;
				clk		: IN	STD_LOGIC;
				interrupt: IN  STD_LOGIC);
END x1714;

ARCHITECTURE Structure OF x1714 IS

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	COMPONENT FETCH
	PORT (clock : IN	STD_LOGIC);
	END COMPONENT;
	
	
BEGIN
	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0
	
	F: FETCH
	PORT MAP(clock => clk );
	
	
END Structure;