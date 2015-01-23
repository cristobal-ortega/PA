LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY CHIP IS 
	PORT (clock : IN	STD_LOGIC;
			instF3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			instD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			s_hazard : OUT STD_LOGIC_VECTOR
			);

END CHIP;


ARCHITECTURE Structure OF CHIP IS

	COMPONENT suchProcessor
	PORT (datard_m	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000" ;
			boot		: IN	STD_LOGIC;
			clk		: IN	STD_LOGIC;
			interrupt: IN  STD_LOGIC;
			stall_stage : IN STD_LOGIC := '0';
			fill_m : IN STD_LOGIC := '0';
				
			instF3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --structural hazards =)
			instD : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);	
			
			regSRCa : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --data hazards =)
			regSRCb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_E: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_C : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F5 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			
			request_m : OUT STD_LOGIC := '0'
			);
	END COMPONENT;
	
	COMPONENT suchControl IS 
	PORT (clock : IN	STD_LOGIC;

			);

	END COMPONENT;

	
BEGIN

	PROCESS(clock)
	BEGIN

	END PROCESS;

END Structure;