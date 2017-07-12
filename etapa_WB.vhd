
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_WB is
port(
	MemToReg: 	in  std_logic;
	MemReadData: 	in std_logic_vector(31 downto 0);
	AluResult: 	in std_logic_vector(31 downto 0);

	RegWriteData: 	out std_logic_vector(31 downto 0)
);
end etapa_WB;

architecture etapa_WB_arq of etapa_WB is
  component mux_addr port(
	sel: 	in  std_logic;
	a: 	in  std_logic_vector (31 downto 0);
       	b: 	in  std_logic_vector (31 downto 0);
	output: out std_logic_vector (31 downto 0)
  ); 
  end component;
begin
  emux: mux_addr Port map ( 
	sel 	=> MemToReg,
	a 	=> MemReadData,
	b 	=> AluResult,
        output 	=> RegWriteData
  );
end etapa_WB_arq;