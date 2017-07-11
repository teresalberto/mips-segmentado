
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_MEM is
port(
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
	Out_AluZero : out std_logic

	);

end etapa_MEM;

architecture etapa_MEM_arq of etapa_MEM is
--DECLARACION DE COMPONENTES





--ALIAS

	
--DECLARACION DE SEÑALES

begin

--INSTANCIACION DE COMPONENTES



	--Salida del AND del Branch a PCSrc del MUX de etapa IF
	Out_PCSrc <= In_Branch and In_AluZero;

	--Continua circulando informcion de escritura de Reg.
	Out_RegWrite <= In_RegWrite;

--SEÑALES
	

end etapa_MEM_arq;
