LIBRARY ieee;
USE ieee.std_logic_1164.all;



ENTITY EXECUTION1 IS 
	PORT (clock : IN	STD_LOGIC;
			op  : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			b : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			z : OUT STD_LOGIC
			
			);

END EXECUTION1;


ARCHITECTURE Structure OF EXECUTION1 IS

	COMPONENT ALU
	PORT (x  : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			y  : IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			w  : OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			op : IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			z  : OUT STD_LOGIC);
	END COMPONENT;
	
	signal a_internal : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal z_internal : STD_LOGIC;

	
BEGIN
	--En A el registro a comprar
	--En B tengo el inmediato sumar
	--En PC tengo el pc a sumar
	
	WITH inst_in SELECT a_internal <= PC WHEN "0111",
												 a  WHEN OTHERS;
	
-- Aqui va una alu, => encapsular esto dfe aqui aabjo
	ALU1: ALU
	PORT MAP(x => a_internal,
				y => b,
				w => w,
				op => op,
				z => z_internal);
	
	
	z <= '1' when (a = "0000000000000000") else '0';

END Structure;