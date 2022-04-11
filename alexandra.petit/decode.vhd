LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity DECODE is
  	port(
  		Instruction : inout std_logic_vector(31 downto 0);
  		WrSrc : out std_logic;
  		MemWr : out std_logic;
  		ALUsrc : out std_logic;
  		ALUctr : out std_logic_vector(1 downto 0);
  		RegSel : out std_logic;
  		RegWr : out std_logic;
  		nPCsel : inout std_logic;
  		PSREn : inout std_logic_vector(31 downto 0);
  		PC : inout std_logic_vector(31 downto 0);
  		Rm : out std_logic_vector(3 downto 0);
  		Rn: out std_logic_vector(3 downto 0);
  		Rd: out std_logic_vector(3 downto 0);
  		Imm : out std_logic_vector(7 downto 0);
  		Offset : inout std_logic_vector(23 downto 0);
  		Reset : in std_logic;
  		Clk : in std_logic
    );
end entity;

architecture RTL of DECODE is
	type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT);
	signal instr_courante: enum_instruction;
	signal rnoff: unsigned(7 downto 0);
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
  		Rm <= "0000";
  		Rd <= "0000";
  		Rn <= "0000";
  		offset <= (others => '0');
  		Imm <= (others => '0');
  		PSREn <= (others => '0');
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
			Rn <= Instruction(19 downto 16);
			Rd <= Instruction(15 downto 12);
			Imm <= Instruction(7 downto 0);
		elsif instr_courante = ADDr then
			-- ADD Rd:=Rn+Rm
			RegWr <= '1';
			RegSel <= '1';
			ALUsrc <= '0';
			ALUctr <= "00";
			WrSrc <= '0';
			nPCsel <= '0';
			MemWr <= '0';
			Rn <= Instruction(19 downto 16);
			Rd <= Instruction(15 downto 12);
			Rm <= Instruction(3 downto 0);
		elsif instr_courante = MOV then
			-- MOV Rd := Imm
			RegWr <= '1';
			RegSel <= '1';
			ALUsrc <= '1';
			ALUctr <= "01";
			WrSrc <= '0';
			nPCsel <= '0';
			MemWr <= '0';
			Rd <= Instruction(15 downto 12);
			Imm <= Instruction(7 downto 0);
		elsif instr_courante = CMP then
			-- CMP Flag:=Rn-Imm
			RegWr <= '0';
			ALUsrc <= '1';
			ALUctr <= "10";
			WrSrc <= '0';
			nPCsel <= '0';
			MemWr <= '0';
			Rn <= Instruction(19 downto 16);
			Imm <= Instruction(7 downto 0);
		elsif instr_courante = LDR then
			-- LDR Rd:=Mem(Rn + Offset)
			RegWr <= '1';
			Rn <= Instruction(19 downto 16);
			Imm <= Instruction(7 downto 0);
			RegSel <= '1';
			ALUctr <= "00";
			MemWr <= '1';
			WrSrc <= '1';
			nPCsel <= '0';
			ALUsrc <= '1';
			Rd <= Instruction(15 downto 12);
		elsif instr_courante = STR then
			-- STR Mem(Rn + Offset):=Rd
			RegWr <= '0';
			Rn <= Instruction(19 downto 16);
			Imm <= Instruction(7 downto 0);
			RegSel <= '1';
			ALUctr <= "00";
			MemWr <= '1';
			WrSrc <= '1';
			nPCsel <= '0';
			ALUsrc <= '1';
			Rd <= Instruction(15 downto 12);
		elsif instr_courante = BAL then
			-- PC:=PC + offset
			nPCsel <= '1';
			RegWr <= '0';
			ALUsrc <= '0';
			ALUctr <= "00";
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
			offset <= Instruction(23 downto 0);
		else
			-- Flag => PC:=PC+offset
			if PSREn /= x"00000000" then
				nPCsel <= '1';
				RegWr <= '0';
				ALUsrc <= '0';
				ALUctr <= "00";
				MemWr <= '0';
				WrSrc <= '0';
				RegSel <= '0';
				offset <= Instruction(23 downto 0);
			end if;
		end if;
	end process;
	G1 : entity work.GESTION port map (Clk => Clk, PC => PC, nPCsel => nPCsel, offset => offset, Instruction  => Instruction, Reset => Reset);
end architecture;