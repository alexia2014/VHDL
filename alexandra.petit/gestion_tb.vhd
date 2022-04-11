-- Banc de test pour l'exercice compteur

entity GESTION_tb is
port( OK: out Boolean := True);
end entity GESTION_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of GESTION_tb is
  signal Clk: std_logic;
  signal nPCsel: std_logic;
  signal offset: std_logic_vector(23 downto 0);
  signal PC : std_logic_vector(31 downto 0);
  signal Instruction: std_logic_vector (31 downto 0);
  signal Reset : std_logic;
begin
    
    process
      begin
          while Now < 20 ns loop
              Clk <= '0';
              wait for 5 ns;
              Clk <= '1';
              wait for 5 ns;
          end loop;
          wait;
      end process;

    process
    begin
        nPCsel <= '0';
        Reset <= '0';
        offset <= (others => '0');
        PC <= (others => '0');
        wait for 10 ns;
        assert Instruction = x"E3A01020" report "Test 1" severity failure;
        wait;
    end process;

  G1: entity work.GESTION(RTL) port map (Clk => Clk, PC => PC,
                  nPCsel => nPCsel, offset => offset,
                  Instruction => Instruction, Reset => Reset);

end;
