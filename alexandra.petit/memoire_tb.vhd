-- Banc de test pour l'exercice compteur

entity memoire_tb is
port( OK: out Boolean := True);
end entity memoire_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;

architecture Bench of memoire_tb is
  signal Clk, Reset, WrEn: Std_logic;
  signal Addr : Std_logic_vector(5 downto 0);
  signal DataIn, DataOut : Std_logic_vector(31 downto 0);
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
        Addr <= (others => 'Z');
        Reset <= '1';
        DataIn <= (others => 'Z');
        DataOut <= (others => 'Z');
        WrEn <= '0';
        wait for 5 ns;
        Addr <= "000001";
        Reset <= '0';
        wait for 10 ns;
        DataIn <= "11111111111111111111111111111111";
        assert Addr="000001" report "erreur addr" severity note;
        WrEn <= '1';
        wait for 5 ns;
        WrEn <= '0';
        wait for 5 ns;
        assert DataOut= B"11111111111111111111111111111111" report "no" severity note;
        wait;
  end process;

  G1: entity work.memoire(RTL) port map (Clk => Clk, Reset => Reset,
        DataIn => DataIn, DataOut => DataOut, Addr => Addr, WrEn => WrEn);

end;