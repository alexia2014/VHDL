LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity multiplexeur is
	 generic(N : integer:=31);
  	port(
    	A, B : in std_logic_vector(N downto 0);
    	COM : in std_logic;
    	SEL : out std_logic_vector(N downto 0));
end entity;

architecture RTL of multiplexeur is
begin
	process(A, B, COM)
	begin
		if COM = '0' then
			SEL <= A;
		else
			SEL <= B;
		end if;
	end process;
end architecture;