library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UNITE_TRAITEMENT is
	port(
		Clk: in std_logic;
		Reset: in std_logic;
		OP: in std_logic_vector(1 downto 0);
		W : in std_logic_vector(31 downto 0);
		Sortie : out std_logic_vector(31 downto 0);
		RA: in std_logic_vector(3 downto 0);
		RB: in std_logic_vector(3 downto 0);
		RW: in std_logic_vector(3 downto 0);
		WE: in std_logic;
		N : out std_logic;
		A, B: inout std_logic_vector(31 downto 0);
		Imm : in std_logic_vector(7 downto 0);
		COM : in std_logic;
		WrEn : in std_logic;
		COM1 : in std_logic
    );
end entity;

architecture RTL of UNITE_TRAITEMENT is
	signal C : std_logic_vector(31 downto 0);
	signal D : std_logic_vector(31 downto 0);
	signal S : std_logic_vector(31 downto 0);
	signal E : std_logic_vector(31 downto 0);
	signal F : std_logic_vector(31 downto 0);
	signal G : std_logic_vector(31 downto 0);
begin
	G1 : entity work.BANC port map (Clk => Clk,
			Reset => Reset,
			RA => RA,
			RB => RB,
			RW => RW,
			A => A,
			B => B,
			W => W,
			WE => WE);
	D <= B;
	G2 : entity work.signe(RTL) generic map (N => 7) port map (E => Imm, S => C);

	G3: entity work.multiplexeur(RTL) generic map (N => 31) port map (SEL => E, A => B, B => C, COM => COM);

	G4 : entity work.ALU port map (OP => OP, A => A, B => E, S => F, N => N);
	G5 : entity work.memoire(RTL) port map (Clk => Clk, Reset => Reset,
        DataIn => D, DataOut => G, Addr => F(5 downto 0), WrEn => WrEn);

	G6: entity work.multiplexeur(RTL) generic map (N => 31) port map (SEL => Sortie, A => F, B => G, COM => COM1);

end architecture;