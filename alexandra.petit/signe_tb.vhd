-- Banc de test pour l'exercice compteur

entity signe_tb is
port( OK: out Boolean := True);
end entity signe_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of signe_tb is
  signal E : Std_logic_vector(2 downto 0);
  signal S : Std_logic_vector(31 downto 0);

begin
    process
    begin
      E <= "001";
      wait for 5 ns;
      E <= "101";
      wait for 5 ns;
      wait;
  end process;

  G1: entity work.signe(RTL) generic map (N => 2) port map (E => E, S => S);

end;
