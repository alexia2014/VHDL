-- Banc de test pour l'exercice compteur

entity multiplexeur_tb is
port( OK: out Boolean := True);
end entity multiplexeur_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of multiplexeur_tb is
  signal SEL : Std_logic_vector(31 downto 0);
  signal COM : Std_logic;
  signal A, B : Std_logic_vector(31 downto 0);

begin
    process
    begin
      COM <= '0';
      A <= B"00000000000000000000100000000001";
      B <= B"00000000000000001000000000000000";
      wait for 5 ns;
      assert SEL = A report "Fail com 0" severity failure;
      COM <= '1';
      wait for 5 ns;
      assert SEL = B report "Fail com 1" severity failure;     
      wait;
  end process;

  G1: entity work.multiplexeur(RTL) port map (SEL => SEL, A => A, B => B, COM => COM);

end;
