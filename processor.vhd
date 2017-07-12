library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity processor is
port(
	Clk         : in  std_logic;
	Reset       : in  std_logic;
	-- Instruction memory
	I_Addr      : out std_logic_vector(31 downto 0);
	I_RdStb     : out std_logic;
	I_WrStb     : out std_logic;
	I_DataOut   : out std_logic_vector(31 downto 0);
	I_DataIn    : in  std_logic_vector(31 downto 0);
	-- Data memory
	D_Addr      : out std_logic_vector(31 downto 0);
	D_RdStb     : out std_logic;
	D_WrStb     : out std_logic;
	D_DataOut   : out std_logic_vector(31 downto 0);
	D_DataIn    : in  std_logic_vector(31 downto 0));
end processor;

architecture processor_arq of processor is 
	component etapa_IF port(
		Clk: 		in std_logic;
		Reset: 		in std_logic;
		PCSrc: 		in std_logic;
		PCNextAddr: 	in std_logic_vector(31 downto 0);

		CurrInstrAddr: out std_logic_vector(31 downto 0);
		NextInstrAddr: out std_logic_vector(31 downto 0));
	end component;

	component etapa_ID port(
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
	end component;

	component etapa_EX port(
		RegDest: 	in std_logic;
		AluOp: 		in std_logic_vector (2 downto 0);
		AluSrc: 	in std_logic;

		NextInstrAddr: 	in std_logic_vector(31 downto 0);
		RegReadData1:	in std_logic_vector(31 downto 0);
		RegReadData2: 	in std_logic_vector(31 downto 0);

		InstrOffsetExt: in std_logic_vector(31 downto 0);
		Rt: 		in std_logic_vector(4 downto 0);
		Rd: 		in std_logic_vector(4 downto 0);

		AddResult : 	out std_logic_vector(31 downto 0);
		AluZero: 	out std_logic;
		AluResult: 	out std_logic_vector(31 downto 0);
		RegWriteAddr: 	out std_logic_vector(4 downto 0));
	end component;

	component etapa_MEM port(
		--Control de Reg Segmentacion
		Branch: 	in std_logic;
		MemRead: 	in std_logic;
		MemWrite: 	in std_logic;
	
		AddResult: 	in std_logic_vector(31 downto 0);
		AluZero: 	in std_logic;
		AluResult: 	in std_logic_vector(31 downto 0);
		RegReadData2: 	in std_logic_vector(31 downto 0);
		RegWriteAddr: 	in std_logic_vector(4 downto 0);

		PCSrc: 		out std_logic;
		MemReadData: 	out std_logic_vector(31 downto 0));
	end component;

	component etapa_WB port(
		MemToReg: 	in  std_logic;
		MemReadData: 	in std_logic_vector(31 downto 0);
		AluResult: 	in std_logic_vector(31 downto 0);
		RegWriteData: 	out std_logic_vector(31 downto 0));
	end component;

	signal IF_PCSrc: 		std_logic;
	signal IF_PCNextAddr: 		std_logic_vector(31 downto 0);
	signal IF_NextInstrAddr: 	std_logic_vector(31 downto 0);

	signal ID_Instr: 		std_logic_vector(31 downto 0);
	signal ID_NextInstrAddr: 	std_logic_vector(31 downto 0);
	signal ID_RegWriteAddr:	 	std_logic_vector(4 downto 0);
	signal ID_RegWriteData:		std_logic_vector(31 downto 0);
	signal ID_Branch: 		std_logic;
	signal ID_MemRead:		std_logic;
	signal ID_MemWrite:		std_logic;
	signal ID_RegDest:		std_logic;
	signal ID_AluOp:		std_logic_vector(2 downto 0);
	signal ID_AluSrc:		std_logic;
	signal ID_RegWrite: 		std_logic;
	signal ID_MemToReg: 		std_logic;
	signal ID_RegReadData1:		std_logic_vector(31 downto 0);
	signal ID_RegReadData2:		std_logic_vector(31 downto 0);
	signal ID_InstrOffsetExt:	std_logic_vector(31 downto 0);
	signal ID_Rt:			std_logic_vector(4 downto 0);
	signal ID_Rd: 			std_logic_vector(4 downto 0);

	signal EX_RegDest: 		std_logic;
	signal EX_AluOp: 		std_logic_vector (2 downto 0);
	signal EX_AluSrc: 		std_logic;
	signal EX_NextInstrAddr: 	std_logic_vector(31 downto 0);
	signal EX_RegReadData1:		std_logic_vector(31 downto 0);
	signal EX_RegReadData2: 	std_logic_vector(31 downto 0);
	signal EX_InstrOffsetExt: 	std_logic_vector(31 downto 0);
	signal EX_Rt: 			std_logic_vector(4 downto 0);
	signal EX_Rd: 			std_logic_vector(4 downto 0);
	signal EX_AddResult: 		std_logic_vector(31 downto 0);
	signal EX_AluZero: 		std_logic;
	signal EX_AluResult: 		std_logic_vector(31 downto 0);
	signal EX_RegWriteAddr: 	std_logic_vector(4 downto 0);

	signal MEM_Branch:		std_logic;
	signal MEM_MemRead:		std_logic;
	signal MEM_MemWrite:		std_logic;
	signal MEM_RegWrite:		std_logic;
	signal MEM_MemToReg:		std_logic;
	signal MEM_AddResult: 		std_logic_vector(31 downto 0);
	signal MEM_AluZero: 		std_logic;
	signal MEM_AluResult: 		std_logic_vector(31 downto 0);
	signal MEM_RegWriteAddr: 	std_logic_vector(4 downto 0);

	signal MEM_PCSrc: 		std_logic;
	signal MEM_MemReadData: 	std_logic_vector(31 downto 0);

	signal WB_MemToReg:		std_logic;
	signal WB_MemReadData: 		std_logic_vector(31 downto 0);
	signal WB_AluResult: 		std_logic_vector(31 downto 0);
	signal WB_RegWriteData:		std_logic_vector(31 downto 0);

	-- Señales "virtuales" (registro solamente)
	signal EX_Branch:		std_logic;
	signal EX_MemRead:		std_logic;
	signal EX_MemWrite:		std_logic;
	signal EX_RegWrite:		std_logic;
	signal EX_MemToReg:		std_logic;
	signal MEM_RegReadData2: 	std_logic_vector(31 downto 0);
	signal WB_RegWe:		std_logic;
	signal WB_RegWrite:		std_logic;
	signal WB_RegWriteAddr: 	std_logic_vector(4 downto 0);
begin 	
  if_inst: etapa_IF port map (
	Clk => Clk,
	Reset => Reset,
	PCSrc => IF_PCSrc,
	PCNextAddr => IF_PCNextAddr,
	CurrInstrAddr => I_Addr,
	NextInstrAddr => IF_NextInstrAddr
  );

  id_inst: etapa_ID port map (
	Clk 		=> Clk,
	Reset 		=> Reset,
	Instr 		=> ID_Instr,
	RegWe 		=> WB_RegWrite,
	RegWriteAddr 	=> WB_RegWriteAddr,
	RegWriteData 	=> WB_RegWriteData,
	
	-- Salidas de Control
	---- MEM
	Branch => ID_Branch,
	MemRead => ID_MemRead,
	MemWrite => ID_MemWrite,
	---- EX
	RegDest => ID_RegDest,
	AluOp => ID_AluOp,
	AluSrc => ID_AluSrc,
	---- WB
	RegWrite => ID_RegWrite,
	MemToReg => ID_MemToReg,

	-- Salida de lecturas registro
	RegReadData1 => ID_RegReadData1,
	RegReadData2 => ID_RegReadData2,
	
	-- Salida de instrucción x bits
	InstrOffsetExt => ID_InstrOffsetExt,
	Rt => ID_Rt,
	Rd => ID_Rd
  );

  ex_inst: etapa_EX port map (
	RegDest => EX_RegDest,
	AluOp => EX_AluOp,
	AluSrc => EX_AluSrc,

	NextInstrAddr => EX_NextInstrAddr,
	RegReadData1 => EX_RegReadData1,
	RegReadData2 => EX_RegReadData2,

	InstrOffsetExt => EX_InstrOffsetExt,
	Rt => EX_Rt,
	Rd => EX_Rd,

	AddResult => EX_AddResult,
	AluZero => EX_AluZero,
	AluResult => EX_AluResult,
	RegWriteAddr => EX_RegWriteAddr
  );

  mem_inst: etapa_MEM port map (
	Branch => MEM_Branch,
	MemRead => MEM_MemRead,
	MemWrite => MEM_MemWrite,

	AddResult => MEM_AddResult,
	AluZero => MEM_AluZero,
	AluResult => MEM_AluResult,
	RegReadData2 => MEM_RegReadData2,
	RegWriteAddr => MEM_RegWriteAddr,

	PCSrc => MEM_PCSrc,
	MemReadData => MEM_MemReadData
    );

  wb_inst: etapa_WB port map (
	MemToReg => WB_MemToReg,
	MemReadData => WB_MemReadData,
	AluResult => WB_AluResult,
	RegWriteData => WB_RegWriteData
  );

  process (Clk)
  begin
	if (Clk'event and Clk = '0') then
		IF_PCNextAddr 		<= MEM_AddResult;

		ID_Instr 		<= I_DataIn;
		ID_NextInstrAddr 	<= IF_NextInstrAddr;

		-- ID/EX
		EX_RegDest              <= ID_RegDest;
		EX_AluOp                <= ID_AluOp;
		EX_AluSrc               <= ID_AluSrc;
		EX_NextInstrAddr        <= ID_NextInstrAddr;
		EX_RegReadData1         <= ID_RegReadData1;
		EX_RegReadData2         <= ID_RegReadData2;
		EX_InstrOffsetExt 	<= ID_InstrOffsetExt;
		EX_Rt           	<= ID_Rt;
		EX_Rd           	<= ID_Rd;

		EX_Branch 		<= ID_Branch;
		EX_MemRead 		<= ID_MemRead;
		EX_MemWrite 		<= ID_MemWrite;
		EX_RegWrite 		<= ID_RegWrite;
		EX_MemToReg		<= ID_MemToReg;

		-- EX/MEM
		MEM_Branch 		<= EX_Branch;
		MEM_MemRead 		<= EX_MemRead;
		MEM_MemWrite 		<= EX_MemWrite;
		MEM_RegWrite 		<= EX_RegWrite;
		MEM_MemToReg		<= EX_MemToReg;
		MEM_RegReadData2        <= EX_RegReadData2;
		MEM_AddResult		<= EX_AddResult;

		-- MEM/WB
		WB_RegWrite 		<= MEM_RegWrite;
		WB_MemToReg		<= MEM_MemToReg;
		WB_RegWriteAddr 	<= MEM_RegWriteAddr;
	end if;
end process;

end processor_arq;
