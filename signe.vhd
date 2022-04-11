LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity signe is
	generic(N : integer:=31);
  	port(
    	E : in std_logic_vector(N downto 0);
    	S : out std_logic_vector(31 downto 0));
end entity;

architecture RTL of signe is
begin
	S(N downto 0) <= E(N downto 0);
	G1 : for i in N to 31 generate
		S(i) <= E(N);
	end generate ; -- G1
end architecture;