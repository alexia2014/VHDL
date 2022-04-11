-- Banc de test pour l'exercice compteur

entity PROCESSEUR_tb is
port( OK: out Boolean := True);
end entity PROCESSEUR_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of PROCESSEUR_tb is
  signal Clk: std_logic;
  signal Reset: std_logic;
begin
    
    process
      begin
          while Now < 500 ns loop
              Clk <= '0';
              wait for 5 ns;
              Clk <= '1';
              wait for 5 ns;
          end loop;
          wait;
      end process;

    process
    begin
      Reset <= '1';
      wait for 10 ns;
      Reset <= '0';
      wait;
    end process;

  G1: entity work.PROCESSEUR port map (Clk => Clk, Reset => Reset);

end;
