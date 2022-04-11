library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is 
	port(
		OP: in std_logic_vector (1 downto 0);
		A, B: in std_logic_vector (31 downto 0);
		S: out std_logic_vector(31 downto 0);
		N: out std_logic
    );
end entity;

architecture RTL of ALU is
	signal Ab: signed (31 downto 0);
	signal Ba: signed (31 downto 0);
	signal AbBa: std_logic_vector (31 downto 0);
	signal BaAb: std_logic_vector (31 downto 0);
begin
	Ab <= signed(A);
	Ba <= signed(B);
	AbBa <= std_logic_vector(Ab + Ba);
	BaAb <= std_logic_vector(Ab - Ba);
	process(OP, A, B, Ab, Ba)
	begin
		S <= (others => '0');
		N <= '0';
		if OP = "00" then
			if AbBa(31) = '1' then
				N <= '1';
			end if;
			S <= AbBa;
		elsif OP = "01" then
			S <= B;
			if B(31) = '1' then
				N <= '1';
			end if;
		elsif OP = "10" then
			if BaAb(31) = '1' then
				N <= '1';
			end if;
			S <= BaAb;
		else
			S <= A;
			if A(31) = '1' then
				N <= '1';
			end if;
		end if;
	end process;
end architecture;