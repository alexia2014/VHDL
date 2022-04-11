LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity memoire is
  	port(
  		Clk: in std_logic;
  		Reset: in std_logic;
  		DataIn: in std_logic_vector(31 downto 0);
  		DataOut: out std_logic_vector(31 downto 0);
  		Addr: in std_logic_vector(5 downto 0);
  		WrEn: in std_logic);
end entity;

architecture RTL of memoire is
	-- Declaration Type Tableau Memoire
	type table is array(63 downto 0) of std_logic_vector(31 downto 0);
	-- Fonction d'Initialisation du Banc de Registres
	function init_banc return table is
	variable result : table;
	begin
		for i in 63 downto 0 loop
			result(i) := (others=>'0');
		end loop;
		return result;
	end init_banc;
	-- Déclaration et Initialisation du Banc de Registres 64x32 bits
	signal Banc: table:=init_banc;
begin	
	process(Clk, Reset, DataIn, Addr, WrEn)
	begin
		if Reset = '0' then
			if rising_edge(Clk) then
				if WrEn = '1' then
					Banc(to_integer(unsigned(Addr))) <= DataIn;
				end if;
			end if;
		end if;
	end process;
	process(Clk, Reset, Addr, Banc)
	begin
		if Reset = '0' then
			DataOut <= Banc(to_integer(unsigned(Addr)));
		end if;
	end process;
end architecture;