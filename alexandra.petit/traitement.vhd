library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TRAITEMENT is 
	port(
		Clk: in std_logic;
		Reset: in std_logic;
		OP: in std_logic_vector(1 downto 0);
		W : in std_logic_vector(31 downto 0);
		RA: in std_logic_vector(3 downto 0);
		RB: in std_logic_vector(3 downto 0);
		RW: in std_logic_vector(3 downto 0);
		WE: in std_logic;
		A, B: inout std_logic_vector (31 downto 0);
		N : out std_logic;
		S : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of TRAITEMENT is
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
	G2 : entity work.ALU port map (OP => OP,
									A => A,
									B => B,
									S => S,
									N => N);
end architecture;