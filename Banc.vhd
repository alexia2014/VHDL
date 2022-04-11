library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BANC is 
	port(
		Clk: in std_logic;
		Reset: in std_logic;
		W: in std_logic_vector(31 downto 0);
		RA: in std_logic_vector(3 downto 0);
		RB: in std_logic_vector(3 downto 0);
		RW: in std_logic_vector(3 downto 0);
		WE: in std_logic;
		A, B: out std_logic_vector (31 downto 0)
    );
end entity;

architecture RTL of BANC is
	-- Declaration Type Tableau Memoire
	type table is array(15 downto 0) of std_logic_vector(31 downto 0);
	-- Fonction d'Initialisation du Banc de Registres
	function init_banc return table is
	variable result : table;
	begin
		for i in 14 downto 0 loop
			result(i) := (others=>'0');
		end loop;
		result(1):=x"00000001";
		result(15):=X"00000030";
		return result;
	end init_banc;
	-- Déclaration et Initialisation du Banc de Registres 16x32 bits
	signal Banc: table:=init_banc;
	signal Ab: integer;
	signal Ba: integer;
	signal Wr: integer;

begin
	Ab <= to_integer(unsigned(RA));
	Ba <= to_integer(unsigned(RB));
	Wr <= to_integer(unsigned(RW));
	process(Clk, Reset, W, RA, RB, RW, WE)
	begin
		if Reset = '0' then
			A <= Banc(Ab);
			B <= Banc(Ba);
			if rising_edge(Clk) then
				if WE = '1' then
					Banc(Wr) <= W;
				end if;
			end if;
		else
			Banc<=init_banc;
		end if;
	end process;
end architecture;