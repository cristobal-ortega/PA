LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY CHIP IS 
	PORT (clock : IN	STD_LOGIC;
			boot : IN STD_LOGIC;
			interrupt : IN STD_LOGIC);

END CHIP;


ARCHITECTURE Structure OF CHIP IS

	COMPONENT suchProcessor
	PORT (datard_m	: INOUT	STD_LOGIC_VECTOR(63 DOWNTO 0);
			addr_m	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000" ;
			boot		: IN	STD_LOGIC;
			clk		: IN	STD_LOGIC;
			interrupt: IN  STD_LOGIC;
			mem_fill : IN STD_LOGIC;
			stall_stage : IN STD_LOGIC := '0';
			hazard_detected : IN STD_LOGIC := '0';
			
			instF3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --structural hazards =)
			instD : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);	
			
			regSRCs : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --data hazards =)
			regDST_E: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_C : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F5 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_F5W : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			request_m : OUT STD_LOGIC := '0'
			);
	END COMPONENT;
	
	COMPONENT suchControl IS 
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
			regDST_F5W : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			hit 	    : IN STD_LOGIC := '0';
			request_m : IN STD_LOGIC := '0';
			
			stall_control : OUT STD_LOGIC;			--treat everything like stall
			memory_request : OUT STD_LOGIC := '0';
			hazard_detected : OUT STD_LOGIC
			);

	END COMPONENT;

	COMPONENT RAM IS 
	PORT (databus : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0) ;
	      addr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	      rw    : IN STD_LOGIC;
      	req   : IN STD_LOGIC;
	      ready : OUT STD_LOGIC);

	END COMPONENT;
	
	signal datard_m_bus : STD_LOGIC_VECTOR(63 DOWNTO 0);
	signal addr_m_bus : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000" ;
	
	signal interrupt_bus : STD_LOGIC;
	signal stall_stage_bus : STD_LOGIC := '0';
	signal hazard_detected_bus : STD_LOGIC := '0';

	signal instF3_bus : STD_LOGIC_VECTOR(3 DOWNTO 0); --structural hazards =)
	signal instD_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);	
		
	signal regSRCs_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);	
	signal regSRCa_bus : STD_LOGIC_VECTOR(3 DOWNTO 0); --data hazards =)
	signal regSRCb_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal regDST_E_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal regDST_C_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal regDST_F1_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal regDST_F2_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal regDST_F3_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal regDST_F4_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal regDST_F5_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal regDST_F5W_bus : STD_LOGIC_VECTOR(3 DOWNTO 0);	
	
	signal request_m_bus : STD_LOGIC := '0';
	signal mem_ready : STD_LOGIC := '0' ;
	signal memory_request_bus : STD_LOGIC := '0';
	
BEGIN

	sP : suchProcessor
	PORT MAP(datard_m => datard_m_bus,
			addr_m => addr_m_bus,
			boot => boot,
			clk => clock,
			interrupt => interrupt_bus,
			mem_fill => mem_ready,
			stall_stage => stall_stage_bus,
			hazard_detected => hazard_detected_bus,
			
			instF3 => instF3_bus,
			instD => instD_bus,
			
			regSRCs => regSRCs_bus,
			regDST_E => regDST_E_bus,
			regDST_C => regDST_C_bus,
			regDST_F1 => regDST_F1_bus,
			regDST_F2 => regDST_F2_bus,
			regDST_F3 => regDST_F3_bus,
			regDST_F4 => regDST_F4_bus,
			regDST_F5 => regDST_F5_bus,
			regDST_F5W => regDST_F5W_bus,
			
			request_m => request_m_bus
			);

	sC : suchControl
	PORT MAP(
			clock => clock,
			instF3 => instF3_bus,
			instD => instD_bus,
			
			regSRCa => regSRCs_bus(11 DOWNTO 8),
			regSRCb => regSRCs_bus(7 DOWNTO 4),
			regDST_E => regDST_E_bus,
			regDST_C => regDST_C_bus,
			regDST_F1 => regDST_F1_bus,
			regDST_F2 => regDST_F2_bus,
			regDST_F3 => regDST_F3_bus,
			regDST_F4 => regDST_F4_bus,
			regDST_F5 => regDST_F5_bus,
			regDST_F5W => regDST_F5W_bus,
			
			hit => request_m_bus,
			request_m => mem_ready,
			
			stall_control => stall_stage_bus,
			memory_request => memory_request_bus,
			hazard_detected => hazard_detected_bus
		);
		
		mem1 : RAM
		PORT MAP(databus => datard_m_bus,
				addr => addr_m_bus,
				rw  => '0',
				req  => memory_request_bus,
				ready => mem_ready);
END Structure;