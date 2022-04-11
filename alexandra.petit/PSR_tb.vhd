-- Banc de test pour l'exercice compteur

entity PSR_tb is
port( OK: out Boolean := True);
end entity PSR_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of PSR_tb is
    signal Clk: std_logic;
    signal DATAIN: std_logic_vector(31 downto 0);
    signal WE: std_logic;
    signal RST: std_logic;
    signal DATAOUT: std_logic_vector(31 downto 0);
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
        DATAIN <= (others => '0');
        WE <= '1';
        RST <= '0';
        wait for 10 ns;
        assert DATAOUT = "00000000000000000000000000000001" report "dataout" severity failure;
        wait;
    end process;

  G1: entity work.PSR port map (Clk => Clk,
      DATAIN => DATAIN,
      WE => WE,
      RST => RST,
      DATAOUT => DATAOUT);

end;
