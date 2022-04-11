-- Banc de test pour l'exercice compteur

entity UNITE_TRAITEMENT_tb is
port( OK: out Boolean := True);
end entity UNITE_TRAITEMENT_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of UNITE_TRAITEMENT_tb is
  signal Clk: std_logic;
  signal Reset: std_logic;
  signal OP: std_logic_vector(1 downto 0);
  signal W : std_logic_vector(31 downto 0);
  signal RA, RB, RW: std_logic_vector(3 downto 0);
  signal WE: std_logic;
  signal Sortie: std_logic_vector(31 downto 0);
  signal N : std_logic;
  signal Imm : std_logic_vector(7 downto 0);
  signal COM : std_logic;
  signal WrEn : std_logic;
  signal COM1 : std_logic;
  signal A : std_logic_vector(31 downto 0);
  signal B : std_logic_vector(31 downto 0);
begin
    process
      begin
          while Now < 60 ns loop
              Clk <= '0';
              wait for 2 ns;
              Clk <= '1';
              wait for 2 ns;
          end loop;
          wait;
      end process;

    process
    begin
        W <= (others => '1');
        OP <= "00";
        A <= (others => 'Z');
        B <= (others => 'Z');
        RW <= (others => '0');
        Reset <= '0';
        WE <= '0';
        RA <= "1111";
        RB <= "0001";
        COM <= '0';
        COM1 <= '0';
        Imm <= (others => '0');
        WrEn <= '0';
        wait for 2 ns;

        -- Add R(15) + R(7)
        WE <= '1';
        RB <= "0111";
        RW <= "0111";
        W <= "10000000000000000000000000110000";
        wait for 6 ns;
        WE <= '0';

        -- Add R(15) + 1
        COM <= '1';
        Imm <= "00000001";
        OP <= "00";
        wait for 4 ns;

        -- Soustraction R(15) - R(7)
        WE <= '1';
        W <= "00000000000000000000000000000010";
        COM <= '0';
        wait for 6 ns;

        OP <= "11";
        wait for 6 ns;
        WE <= '0';

        -- Soustraction R(15) - 1
        COM <= '1';
        OP <= "11";
        wait for 2 ns;

        -- Copie
        RW <= "0111";
        W <= A;
        WE <= '1';

        wait for 2 ns;

        -- Ecriture et Lecture
        OP <= "11";
        WrEn <= '1';
        COM1 <= '1';
        wait;
    end process;

  G1: entity work.UNITE_TRAITEMENT(RTL) port map (
          Clk => Clk,
          Reset => Reset,
          OP => OP,
          W => W,
          Sortie => Sortie,
          RA => RA,
          RB => RB,
          RW => RW,
          WE => WE,
          N => N,
          Imm => Imm,
          COM => COM,
          WrEn => WrEn,
          COM1 => COM1, A => A, B => B);
end;
