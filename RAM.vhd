LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY RAM IS 
	PORT (databus : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0) ;
	      addr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	      rw    : IN STD_LOGIC;
      	      req   : IN STD_LOGIC;
	      ready : OUT STD_LOGIC);

END RAM;


ARCHITECTURE Structure OF RAM IS
	TYPE t_ram IS ARRAY(12 DOWNTO 0) OF STD_LOGIC_VECTOR(63 DOWNTO 0);

	SIGNAL ram: t_ram;
	SIGNAL status : STD_LOGIC;
	SIGNAL clock : STD_LOGIC;
BEGIN



	PROCESS(clock,req) 
	BEGIN
		status <= '1';
	END PROCESS;

	PROCESS(clock)
	BEGIN
		IF status = '1' AND clock = '0' AND rw = '1' THEN
			ram(CONV_INTEGER(addr(15 DOWNTO 3))) <= databus;
			read <= '0'
		END IF;
		IF status = '1' AND rw = '0' THEN
			databus <= ram(CONV_INTEGER(addr(15 DOWNTO 3)));
			read <= '0';
		END IF;
	END PROCESS;
END Structure;
