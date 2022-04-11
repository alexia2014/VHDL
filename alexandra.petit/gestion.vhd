LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity GESTION is
  	port(
  		Clk : in std_logic;
    	PC : inout std_logic_vector(31 downto 0);
    	nPCsel : in std_logic;
    	offset : in std_logic_vector(23 downto 0);
    	Instruction : out std_logic_vector(31 downto 0);
    	Reset : in std_logic
    );
end entity;

architecture RTL of GESTION is
	signal off : std_logic_vector(31 downto 0);
	signal pc1 : std_logic_vector(31 downto 0);
begin
	G0: entity work.signe(RTL) generic map (N => 23) port map(E => offset, S => off);
	process (Clk)
	begin
		if Reset = '0' then
			if rising_edge(Clk) then
				if nPCsel = '0' then
					if unsigned(PC) + 1 < 9 then
						PC <= std_logic_vector(unsigned(PC) + 1);
					else
						PC <= "00000000000000000000000000000000";
					end if;
				else
					if unsigned(PC) + 1 + unsigned(off) < 9 then
						PC <= std_logic_vector(unsigned(PC)+ 1 + unsigned(off));
					else
						PC <= std_logic_vector(9-(unsigned(PC)+unsigned(off)));
					end if;
				end if;
			end if;
		else
			PC <= (others => '0');
		end if;
	end process;

	G2 : entity work.instruction_memory(RTL) port map (PC => PC, Instruction => Instruction);
end architecture;