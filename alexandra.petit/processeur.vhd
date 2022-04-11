LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity PROCESSEUR is
  	port(
  		Clk : in std_logic;
    	Reset : in std_logic
    	);
end entity;

architecture RTL of PROCESSEUR is
	signal offset: std_logic_vector(23 downto 0);
	signal PC : std_logic_vector(31 downto 0) := (others => '0');
	signal Rn : std_logic_vector(3 downto 0);
	signal Rd : std_logic_vector(3 downto 0);
	signal Rm : std_logic_vector(3 downto 0);
	signal Imm : std_logic_vector(7 downto 0);
	signal nPCsel : std_logic;
	signal Sortie : std_logic_vector(31 downto 0);
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
	signal W: std_logic_vector(31 downto 0);
begin
	G1: entity work.GESTION port map (Clk => Clk, PC => PC, nPCsel => nPCsel, offset => offset, Instruction => Instruction, Reset => Reset);
	G2: entity work.decode port map (Clk => Clk, PC => PC, nPCsel => nPCsel, offset => offset,
							Reset => Reset, Instruction => Instruction, Rn => Rn,
							WrSrc => WrSrc, MemWr => MemWr, Rm => Rm,
							ALUctr => ALUctr, ALUsrc => ALUsrc,
							RegSel => RegSel, RegWr => RegWr, Rd => Rd, Imm => Imm);
	
	G21: entity work.multiplexeur(RTL) generic map (N => 3) port map (SEL => RB, A => Rm, B => Rd, COM => RegSel);

	G3: entity work.UNITE_TRAITEMENT(RTL) port map (
          Clk => Clk, Reset => Reset, OP => ALUctr, W => W,
          Sortie => W, RA => Rn,RB => Rm, RW => Rd,
          WE => RegWr, N => N, Imm => Imm, COM => ALUsrc,
          WrEn => MemWr,COM1 => WrSrc, A => A, B => B);
	G4 : entity work.PSR port map (Clk => Clk, DATAIN => PSREn, WE => N, RST => Reset, DATAOUT => PSREn);


end architecture;