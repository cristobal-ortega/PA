LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY suchControl IS 
	PORT (clock : IN	STD_LOGIC;
			instF3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --structural hazards =)
			instD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);	
			
			regSRCa : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --data hazards =)
			regSRCb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_E: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			hit 	    : IN STD_LOGIC := '0';
			request_m : IN STD_LOGIC := '0';
			
			stall_control : OUT STD_LOGIC;			--treat everything like stall
			memory_request : OUT STD_LOGIC := '0';
			hazard_detected : OUT STD_LOGIC
			);

END suchControl;


ARCHITECTURE Structure OF suchControl IS

--structural hazards
--data hazards

	COMPONENT STRUCTURAL_HAZARDS
	PORT (clock : IN	STD_LOGIC;
			instF3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			instD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			s_hazard : OUT STD_LOGIC
			
			);
	END COMPONENT;
	
	COMPONENT DATA_HAZARDS
	PORT (clock : IN	STD_LOGIC;
			regSRCa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regSRCb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_E: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			d_hazard : OUT STD_LOGIC
			
			);
	END COMPONENT;

	signal s_hazard_control : STD_LOGIC;
	signal d_hazard_control : STD_LOGIC;
	signal memory_request_aux : STD_LOGIC := '0';
	
BEGIN

	SH: STRUCTURAL_HAZARDS
	PORT MAP(clock => clock,
				instF3 => instF3,
				instD => instD,
				s_hazard => s_hazard_control
				);
				
	DH : DATA_HAZARDS
	PORT MAP(clock => clock,
			regSRCa => regSRCa,
			regSRCb => regSRCb,
			regDST_E => regDST_E, 
			regDST_C  => regDST_C,
			regDST_F1  => regDST_F1,
			regDST_F2  => regDST_F2, 
			regDST_F3  => regDST_F3,
			regDST_F4  => regDST_F4,
			regDST_F5  => regDST_F5,
			d_hazard  => d_hazard_control

				);
	

	hazard_detected <= s_hazard_control OR d_hazard_control;
	
	WITH hit SELECT stall_control <= '1' WHEN '0',
														'0' WHEN OTHERS;
	WITH request_m SELECT memory_request <= '1' WHEN '0',
														 '0' WHEN OTHERS;
	
	PROCESS(clock)
	BEGIN
		--hazard_detected <= '0';
		--IF( s_hazard_control = '1' OR d_hazard_control = '1' ) THEN
		-- hazard_detected <= '1';
		--END IF;
		--stall_control <= '0';
		--IF ( request_m = '1' ) THEN
		--	stall_control <= '1';
		--END IF;
	END PROCESS;
END Structure;