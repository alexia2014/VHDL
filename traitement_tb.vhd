-- Banc de test pour l'exercice compteur

entity TRAITEMENT_tb is
port( OK: out Boolean := True);
end entity TRAITEMENT_tb;

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;


architecture Bench of TRAITEMENT_tb is
  signal Clk: std_logic;
  signal Reset: std_logic;
  signal OP: std_logic_vector(1 downto 0);
  signal W : std_logic_vector(31 downto 0);
  signal RA: std_logic_vector(3 downto 0);
  signal RB: std_logic_vector(3 downto 0);
  signal RW: std_logic_vector(3 downto 0);
  signal WE: std_logic;
  signal A, B: std_logic_vector (31 downto 0);
  signal N : std_logic;
  signal S : std_logic_vector(31 downto 0);
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
        W <= (others => 'Z');
        RW <= "1111";
        RA <= "1111";
        RB <= "0001";
        OP <= (others => 'Z');
        Reset <= '0';
        A <= (others => 'Z');
        B <= (others => 'Z');
        S <= (others => 'Z');
        -- R(1) = R(15)
        WE <= '1';
        wait for 2 ns;
        WE <= '0';
        wait for 2 ns;
        RW <= "0001";
        WE <= '1';
        wait for 2 ns;
        assert A = "00000000000000000000000000110000" report "R(15) failed" severity failure;
        W <= A;
        wait for 4 ns;
        WE <= '0';
        wait for 2 ns;
        assert B = "00000000000000000000000000110000" report "R(1) failed" severity failure;
        -- R(1) = R(1) + R(15)
        WE <= '0';
        OP <= "00";
        wait for 2 ns;        
        assert S = "00000000000000000000000001100000" report "R(1) + R(15) failed" severity failure;
        WE <= '1';
        W <= S;
        RA <= "0001";
        wait for 2 ns;
        WE <= '0';
        wait for 2 ns;
        assert A = "00000000000000000000000001100000" report "R(1) failed too" severity failure;
        -- R(2) = R(1) + R(15)
        WE <= '0';
        OP <= "00";
        WE <= '1';
        wait for 2 ns;
        WE <= '0';
        wait for 2 ns;
        RW <= "0001";
        RB <= "1111";
        WE <= '1';
        wait for 2 ns;        
        assert S = "00000000000000000000000001100000" report "R(1) + R(15) failed" severity failure;
        RW <= "0010";
        W <= S;
        wait for 2 ns;
        WE <= '1';
        wait for 2 ns;
        -- R(3) = R(1) - R(15)
        WE <= '0';
        OP <= "10";
        WE <= '1';
        wait for 2 ns;
        WE <= '0';
        wait for 2 ns;
        RW <= "0001";
        RB <= "1111";
        WE <= '1';
        wait for 2 ns;        
        assert S = "00000000000000000000000000110000" report "R(1) - R(15) failed" severity failure;
        RW <= "0011";
        W <= S;
        wait for 2 ns;
        WE <= '1';
        wait for 2 ns;
        WE <= '0';
        RA <= "0011";
        wait for 2 ns;
        assert A = "00000000000000000000000000110000" report "R(1) failed to" severity failure;
        -- R(5) = R(7) - R(15)
        WE <= '0';
        wait for 2 ns;
        RB <= "1111";
        RA <= "0111";
        OP <= "11";
        wait for 2 ns;
        assert A = "00000000000000000000000000000000" report "R(7) failed" severity failure;
        OP <= "01";
        assert B = "00000000000000000000000000110000" report "R(15) failed" severity failure;
        wait for 2 ns;
        OP <= "10";
        wait for 2 ns;
        assert n = '1' report "n failed" severity failure;
        wait for 2 ns;
        assert S = "11111111111111111111111111010000" report "R(7) - R(15) failed" severity failure;
        RW <= "0101";
        W <= S;
        WE <= '0';
        wait for 2 ns;
        WE <= '1';
        wait for 2 ns;
        RA <= "0101";
        wait for 4 ns;
        assert A = "11111111111111111111111111010000" report "R(5) failed to" severity failure;
        wait;
    end process;

  G1: entity work.TRAITEMENT(RTL) port map (
          Clk => Clk,
          Reset => Reset,
          OP => OP,
          W => W,
          RA => RA,
          RB => RB,
          RW => RW,
          WE => WE,
          S => S,
          A => A,
          B => B,
          N => N);

end;
