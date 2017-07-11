
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_EX is
port(
	--IN: entrada
	Clk : in  std_logic;
	Reset : in  std_logic;

	--Control de Reg Segmentacion
	 --IN: WE
	In_RegWriteOut : in  std_logic;
	In_MemToReg : in  std_logic;
	 --IN: MEM
	In_Branch : in  std_logic;
	In_MemRead : in  std_logic;
	In_MemWrite : in  std_logic;
	 --IN: EX
	In_RegDest : in  std_logic;
	In_AluOp : in  std_logic_vector (2 downto 0);
	In_AluSrc : in  std_logic;

	In_NextInstrAddr : in std_logic_vector(31 downto 0);
	In_RegReadData1: in std_logic_vector(31 downto 0);
	In_RegReadData2: in std_logic_vector(31 downto 0);

	In_InstructOffset_Ext: in std_logic_vector(31 downto 0);
	In_InstructRT: in std_logic_vector(4 downto 0);
	In_InstructRD: in std_logic_vector(4 downto 0);

	--Control de Reg Segmentacion
	 --OUT: WE
	Out_RegWriteOut : out  std_logic;
	Out_MemToReg : out  std_logic;
	 --OUT: MEM
	Out_Branch : out  std_logic;
	Out_MemRead : out  std_logic;
	Out_MemWrite : out  std_logic;

	Out_AddResult : out std_logic_vector(31 downto 0);
	Out_AluZero : out std_logic;
	Out_AluResult : out std_logic_vector(31 downto 0);
	Out_RegReadData2: out std_logic_vector(31 downto 0);
	Out_RegWriteRegister : out std_logic_vector(4 downto 0)
	);

end etapa_EX;

architecture etapa_EX_arq of etapa_EX is
--DECLARACION DE COMPONENTES
	
	component mux port(
		sel : in  std_logic;
       		a : in  std_logic_vector (4 downto 0);
        	b : in  std_logic_vector (4 downto 0);
        	output : out  std_logic_vector (4 downto 0)
		); 
	end component;

	component mux_addr port(
		sel : in  std_logic;
       		a : in  std_logic_vector (31 downto 0);
        	b : in  std_logic_vector (31 downto 0);
        	output : out  std_logic_vector (31 downto 0)
		); 
	end component;

	component alu port(
		a : in std_logic_vector (31 downto 0);
          	b : in std_logic_vector (31 downto 0);
          	control : in std_logic_vector (2 downto 0);
          	zero : out std_logic;
          	result : out std_logic_vector (31 downto 0)
		); 
	end component;




--ALIAS

	
--DECLARACION DE SEÑALES
signal mux_a_alu : std_logic_vector (31 downto 0);
signal shift_left_a_alu : std_logic_vector (31 downto 0);
signal aux_nulo : std_logic;

begin

--INSTANCIACION DE COMPONENTES

	ealuAdder: alu Port map ( 
		a => In_NextInstrAddr,
		--Shift Left 2 manual
          	b => shift_left_a_alu,
		--siempre sumo
	        control => "010",
		--seteo cualquier valor a zero
	        zero => aux_nulo,
	        result => Out_AddResult
		);

	emuxAlu: mux_addr Port map ( 
	        sel => In_AluSrc,
		a => In_RegReadData2,
          	b => In_InstructOffset_Ext,
		--señal
	        output => mux_a_alu
		);
	
	ealu: alu Port map ( 
		a => In_RegReadData1,
          	b => mux_a_alu,
	        control => In_AluOp,
	        zero => Out_AluZero,
	        result => Out_AluResult
		);

	emuxIntr: mux Port map ( 
	        sel => In_RegDest,
		a => In_InstructRT,
          	b => In_InstructRD,
	        output => Out_RegWriteRegister
		);

--SEÑALES
	--asigno a señal el offset con Shiflt Letf	
	shift_left_a_alu <= In_InstructOffset_Ext(29 downto 0) & "00";
	--Seteo Zero de Adder en 0. Puede ser cualquier valor, no uso el Flag.
	aux_nulo <= '0';

end etapa_EX_arq;