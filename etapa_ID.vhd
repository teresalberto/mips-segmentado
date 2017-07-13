library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_ID is
port(
	Clk: 		in std_logic;
	Reset: 		in std_logic;
	Instr: 		in std_logic_vector(31 downto 0);
	RegWe: 		in std_logic;
	RegWriteAddr: 	in std_logic_vector(4 downto 0);
	RegWriteData: 	in std_logic_vector(31 downto 0);
	
	-- Salidas de Control
	---- MEM
	Branch:   out  std_logic;
	MemRead:  out  std_logic;
	MemWrite: out  std_logic;
	---- EX
	RegDest:  out  std_logic;
	AluOp:    out  std_logic_vector(2 downto 0);
	AluSrc:   out  std_logic;
	---- WB
	RegWrite: out std_logic;
	MemToReg: out std_logic;

	-- Salida de lecturas registro
	RegReadData1: out std_logic_vector(31 downto 0);
	RegReadData2: out std_logic_vector(31 downto 0);
	
	-- Salida de instrucción x bits
	InstrOffsetExt: out std_logic_vector(31 downto 0);
	Rt: 		out std_logic_vector(4 downto 0);
	Rd: 		out std_logic_vector(4 downto 0));
end etapa_ID;

architecture etapa_ID_arq of etapa_ID is

	component registers port(
		clk: 		in std_logic;
		reset: 		in std_logic;
	        wr: 		in std_logic;
	        reg1_dr: 	in std_logic_vector(4 downto 0);
	        reg2_dr: 	in std_logic_vector(4 downto 0);
	        reg_wr: 	in std_logic_vector(4 downto 0);
	        data_wr: 	in std_logic_vector(31 downto 0);

	        data1_rd: 	out std_logic_vector(31 downto 0);
	        data2_rd: 	out std_logic_vector(31 downto 0)
	); 
	end component;
	
	component control port(
		Input: in std_logic_vector(31 downto 0);

		Branch:   out std_logic;
		MemRead:  out std_logic;
		MemWrite: out std_logic;
		RegDest:  out std_logic;
		AluOp:    out std_logic_vector(2 downto 0);
		AluSrc:   out std_logic;
		RegWrite: out std_logic;
		MemToReg: out std_logic
	); 
	end component;


	component sign_ext port(
	        Input:  in  std_logic_vector (15 downto 0);
	        Output: out std_logic_vector (31 downto 0)
	); 	
	end component;
	
	--Instrucciones tipo R
	alias Op: std_logic_vector(5 downto 0) is Instr(31 downto 26);
	alias Rs: std_logic_vector(4 downto 0) is Instr(25 downto 21);
	alias AliasRt: std_logic_vector(4 downto 0) is Instr(20 downto 16);
	alias AliasRd: std_logic_vector(4 downto 0) is Instr(15 downto 11);
	alias Funct: std_logic_vector(5 downto 0) is Instr(5 downto 0);
	-- Instrucciones tipo I
	alias Offset: std_logic_vector(15 downto 0) is Instr(15 downto 0);
begin
	eregisters: registers port map ( 
		clk 		=> Clk,
          	reset 		=> Reset,
	        wr 		=> RegWe,
	        reg1_dr 	=> Rs,
	        reg2_dr 	=> AliasRt,
	        reg_wr 		=> RegWriteAddr,
	        data_wr 	=> RegWriteData,
	        data1_rd 	=> RegReadData1,
	        data2_rd 	=> RegReadData2	
	);

	econtrol: control port map (
		Input 		=> Instr,

		--OUT: WE
		RegWrite 	=> RegWrite,
		MemToReg 	=> MemToReg,
		--OUT: MEM
		Branch 		=> Branch,
		MemRead 	=> MemRead,
		MemWrite 	=> MemWrite,
		--OUT: EX
		RegDest 	=> RegDest,
		AluOp 		=> AluOp,
		AluSrc 		=> AluSrc
	);

	esign_ext: sign_ext port map (
		Input  => Offset,
		Output => InstrOffsetExt
	);

	--Asigno Alias de instrucción a salida.
	Rt <= AliasRt;
	Rd <= AliasRd;

end etapa_ID_arq;
