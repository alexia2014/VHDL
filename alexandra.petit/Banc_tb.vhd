-- Banc de test pour l'exercice compteur

entity Banc_tb is
port( OK: out Boolean := True);
end entity Banc_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;

architecture Bench of Banc_tb is
  signal Clk, Reset, WE: Std_logic;
  signal W : Std_logic_vector(31 downto 0);
  signal RA, RB, RW : Std_logic_vector(3 downto 0);
  signal A, B : Std_logic_vector(31 downto 0);

begin
    process
    begin
        while Now < 25 ns loop
            Clk <= '0';
            wait for 5 ns;
            Clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    process
    begin
        W <= (others => 'Z');
        RW <= (others => 'Z');
        RA <= (others => 'Z');
        RB <= (others => 'Z');
        WE <= '1';
        wait for 5 ns;
        W <= (others => '1');
        Reset <= '0';
        RW <= "0001";
        wait for 5 ns;
        WE <= '0';
        RA <= "0001";
        RB <= "0010";
        W <= (others => '0');
        RW <= "0010";
        wait for 5 ns;
        assert A= B"11111111111111111111111111111111" report "no" severity note;
        wait;
  end process;

  G1: entity work.BANC(RTL) port map (Clk => Clk, Reset => Reset,
    W => W, RA => RA, RB => RB, RW => RW, WE => WE, A => A, B => B);

end;