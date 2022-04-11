LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity PROCESSEUR is
  	port(
  		Clk : in std_logic;
    	offset : in std_logic_vector(23 downto 0);
    	PC : in std_logic_vector(31 downto 0);
    	Reset : in std_logic;
    	Rn: in std_logic_vector(3 downto 0);
    	Rd: in std_logic_vector(3 downto 0);
    	Rm: in std_logic_vector(3 downto 0);
    	Imm: in std_logic_vector(7 downto 0);
    	nPCsel: in std_logic;
    	Sortie: out std_logic_vector(31 downto 0)
    	);
end entity;

architecture RTL of PROCESSEUR is
	signal Instruction : std_logic_vector(31 downto 0);
	signal WrSrc: std_logic;
	signal MemWr: std_logic;
	signal ALUsrc: std_logic;
	signal ALUctr: std_logic_vector(1 downto 0);
	signal N: std_logic;
	signal RegSel: std_logic;
	signal RegWr: std_logic;
	signal PSREn: std_logic_vector(31 downto 0);
	signal A: std_logic_vector(31 downto 0);
	signal B: std_logic_vector(31 downto 0);
	signal RB: std_logic_vector(3 downto 0);
	signal sel: std_logic;
	signal off: std_logic_vector(23 downto 0) := offset;
	signal nr: std_logic_vector(3 downto 0);
	signal W: std_logic_vector(31 downto 0);
	signal mr: std_logic_vector(3 downto 0);
begin
	Instruction <= (others => 'Z');
	Sortie <= (others => 'Z');
	sel <= nPCsel;
	mr <= Rm;
	nr <= Rn;
	G1: entity work.GESTION port map (Clk => Clk, PC => PC, nPCsel => nPCsel, offset => offset, Instruction => Instruction);
	off <= offset;
	G2: entity work.decode port map (Clk => Clk, PC => PC, nPCsel => sel, offset => off,
							Reset => Reset, Instruction => Instruction, Rn => nr,
							WrSrc => WrSrc, MemWr => MemWr, Rm => mr,
							ALUctr => ALUctr, ALUsrc => ALUsrc, N => N,
							RegSel => RegSel, RegWr => RegWr, PSREn => PSREn);
	
	G21: entity work.multiplexeur(RTL) generic map (N => 3) port map (SEL => RB, A => Rm, B => Rd, COM => RegSel);

	G3: entity work.UNITE_TRAITEMENT(RTL) port map (
          Clk => Clk, Reset => Reset, OP => ALUctr, W => W,
          Sortie => W, RA => Rn,RB => RB, RW => Rd,
          WE => RegWr, N => N, Imm => Imm, COM => ALUsrc,
          WrEn => MemWr,COM1 => WrSrc, A => A, B => B);
	Sortie <= W;
end architecture;