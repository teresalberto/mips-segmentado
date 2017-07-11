library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_ID is
port(
	--IN: entrada
	Clk : in  std_logic;
	Reset : in  std_logic;
	Instr : in std_logic_vector(31 downto 0);
	In_NextInstrAddr : in std_logic_vector(31 downto 0);
	RegWriteRegister : in std_logic_vector(4 downto 0);
	RegWriteData : in std_logic_vector(31 downto 0);
	
	--Control de componentes
	RegWriteIn : in std_logic;
	
	--Control de Reg Segmentacion
	 --OUT: WE
	RegWriteOut : out  std_logic;
	MemToReg : out  std_logic;
	 --OUT: MEM
	Branch : out  std_logic;
	MemRead : out  std_logic;
	MemWrite : out  std_logic;
	 --OUT: EX
	RegDest : out  std_logic;
	AluOp : out  std_logic_vector (2 downto 0);
	AluSrc : out  std_logic;
	 --OUT: salida
	Out_NextInstrAddr : out std_logic_vector(31 downto 0);
	RegReadData1: out std_logic_vector(31 downto 0);
	RegReadData2: out std_logic_vector(31 downto 0);
	
	--OUT: Instruccion x bits
	Out_InstructOffset_Ext: out std_logic_vector(31 downto 0);
	Out_InstructRT: out std_logic_vector(4 downto 0);
	Out_InstructRD: out std_logic_vector(4 downto 0)
	);
end etapa_ID;

architecture etapa_ID_arq of etapa_ID is

--DECLARACION DE COMPONENTES

	component registers port(
		clk : in std_logic;
          	reset : in std_logic;
	        wr : in std_logic;
	        reg1_dr : in std_logic_vector (4 downto 0);
	        reg2_dr : in std_logic_vector (4 downto 0);
	        reg_wr : in std_logic_vector (4 downto 0);
	        data_wr : in std_logic_vector (31 downto 0);
	        data1_rd : out std_logic_vector (31 downto 0);
	        data2_rd : out std_logic_vector (31 downto 0)
		); 
	end component;
	
	component control port(
		--IN: toda la instruccion
		Input : in  std_logic_vector (31 downto 0);
		--OUT: WE
		RegWrite : out  std_logic;
		MemToReg : out  std_logic;
		--OUT: MEM
		Branch : out  std_logic;
		MemRead : out  std_logic;
		MemWrite : out  std_logic;
		--OUT: EX
		RegDest : out  std_logic;
		AluOp : out  std_logic_vector (2 downto 0);
		AluSrc : out  std_logic
		); 
	end component;


	component sign_ext port(
	        Input : in  std_logic_vector (15 downto 0);
	        Output : out  std_logic_vector (31 downto 0)
		); 	
	end component;
	
--ALIAS
	--Instrucciones tipo R
	alias Op: std_logic_vector(5 downto 0) is Instr(31 downto 26);
	alias Rs: std_logic_vector(4 downto 0) is Instr(25 downto 21);
	alias Rt: std_logic_vector(4 downto 0) is Instr(20 downto 16);
	alias Rd: std_logic_vector(4 downto 0) is Instr(15 downto 11);
	alias Funct: std_logic_vector(5 downto 0) is Instr(5 downto 0);
	-- Instrucciones tipo I
	alias Offset: std_logic_vector(15 downto 0) is Instr(15 downto 0);
	
--DECLARACION DE SEÑALES



begin

--INSTANCIACION DE COMPONENTES

	eregisters: registers Port map ( 
		clk => Clk,
          	reset => Reset,
	        wr => RegWriteIn,
	        reg1_dr => Rs,
	        reg2_dr => Rt,
	        reg_wr => RegWriteRegister,
	        data_wr => RegWriteData,
	        data1_rd => RegReadData1,
	        data2_rd => RegReadData2	
		);

	econtrol: control Port map ( 

		--IN: toda la instruccion
		input => Instr,
		--OUT: WE
		RegWrite => RegWriteOut,
		MemToReg => MemToReg,
		--OUT: MEM
		Branch => Branch,
		MemRead => MemRead,
		MemWrite => MemWrite,
		--OUT: EX
		RegDest => RegDest,
		AluOp =>  AluOp,
		AluSrc => AluSrc
		);

	esign_ext: sign_ext Port map (
		input => offset,
		output => Out_InstructOffset_Ext
		);

--SEÑALES
	--Asigno Alias de instrucción a salida.
	Out_InstructRT <= Rt;
	Out_InstructRD <= Rd;


--PROCESOS

end etapa_ID_arq;
