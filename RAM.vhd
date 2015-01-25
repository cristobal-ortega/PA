LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY RAM IS 
	PORT (databus : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0) ;
	      addr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	      rw    : IN STD_LOGIC;
      	req   : IN STD_LOGIC;
	      ready : OUT STD_LOGIC);

END RAM;


ARCHITECTURE Structure OF RAM IS
	TYPE t_ram IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);

	SIGNAL ram: t_ram;
	SIGNAL status : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL clock : STD_LOGIC;
	
	SIGNAL databus_aux : STD_LOGIC_VECTOR(63 DOWNTO 0);
BEGIN

	PROCESS(clock)
	BEGIN
		IF clock = '1' THEN 
			IF req = '1' AND status = "00" THEN
				status <= "01";
			END IF;
			
			IF status = "00"  THEN
				ready <= '0';
			ELSIF status = "01" THEN
				IF rw = '1'  THEN
					ram(CONV_INTEGER(addr)) <= databus(7 DOWNTO 0);
					ram(CONV_INTEGER(addr)+1) <= databus(15 DOWNTO 8);
					ram(CONV_INTEGER(addr)+2) <= databus(23 DOWNTO 16);
					ram(CONV_INTEGER(addr)+3) <= databus(31 DOWNTO 24);
				ELSIF rw = '0' THEN
					databus_aux(7 DOWNTO 0) <= ram(CONV_INTEGER(addr));
					databus_aux(15 DOWNTO 8) <= ram(CONV_INTEGER(addr)+1);
					databus_aux(23 DOWNTO 16) <= ram(CONV_INTEGER(addr)+2);
					databus_aux(31 DOWNTO 24) <= ram(CONV_INTEGER(addr)+3);
				END IF;
				status <= "10";
			ELSIF status = "10" THEN
				IF rw = '1'  THEN
					ram(CONV_INTEGER(addr)+4) <= databus(39 DOWNTO 32);
					ram(CONV_INTEGER(addr)+5) <= databus(47 DOWNTO 40);
					ram(CONV_INTEGER(addr)+6) <= databus(55 DOWNTO 48);
					ram(CONV_INTEGER(addr)+7) <= databus(63 DOWNTO 56);
				ELSIF rw = '0' THEN
					databus_aux(39 DOWNTO 32) <= ram(CONV_INTEGER(addr)+4);
					databus_aux(47 DOWNTO 40) <= ram(CONV_INTEGER(addr)+5);
					databus_aux(55 DOWNTO 48) <= ram(CONV_INTEGER(addr)+6);
					databus_aux(63 DOWNTO 56) <= ram(CONV_INTEGER(addr)+7);
				END IF;
				status <= "11";
				ready <= '1';
			ELSIF status = "11" THEN	
				status <= "00";
			END IF;
		END IF;
	END PROCESS;
	databus <= databus_aux WHEN ( status /= "00" ) ELSE (OTHERS => 'Z');
END Structure;
