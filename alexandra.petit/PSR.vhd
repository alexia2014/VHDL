LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity PSR is
  	port(
  		Clk : in std_logic;
    	DATAIN : in std_logic_vector(31 downto 0);
    	WE : in std_logic;
    	RST : in std_logic;
    	DATAOUT : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of PSR is
begin
	process(Clk, DATAIN, WE, RST)
	begin
		DATAOUT <= DATAIN;
		if RST = '0' then
			if rising_edge(Clk) then
				if WE = '1' then
					DATAOUT(0) <= '1';
				end if;
			end if;
		end if;
	end process;
end architecture;