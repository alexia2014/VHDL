-- Banc de test pour l'exercice compteur

entity decode_tb is
port( OK: out Boolean := True);
end entity decode_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of decode_tb is
  signal Clk: std_logic;
  signal nPCsel: std_logic;
  signal offset: std_logic_vector(23 downto 0);
  signal Instruction: std_logic_vector (31 downto 0);
  signal WrSrc: std_logic;
  signal MemWr: std_logic;
  signal PSREn: std_logic_vector(31 downto 0);
  signal ALUsrc: std_logic;
  signal ALUctr: std_logic_vector(1 downto 0);
  signal RegSel: std_logic;
  signal RegWr: std_logic;
  signal PC : std_logic_vector(31 downto 0);
  signal Rn: std_logic_vector(3 downto 0);
  signal Rm: std_logic_vector(3 downto 0);
  signal Reset : std_logic;
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
        PSREn <= (others => '0');
        PC <= (others => '0');
        Rn <= "0000";
        Rm <= (others => 'Z');
        offset <= (others => '0');
        Reset <= '0';
        Instruction <= "11100011101000000010000100000011";
        wait for 10 ns;
        assert RegSel = '1' report "RegSel1" severity warning;
        assert ALUsrc = '1' report "ALUsrc1" severity warning;
        wait for 5 ns;
        Instruction <= "11101010000000000000000000000001";
        wait for 10 ns;
        assert nPCsel = '1' report "nPCsel" severity warning;
        assert ALUsrc = '0' report "ALUsrc2" severity warning;
        assert ALUctr = "00" report "ALUctr2" severity warning;
        wait;

    end process;

  G1: entity work.decode(RTL) port map (Clk => Clk, PC => PC,
                  nPCsel => nPCsel, offset => offset, Reset => Reset,
                  Instruction => Instruction, WrSrc => WrSrc, MemWr => MemWr,
                  PSREn => PSREn, ALUsrc => ALUsrc, ALUctr => ALUctr, RegSel => RegSel,
                  RegWr => RegWr, Rn => Rn, Rm => Rm);
end;
