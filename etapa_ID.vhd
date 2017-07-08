library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_ID is
port(
	Clk : in  std_logic;
	Instr : in std_logic_vector(31 downto 0);
	NextInstrAddr : in std_logic_vector(31 downto 0);
	RegWriteOffset : in std_logic_vector(4 downto 0);
	RegWriteData : in std_logic_vector(31 downto 0);
);
end etapa_ID;

architecture etapa_ID_arq of etapa_ID is
	-- component mux para rs | rt | rd

	component registers port(

	); end component;

	-- señales y aliases

begin
	-- procesos

end etapa_ID_arq;
