-- Banc de test pour l'exercice compteur

entity ALU_tb is
port( OK: out Boolean := True);
end entity ALU_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench1 of ALU_tb is
  signal OP : Std_logic_vector(1 downto 0);
  signal S : Std_logic_vector(31 downto 0);
  signal N : Std_logic;
  signal A, B : Std_logic_vector(31 downto 0);

begin
    process
    begin
      OP <= "11";
      A <= B"00000000000000000000100000000001";
      B <= B"00000000000000001000000000000000";
      wait for 5 ns;
      assert S = B"00000000000000000000100000000001" report "A" severity failure;
      OP <= "01";
      wait for 5 ns;
      assert S = B"00000000000000001000000000000000" report "B" severity failure;
      OP <= "00";
      wait for 5 ns;
      assert S = B"00000000000000001000100000000001" report "A + B" severity warning;
      OP <= "10";
      wait for 5 ns;
      assert S = B"11111111111111111000100000000001" report "A - B" severity failure;


      wait;
  end process;

  G1: entity work.ALU(RTL) port map (OP => OP, S => S, A => A, B => B, N => N);

end;
