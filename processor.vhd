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
		RegDest: in  std_logic;
		In_AluOp: in  std_logic_vector (2 downto 0);
		In_AluSrc: in  std_logic;
	
		In_NextInstrAddr : in std_logic_vector(31 downto 0);
		In_RegReadData1: in std_logic_vector(31 downto 0);
		In_RegReadData2: in std_logic_vector(31 downto 0);

		In_InstructOffset_Ext: in std_logic_vector(31 downto 0);
		Rt: in std_logic_vector(4 downto 0);
		Rd: in std_logic_vector(4 downto 0);

		Out_AddResult : out std_logic_vector(31 downto 0);
		Out_AluZero : out std_logic;
		Out_AluResult : out std_logic_vector(31 downto 0);
		Out_RegReadData2: out std_logic_vector(31 downto 0);
		Out_RegWriteAddr : out std_logic_vector(4 downto 0));
	end component;

	component etapa_MEM port(
		--IN: entrada
		Clk : in  std_logic;
		Reset : in  std_logic;

		--Control de Reg Segmentacion
		 --IN: WE
		In_RegWrite : in  std_logic;
		In_MemToReg : in  std_logic;
		 --IN: MEM
		In_Branch : in  std_logic;
		In_MemRead : in  std_logic;
		In_MemWrite : in  std_logic;

		In_AddResult : in std_logic_vector(31 downto 0);
		In_AluZero : in std_logic;
		In_AluResult : in std_logic_vector(31 downto 0);
		In_RegReadData2: in std_logic_vector(31 downto 0);
		In_RegWriteRegister : in std_logic_vector(4 downto 0);
	
		--Control de Reg Segmentacion
		 --OUT: WE
		Out_RegWrite : out  std_logic;
		Out_MemToReg : out  std_logic;
	
		Out_PCSrc : out std_logic;
		Out_MemReadData : out std_logic_vector(31 downto 0);
		Out_AluZero : out std_logic);
	end component;

	component etapa_WB port(
		--IN: entrada
		Clk : in  std_logic;
		Reset : in  std_logic;

		--Control de Reg Segmentacion
		 --IN: WB
		In_RegWrite : in  std_logic;
		In_MemToReg : in  std_logic;

		In_MemReadData : in std_logic_vector(31 downto 0);
		In_AluResult : in std_logic_vector(31 downto 0);
		In_RegWriteRegister : in std_logic_vector(4 downto 0);

		Out_RegWrite : out std_logic;
		Out_RegWriteRegister : out std_logic_vector(4 downto 0);
		Out_RegWriteData : out std_logic_vector(31 downto 0));
	end component;

	signal IF_PCSrc: 		std_logic;
	signal IF_PCNextAddr: 		std_logic_vector(31 downto 0);
	signal IF_NextInstrAddr: 	std_logic_vector(31 downto 0);

	signal ID_Instr: 		std_logic_vector(31 downto 0);
	signal ID_RegWe: 		std_logic_vector(31 downto 0);
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

	signal EX_RegDest:             	std_logic;
	signal EX_AluOp:               	std_logic_vector (2 downto 0);
	signal EX_AluSrc:              	std_logic;
	signal EX_NextInstrAddr:       	std_logic_vector(31 downto 0);
	signal EX_RegReadData1:        	std_logic_vector(31 downto 0);
	signal EX_RegReadData2:        	std_logic_vector(31 downto 0);
	signal EX_InstrOffsetExt:   	std_logic_vector(31 downto 0);
	signal EX_Rt:	           	std_logic_vector(4 downto 0);
	signal EX_Rd:	           	std_logic_vector(4 downto 0);
	signal EX_Branch:		std_logic;
	signal EX_MemRead:		std_logic;
	signal EX_MemWrite:		std_logic;
	signal EX_RegWrite:		std_logic;
	signal EX_MemToReg:		std_logic;

	signal MEM_Branch:		std_logic;
	signal MEM_MemRead:		std_logic;
	signal MEM_MemWrite:		std_logic;
	signal MEM_RegWrite:		std_logic;
	signal MEM_MemToReg:		std_logic;

	signal WB_RegWrite:		std_logic;
	signal WB_MemToReg:		std_logic;
	signal WB_RegWe:		std_logic;
	signal WB_RegDst:		std_logic_vector(4 downto 0);
	signal WB_WriteData:		std_logic_vector(31 downto 0);

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
	Clk => Clk,
	Reset => Reset,
	Instr => ID_Instr,
	RegWe => ID_RegWe,
	RegWriteAddr => ID_RegWriteAddr,
	RegWriteData => ID_RegWriteData,
	
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
	In_AluOp => EX_AluOp,
	In_AluSrc => EX_AluSrc,

	In_NextInstrAddr => EX_NextInstrAddr,
	In_RegReadData1 => EX_RegReadData1,
	In_RegReadData2 => EX_RegReadData2,

	In_InstructOffset_Ext => EX_InstructOffset_Ext,
	Rt => EX_Rt,
	Rd => EX_Rd,

	Out_AddResult => EX_AddResult,
	Out_AluZero => EX_AluZero,
	Out_AluResult => EX_AluResult,
	Out_RegReadData2 => EX_RegReadData2,
	Out_RegWriteAddr => EX_RegWriteAddr
    );

  mem_inst: etapa_MEM port map (
	Clk => Clk,
	Reset => Reset,

	In_RegWrite => MEM_RegWrite,
	In_MemToReg => MEM_MemToReg,
	In_Branch => MEM_Branch,
	In_MemRead => MEM_MemRead,
	In_MemWrite => MEM_MemWrite,

	In_AddResult => MEM_AddResult,
	In_AluZero => MEM_AluZero,
	In_AluResult => MEM_AluResult,
	In_RegReadData2 => MEM_RegReadData2,
	In_RegWriteRegister => MEM_RegWriteRegister,

	Out_RegWrite => MEM_RegWrite,
	Out_MemToReg => MEM_MemToReg,

	Out_PCSrc => MEM_PCSrc,
	Out_MemReadData => MEM_MemReadData,
	Out_AluZero => MEM_AluZero
    );

  wb_inst: etapa_WB port map (
	Clk => Clk,
	Reset => Reset,

	In_RegWrite => WB_RegWrite,
	In_MemToReg => WB_MemToReg,

	In_MemReadData => WB_MemReadData,
	In_AluResult => WB_AluResult,
	In_RegWriteRegister => WB_RegWriteRegister,

	Out_RegWrite => WB_RegWrite,
	Out_RegWriteRegister => WB_RegWriteRegister,
	Out_RegWriteData => WB_RegWriteData
  );

  process (Clk)
  begin
	if (Clk'event and Clk = '0') then
		ID_Instr 	<= I_DataOut;
		ID_RegWe 	<= WB_RegWe;
		ID_RegWriteAddr	<= WB_RegDst;
		ID_RegWriteData	<= WB_WriteData;

		ID_CurrentInstr         <= I_DataOut;
		ID_NextInstrAddr 	<= IF_NextInstrAddr;

		-- ID/EX
		EX_RegDest              <= ID_RegDest;
		EX_AluOp                <= ID_AluOp;
		EX_AluSrc               <= ID_AluSrc;
		EX_NextInstrAddr        <= ID_NextInstrAddr;
		EX_RegReadData1         <= ID_RegReadData1;
		EX_RegReadData2         <= ID_RegReadData2;
		EX_InstructOffset_Ext   <= ID_InstrOffsetExt;
		EX_InstructRT           <= ID_Rt;
		EX_InstructRD           <= ID_Rd;

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

		-- MEM/WB
		WB_RegWrite 		<= MEM_RegWrite;
		WB_MemToReg		<= MEM_MemToReg;
	end if;
end process;


end processor_arq;
