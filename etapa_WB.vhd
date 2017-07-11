
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_WB is
port(
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
	Out_RegWriteData : out std_logic_vector(31 downto 0)

	);

end etapa_WB;

architecture etapa_WB_arq of etapa_WB is
--DECLARACION DE COMPONENTES

	component mux_addr port(
		sel : in  std_logic;
       		a : in  std_logic_vector (31 downto 0);
        	b : in  std_logic_vector (31 downto 0);
        	output : out  std_logic_vector (31 downto 0)
		); 
	end component;




--ALIAS

	
--DECLARACION DE SEÑALES

begin

--INSTANCIACION DE COMPONENTES

	emux: mux_addr Port map ( 
	        sel => In_MemToReg,
		a => In_MemReadData,
          	b => In_AluResult,
		--señal
	        output => Out_RegWriteData
		);

	--Continua circulando habilitacion de escritura de Reg en ID.
	Out_RegWrite <= In_RegWrite;

	--Continua circulando Reg a escribir en ID.
	Out_RegWriteRegister <= In_RegWriteRegister;

--SEÑALES
	

end etapa_WB_arq;