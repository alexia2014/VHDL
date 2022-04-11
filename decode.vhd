LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity DECODE is
  	port(
  		Instruction : in std_logic_vector(31 downto 0);
  		WrSrc : out std_logic;
  		MemWr : out std_logic;
  		PSREn : in std_logic_vector(31 downto 0);
  		ALUsrc : out std_logic;
  		ALUctr : out std_logic_vector(1 downto 0);
  		RegSel : out std_logic;
  		RegWr : out std_logic;
  		nPCsel : out std_logic;
  		PC : in std_logic_vector(31 downto 0);
  		Rm : inout std_logic_vector(3 downto 0);
  		Rn: in std_logic_vector(3 downto 0);
  		N : in std_logic;
  		Offset : in std_logic_vector(23 downto 0);
  		Reset : in std_logic;
  		Clk : in std_logic
    );
end entity;

architecture RTL of DECODE is
	type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT);
	signal instr_courante: enum_instruction;
	signal intru : std_logic_vector(31 downto 0);
	signal pc1 : std_logic_vector(31 downto 0);
	signal off: std_logic_vector(23 downto 0);
	signal rnoff: unsigned(3 downto 0);
begin
	process(Instruction, Clk)
	begin
		if Instruction(27) = '0' and Instruction(26) = '0' then
			if Instruction(25) = '1' and Instruction(24) = '0' then
			-- ADD immediate Rd:=Rn+Imm
				instr_courante <= ADDi;
			elsif Instruction(25) = '0' and Instruction(24) = '0' then
				-- ADD Rd:=Rn+Rm
				instr_courante <= ADDr;		
			elsif Instruction(25) = '1' and Instruction(24) = '1' and Instruction(23) = '1' then
				-- MOV Rd := Imm
				instr_courante <= MOV;
			elsif Instruction(25) = '1' and Instruction(24) = '1' and Instruction(23) = '0' then
				-- CMP Flag:=Rn-Imm
				instr_courante <= CMP;
			end if;
		elsif Instruction(26) = '1' then
			if Instruction(20) = '1' then
				-- LDR Rd:=Mem(Rn + Offset)
				instr_courante <= LDR;
			else
				-- STR Mem(Rn + Offset):=Rd
				instr_courante <= STR;
			end if;
		else
			if Instruction(30) = '1' then
				-- PC:=PC + offset
				instr_courante <= BAL;
			else
				-- Flag => PC:=PC+offset
				instr_courante <= BLT;
			end if;
		end if;
		intru <= Instruction;
		pc1 <= PC;
	end process;
	process(instr_courante)
	begin
		WrSrc <= 'Z';
  		MemWr <= 'Z';
  		ALUsrc <= 'Z';
  		ALUctr <= (others => 'Z');
  		RegSel <= 'Z';
  		RegWr <= 'Z';
  		nPCsel <= 'Z';
  		off <= Offset;
		--MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT
		if instr_courante = ADDi then
			-- ADD immediate Rd:=Rn+Imm
			RegWr <= '1';
			RegSel <= '1';
			ALUsrc <= '1';
			ALUctr <= "00";
			WrSrc <= '0';
			MemWr <= '0';
			nPCsel <= '0';
		elsif instr_courante = ADDr then
			-- ADD Rd:=Rn+Rm
			RegWr <= '1';
			RegSel <= '1';
			ALUsrc <= '0';
			ALUctr <= "00";
			WrSrc <= '0';
			nPCsel <= '0';
			MemWr <= '0';
		elsif instr_courante = MOV then
			-- MOV Rd := Imm
			RegWr <= '1';
			RegSel <= '1';
			ALUsrc <= '1';
			ALUctr <= "01";
			WrSrc <= '0';
			nPCsel <= '0';
			MemWr <= '0';
		elsif instr_courante = CMP then
			-- CMP Flag:=Rn-Imm
			RegWr <= '0';
			ALUsrc <= '1';
			ALUctr <= "10";
			WrSrc <= '0';
			nPCsel <= '0';
			MemWr <= '0';
		elsif instr_courante = LDR then
			-- LDR Rd:=Mem(Rn + Offset)
			RegWr <= '1';
			rnoff <= unsigned(Rn(3 downto 0)) + unsigned(off(3 downto 0));
			Rm <= std_logic_vector(rnoff);
			RegSel <= '0';
			ALUctr <= "11";
			MemWr <= '1';
			WrSrc <= '1';
			nPCsel <= '0';
			ALUsrc <= '0';
		elsif instr_courante = STR then
			-- STR Mem(Rn + Offset):=Rd
			RegWr <= '0';
			rnoff <= unsigned(Rn(3 downto 0)) + unsigned(off(3 downto 0));
			Rm <= std_logic_vector(rnoff);
			RegSel <= '0';
			ALUctr <= "11";
			MemWr <= '1';
			WrSrc <= '1';
			nPCsel <= '0';
			ALUsrc <= '0';
		elsif instr_courante = BAL then
			-- PC:=PC + offset
			nPCsel <= '1';
			RegWr <= '0';
			ALUsrc <= '0';
			ALUctr <= "00";
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
		else
			-- Flag => PC:=PC+offset
			nPCsel <= N;
			RegWr <= '0';
			ALUsrc <= '0';
			ALUctr <= "00";
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
		end if;
	end process;
	G1 : entity work.GESTION port map (Clk => Clk, PC => PC, nPCsel => N, offset => offset, Instruction  => intru);
end architecture;