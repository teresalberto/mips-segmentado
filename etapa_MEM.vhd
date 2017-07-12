
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_MEM is
port(
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
end etapa_MEM;

architecture etapa_MEM_arq of etapa_MEM is

begin
	--Salida del AND del Branch a PCSrc del MUX de etapa IF
	PCSrc <= Branch and AluZero;
end etapa_MEM_arq;
