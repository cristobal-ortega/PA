LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY suchProcessor IS 
	PORT (	datard_m	: INOUT	STD_LOGIC_VECTOR(63 DOWNTO 0);
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
				
				
				request_m : OUT STD_LOGIC := '0'
				
			
			);
END suchProcessor;

ARCHITECTURE Structure OF suchProcessor IS

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	
	--Los modulos se nombraran de la siguiente forma: (en Mayusuuculas las etapas) 
	-- nombre del fichero/componente = nombre completo
	-- nombre de la instaciacion en otro nivel = nombre abreviado
	COMPONENT FETCH
	PORT (
			clock : IN	STD_LOGIC;
			w	 : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			mem_ready : IN STD_LOGIC;
			z : IN STD_LOGIC;
			instr_jmp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			mem_bus : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			hit 	: OUT STD_LOGIC;
			inst  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			hazard: IN STD_LOGIC := '0';
			stall: IN STD_LOGIC := '0';
			pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT FETCH_DECODE1
	PORT (clock : IN	STD_LOGIC;
			stall: IN STD_LOGIC;
			hazard: IN STD_LOGIC := '0';
			inst_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			inst_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			
			);
	END COMPONENT;
	
	COMPONENT DECODE1
	PORT (clock : IN	STD_LOGIC;
			e_writeBR : IN STD_LOGIC; -- Permision to write in the register bank
			e_writeBR_long : IN STD_LOGIC; -- Permision to write in the register bank
			regDST : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_long : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			inst  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w_long : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			hazard: IN STD_LOGIC := '0';
			z : IN STD_LOGIC;
			instr_jmp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			e_writeBR_out : OUT STD_LOGIC; -- Decoded instruction writes the regiter bank
			e_writeBR_long_out : OUT STD_LOGIC; -- Decoded instruction writes the regiter bank
			op		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			a : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			b : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			regDST_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			
			);
	END COMPONENT;
	
	COMPONENT DECODE1_EXECUTION1
	PORT (clock    : IN	STD_LOGIC;
			stall    : IN STD_LOGIC;
			
			
			e_writeBR_in : IN STD_LOGIC;
			e_writeBR_long_in : IN STD_LOGIC;
			op_in		: IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			a_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			b_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			e_writeBR_out : OUT STD_LOGIC;
			e_writeBR_long_out : OUT STD_LOGIC;
			op_out   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
			a_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			b_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_out : OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			
			);
	END COMPONENT;
	
	COMPONENT EXECUTION1
	PORT (clock : IN	STD_LOGIC;
			op  : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			b : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			z : OUT STD_LOGIC
			);
	END COMPONENT;
	
	COMPONENT EXECUTION1_MEMORY1
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			e_writeBR_in : IN STD_LOGIC;
			w_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			instr_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			op_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			a_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			e_writeBR_out : OUT STD_LOGIC;
			w_out	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			instr_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			op_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			a_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000"
			);
	END COMPONENT;
	
	COMPONENT MEMORY1
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
	END COMPONENT;
	
	COMPONENT MEMORY1_WRITEBACK
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			
			e_writeBR_in : IN STD_LOGIC;
			data_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			instr_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			op_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			
			
			e_writeBR_out : OUT STD_LOGIC;
			data_out	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			regDST_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			instr_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			op_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			
			);
	END COMPONENT;
	
	COMPONENT WRITEBACK
	PORT (clock : IN	STD_LOGIC;
			data	: IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			data_long : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			e_writeBR_in : IN STD_LOGIC;
			e_writeBR_long_in : IN STD_LOGIC;
			
			e_writeBR_out : OUT STD_LOGIC;
			w : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000");
	END COMPONENT;
	
	
	COMPONENT F1
	PORT (clock : IN	STD_LOGIC;
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT F1_F2
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			e_writeBR_in : IN STD_LOGIC;
			w_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_in	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_in		: IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			
			e_writeBR_out : OUT STD_LOGIC;
			w_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_out	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_out		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"
			
			);
	END COMPONENT;
	
	COMPONENT F2
	PORT (clock : IN	STD_LOGIC;
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT F2_F3
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			e_writeBR_in : IN STD_LOGIC;
			w_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_in	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_in		: IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			
			e_writeBR_out : OUT STD_LOGIC;
			w_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_out	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_out		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"
			);
	END COMPONENT;
	
	COMPONENT F3
	PORT (clock : IN	STD_LOGIC;
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT F3_F4
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			e_writeBR_in : IN STD_LOGIC;
			w_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_in	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_in		: IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			
			e_writeBR_out : OUT STD_LOGIC;
			w_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_out	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_out		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"
			);
	END COMPONENT;
	
	COMPONENT F4
	PORT (clock : IN	STD_LOGIC;
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT F4_F5
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			e_writeBR_in : IN STD_LOGIC;
			w_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_in	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_in		: IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			
			e_writeBR_out : OUT STD_LOGIC;
			w_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_out	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_out		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"
			);
	END COMPONENT;
	
	COMPONENT F5
	PORT (clock : IN	STD_LOGIC;
			a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT F5_W
	PORT (clock : IN	STD_LOGIC;
			stall : IN STD_LOGIC;
			
			e_writeBR_in : IN STD_LOGIC;
			w_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_in	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_in		: IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			
			e_writeBR_out : OUT STD_LOGIC;
			w_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
			inst_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			rDST_out	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			op_out		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"
			);
	END COMPONENT;

	-- Las señales auxiliares para conectar los modulos se nombraran de la siguiente forma: $nombresignal$etapafuente_$estapadestino
	signal instf_fd1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal instfd1_d1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal pc_F_FD : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
	signal z_E : STD_LOGIC;
	signal hit_fetch : STD_LOGIC;
	signal pc_FD_D : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
	signal e_writeBR_in : STD_LOGIC;
	signal op_in		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	signal a_in : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal b_in : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal regDST_in : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal PC_in :STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal inst_in : STD_LOGIC_VECTOR(3 DOWNTO 0);
			
	--DECODE TO DECODE_EXECUTION
	signal e_writeBR_D_DE : STD_LOGIC; 
	signal op_D_DE		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal a_D_DE : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal b_D_DE : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regDST_D_DE : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal PC_D_DE : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal inst_D_DE : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal e_writeBR_long_D_DE : STD_LOGIC;
			
	--DECODE_EXECUTION TO EXECUTION
	signal e_writeBR_DE_E : STD_LOGIC;
	signal ewriteBR_long_D_DE : STD_LOGIC;
	signal op_DE_E   : STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
	signal a_DE_E : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal b_DE_E : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal regDST_DE_E : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal PC_DE_E : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal inst_DE_E : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	--EXECUTION
	signal w_E_EM : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
	--EXECUTION_MEMORY TO MEMORY
	signal e_writeBR_EM_M : STD_LOGIC;
	signal w_EM_M	 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal regDST_EM_M : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal PC_EM_M : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal instr_EM_M : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal op_EM_M : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal a_EM_M : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
	--MEMORY
	signal data_M_MW : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal hit_mem : STD_LOGIC;
	
	
	--MEMORY_WRITEBACK TO WRITEBACK
	signal e_writeBR_MW_W : STD_LOGIC;
	signal data_MW_W	 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal regDST_MW_W : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal PC_MW_W : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal instr_MW_W : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal op_MW_W : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	--WRITEBACK TO DECODE
	signal w_W_D : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal e_writeBR_W_D : STD_LOGIC;
	signal e_writeBR_long_W_D : STD_LOGIC;
	

	
	
	--LONG OPERATION
	signal wF1_F1F2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal wF2_F2F3 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal wF3_F3F4 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal wF4_F4F5 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal wF5_F5W : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
	signal e_writeBR_long_DE_F1 : STD_LOGIC;
	signal e_writeBR_F1F2_F2 : STD_LOGIC;
	signal e_writeBR_F2F3_F3 : STD_LOGIC;
	signal e_writeBR_F3F4_F4 : STD_LOGIC;
	signal e_writeBR_F4F5_F5 : STD_LOGIC;
	signal e_writeBR_F5W_W : STD_LOGIC;
	
	signal PC_F1F2_F2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal PC_F2F3_F3 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal PC_F3F4_F4 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal PC_F4F5_F5 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal PC_F5W_W : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
	signal op_F1F2_F2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal op_F2F3_F3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal op_F3F4_F4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal op_F4F5_F5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal op_F5W_W : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	signal rDST_F1F2_F2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal rDST_F2F3_F3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal rDST_F3F4_F4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal rDST_F4F5_F5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal rDST_F5W_W : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	
	
	signal inst_F1F2_F2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal inst_F2F3_F3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal inst_F3F4_F4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal inst_F4F5_F5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal inst_F5W_W : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	signal wF1F2_F2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal wF2F3_F3 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal wF3F4_F4 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal wF4F5_F5 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	signal wF5W_W : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	
	

	
	
	
	
	
	signal opd1_d1e1	: STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal opd1e1_e1	: STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal ewritedecodd1_d1e1 : STD_LOGIC;
	signal regad1_d1e1	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regad1e1_e1	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regbd1_d1e1	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regbd1e1_e1	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal ewritedecodd1e1_e1m1 : STD_LOGIC;
	signal we1_e1m1	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal we1m1_m1	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal ewritedecode1m1_m1w1 : STD_LOGIC;
	signal datam1_m1w1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal datam1w1_w1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal ewritedecodm1w1_d1 : STD_LOGIC;
	signal regwritew_d1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	
	--LONG
	signal regaF1_F1F2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regwF1_F1F2 : STD_LOGIC_VECTOR(15 DOWNTO 0);	
	
	signal regaF2_F2F3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regwF2_F2F3 : STD_LOGIC_VECTOR(15 DOWNTO 0);	
	
	signal regaF3_F3F4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regwF3_F3F4 : STD_LOGIC_VECTOR(15 DOWNTO 0);	
	
	signal regaF4_F4F5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regwF4_F4F5 : STD_LOGIC_VECTOR(15 DOWNTO 0);	
	
	signal regaF5_F5W : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal regwF5_F5W : STD_LOGIC_VECTOR(15 DOWNTO 0);	
	
	
	-- Señales para el control: $nombresignal_stage
	signal addr_m_aux : STD_LOGIC_VECTOR (15 DOWNTO 0);
	--signal stall_stage : STD_LOGIC := '0'; -- Stall el pipeline
	
BEGIN

	
				
	instF3 <= inst_F2F3_F3;
	instD <= inst_D_DE;
			
	regSRCs<= instfd1_d1;
	regDST_E <= regDST_DE_E;
	regDST_C <= regDST_EM_M;
	regDST_F1 <= regDST_DE_E;
	regDST_F2 <= rDST_F1F2_F2;
	regDST_F3 <= rDST_F2F3_F3;
	regDST_F4 <= rDST_F3F4_F4;
	regDST_F5 <= rDST_F5W_W;
			
			
	
	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0


	
	
	F: FETCH
	PORT MAP(clock => clk,
				w => w_E_EM,
				z => z_E,
				mem_ready => mem_fill,
				mem_bus => datard_m,
				instr_jmp => inst_DE_E,
				hit => hit_fetch,
				inst => instf_fd1,
				pc_out => pc_F_FD,
				hazard => hazard_detected,
				stall => stall_stage
				);
	
	F_D1: FETCH_DECODE1
	PORT MAP(clock => clk,
				stall => stall_stage,
				hazard => hazard_detected,
				inst_in => instf_fd1,
				inst_out => instfd1_d1,
				pc_in => pc_F_FD,
				pc_out => pc_FD_D
				);
	
	D1: DECODE1
	PORT MAP(clock => clk,
			e_writeBR => e_writeBR_MW_W,
			e_writeBR_long => e_writeBR_F5W_W,
			regDST => regDST_MW_W,
			regDST_long => rDST_F5W_W,
			inst => instfd1_d1,
			w => w_W_D,
			w_long => wF5W_W,
			hazard => hazard_detected,
			z => z_E,
			instr_jmp =>inst_DE_E,
			
			e_writeBR_out => e_writeBR_D_DE,
			e_writeBR_long_out => e_writeBR_long_D_DE,
			op => op_D_DE,
			a => a_D_DE,
			b => b_D_DE,
			regDST_out => regDST_D_DE,
			PC => PC_D_DE,
			inst_out => inst_D_DE
	);
	
	D1_E1: DECODE1_EXECUTION1
	PORT MAP(clock  => clk,
			stall => stall_stage,

			e_writeBR_in => e_writeBR_D_DE,
			e_writeBR_long_in => e_writeBR_long_D_DE,
			op_in => op_D_DE,
			a_in => a_D_DE,
			b_in => b_D_DE,
			regDST_in => regDST_D_DE,
			PC_in => pc_FD_D,
			inst_in => inst_D_DE,
			
			e_writeBR_out => e_writeBR_DE_E,
			e_writeBR_long_out => e_writeBR_long_DE_F1,
			op_out => op_DE_E,
			a_out => a_DE_E,
			b_out => b_DE_E,
			regDST_out => regDST_DE_E,
			PC_out => PC_DE_E,
			inst_out => inst_DE_E
			);
	
	E1: EXECUTION1
	PORT MAP(clock => clk,
				op => op_DE_E,
				a => a_DE_E, 
				b => b_DE_E,
				PC => PC_DE_E,
				inst_in => inst_DE_E,
				w => w_E_EM,
				z => z_E
				);
				
	E1_M1: EXECUTION1_MEMORY1
	PORT MAP(clock => clk,
			stall => stall_stage,
			
			e_writeBR_in => e_writeBR_DE_E,
			w_in => w_E_EM,
			regDST_in => regDST_DE_E,
			PC_in => PC_DE_E,
			instr_in => inst_DE_E,
			op_in => op_DE_E,
			a_in => a_DE_E,
			e_writeBR_out => e_writeBR_EM_M,
			w_out => w_EM_M,
			regDST_out => regDST_EM_M,
			PC_out => PC_EM_M,
			instr_out => instr_EM_M,
			op_out => op_EM_M,
			a_out => a_EM_M
			
			);
				
	M1: MEMORY1
	PORT MAP(clock => clk,
			
			instr_in => instr_EM_M,
			op_in => op_EM_M,
			w => w_EM_M,
			a => a_EM_M,
			mem_ready => mem_fill,
			mem_bus => datard_m,
			data => data_M_MW,
			hit => hit_mem
			
			);
				
	M1_W: MEMORY1_WRITEBACK
	PORT MAP(clock => clk,
			stall => stall_stage,
					
			e_writeBR_in => e_writeBR_EM_M,
			data_in => data_M_MW,
			regDST_in => regDST_EM_M,
			PC_in => PC_EM_M,
			instr_in => instr_EM_M,
			op_in => op_EM_M,
			
			e_writeBR_out => e_writeBR_MW_W,
			data_out => data_MW_W,
			regDST_out => regDST_MW_W,
			PC_out => PC_MW_W,
			instr_out => instr_MW_W,
			op_out => op_MW_W
			
			);
				
	W: WRITEBACK
	PORT MAP(clock => clk,
				data => data_MW_W,
				data_long => wF5W_W,
				e_writeBR_in => e_writeBR_MW_W,
				e_writeBR_long_in => e_writeBR_F5W_W,
				e_writeBR_out => e_writeBR_W_D,
				w => w_W_D
				);				
			
	L1: F1
	PORT MAP(clock => clk,
				a => a_DE_E,
				w => wF1_F1F2);
	
	L1_L2 : F1_F2
	PORT MAP(clock => clk,
			stall => stall_stage,
			
			e_writeBR_in => e_writeBR_long_DE_F1,
			w_in => wF1_F1F2,
			PC_in => PC_DE_E,
			inst_in => inst_DE_E,
			rDST_in => regDST_DE_E,
			op_in => op_DE_E,
			
			e_writeBR_out => e_writeBR_F1F2_F2,
			w_out => wF1F2_F2,
			PC_out => PC_F1F2_F2,
			inst_out => inst_F1F2_F2,
			rDST_out => rDST_F1F2_F2,
			op_out => op_F1F2_F2
			);
	
	L2: F2
	PORT MAP(clock => clk,
				a => wF1F2_F2,
				w => wF2_F2F3);
				
				
	L2_L3 : F2_F3
	PORT MAP(clock => clk,
			stall => stall_stage,
			
			e_writeBR_in => e_writeBR_F1F2_F2,
			w_in => wF2_F2F3,
			PC_in => PC_F1F2_F2,
			inst_in => inst_F1F2_F2,
			rDST_in => rDST_F1F2_F2,
			op_in => op_F1F2_F2,
			
			e_writeBR_out => e_writeBR_F2F3_F3,
			w_out => wF2F3_F3,
			PC_out => PC_F2F3_F3,
			inst_out => inst_F2F3_F3,
			rDST_out => rDST_F2F3_F3,
			op_out => op_F2F3_F3
			);	
				
				
	L3: F3
	PORT MAP(clock => clk,
				a => wF2F3_F3,
				w => wF3_F3F4);
				
				
	L3_L4 : F3_F4
	PORT MAP(clock => clk,
			stall => stall_stage,
			
			e_writeBR_in => e_writeBR_F2F3_F3,
			w_in => wF3_F3F4,
			PC_in => PC_F2F3_F3,
			inst_in => inst_F2F3_F3,
			rDST_in => rDST_F2F3_F3,
			op_in => op_F2F3_F3,
			
			e_writeBR_out => e_writeBR_F3F4_F4,
			w_out => wF3F4_F4,
			PC_out => PC_F3F4_F4,
			inst_out => inst_F3F4_F4,
			rDST_out => rDST_F3F4_F4,
			op_out => op_F3F4_F4
			);			
		
	L4: F4
	PORT MAP(clock => clk,
				a => wF3F4_F4,
				w => wF4_F4F5);
				
	L4_L5 : F4_F5
	PORT MAP(clock => clk,
			stall => stall_stage,
			
			e_writeBR_in => e_writeBR_F3F4_F4,
			w_in => wF4_F4F5,
			PC_in => PC_F3F4_F4,
			inst_in => inst_F3F4_F4,
			rDST_in => rDST_F3F4_F4,
			op_in => op_F3F4_F4,
			
			e_writeBR_out => e_writeBR_F4F5_F5,
			w_out => wF4F5_F5,
			PC_out => PC_F4F5_F5,
			inst_out => inst_F4F5_F5,
			rDST_out => rDST_F4F5_F5,
			op_out => op_F4F5_F5
			);	
				
	L5: F5
	PORT MAP(clock => clk,
				a => wF4F5_F5,
				w => wF5_F5W);
				
	L5_W : F5_W
	PORT MAP(clock => clk,
			stall => stall_stage,
			
			e_writeBR_in => e_writeBR_F4F5_F5,
			w_in => wF5_F5W,
			PC_in => PC_F4F5_F5,
			inst_in => inst_F4F5_F5,
			rDST_in => rDST_F4F5_F5,
			op_in => op_F4F5_F5,
			
			e_writeBR_out => e_writeBR_F5W_W,
			w_out => wF5W_W,
			PC_out => PC_F5W_W,
			inst_out => inst_F5W_W,
			rDST_out => rDST_F5W_W,
			op_out => op_F5W_W
			);
			
	request_m <= hit_fetch AND hit_mem;
	
	addr_m <= pc_F_FD WHEN hit_fetch = '0' ELSE w_EM_M;
		
				
END Structure;