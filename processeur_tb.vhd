-- Banc de test pour l'exercice compteur

entity PROCESSEUR_tb is
port( OK: out Boolean := True);
end entity PROCESSEUR_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of PROCESSEUR_tb is
  signal Clk: std_logic;
  signal Rn: std_logic_vector(3 downto 0);
  signal Rd: std_logic_vector(3 downto 0);
  signal Rm: std_logic_vector(3 downto 0);
  signal Reset: std_logic;
  signal offset: std_logic_vector(23 downto 0);
  signal PC : std_logic_vector(31 downto 0);
  signal Imm: std_logic_vector(7 downto 0);
  signal Sortie: std_logic_vector(31 downto 0);
  signal nPCsel: std_logic;
begin
    
    process
      begin
          while Now < 50 ns loop
              Clk <= '0';
              wait for 5 ns;
              Clk <= '1';
              wait for 5 ns;
          end loop;
          wait;
      end process;

    process
    begin
        Rn <= (others => 'Z');
        Rd <= (others => 'Z');
        Rm <= (others => 'Z');
        Reset <= '0';
        offset <= (others => 'Z');
        PC <= (others => 'Z');
        Imm <= (others => 'Z');
        nPCsel <= '0';
        wait for 5 ns;
        -- ADD immediate Rd:=Rn+Imm
        nPCsel <= '1';
        offset <= "000000000000000000000011";
        PC <= (others => '0');
        Rn <= "0001";
        Rd <= "0010";
        Imm <= "00000001";
        wait for 2 ns;
        assert Sortie = "00000000000000000000000000000001" report "Sortie1" severity warning;
        wait for 10 ns;
        -- LDR Rd:=Mem(Rn + Offset)
        nPCsel <= '1';
        offset <= "000000000000000000000111";
        Rn <= "0001";
        Rd <= "0011";
        Rm <= "1111";
        Imm <= "00000001";
        wait for 20 ns;
        assert Sortie = "00000000000000000000000000110000" report "Sortie2" severity warning;        wait;
    end process;

  G1: entity work.PROCESSEUR port map (Clk => Clk, PC => PC,
                  offset => offset, Sortie => Sortie, nPCsel => nPCsel,
                  Reset => Reset, Rn => Rn, Rd => Rd, Rm => Rm, Imm => Imm);

end;
