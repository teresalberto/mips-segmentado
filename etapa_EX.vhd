
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_EX is
port(
	RegDest: 	in std_logic;
	AluOp: 		in std_logic_vector (2 downto 0);
	AluSrc: 	in std_logic;

	NextInstrAddr: 	in std_logic_vector(31 downto 0);
	RegReadData1:	in std_logic_vector(31 downto 0);
	RegReadData2: 	in std_logic_vector(31 downto 0);

	InstrOffsetExt: in std_logic_vector(31 downto 0);
	Rt: 		in std_logic_vector(4 downto 0);
	Rd: 		in std_logic_vector(4 downto 0);

	AddResult: 	out std_logic_vector(31 downto 0);
	AluZero: 	out std_logic;
	AluResult: 	out std_logic_vector(31 downto 0);
	RegWriteAddr: 	out std_logic_vector(4 downto 0));
end etapa_EX;

architecture etapa_EX_arq of etapa_EX is

	component mux port(
		sel: 	in std_logic;
       		a: 	in std_logic_vector (4 downto 0);
        	b: 	in std_logic_vector (4 downto 0);
        	output: out std_logic_vector (4 downto 0)
	); 
	end component;

	component mux_addr port(
		sel: 	in std_logic;
       		a: 	in std_logic_vector (31 downto 0);
        	b: 	in std_logic_vector (31 downto 0);
        	output: out  std_logic_vector (31 downto 0)); 
	end component;

	component alu port(
		a: 		in std_logic_vector (31 downto 0);
          	b: 		in std_logic_vector (31 downto 0);
          	control: 	in std_logic_vector (2 downto 0);
          	zero: 		out std_logic;
          	result: 	out std_logic_vector (31 downto 0)); 
	end component;
	
	signal MuxAddrOut : std_logic_vector(31 downto 0);
begin

	emuxAlu: mux_addr Port map ( 
	        sel 	=> AluSrc,
		a 	=> RegReadData2,
          	b 	=> InstrOffsetExt,
	        output 	=> MuxAddrOut
	);
	
	ealu: alu Port map ( 
		a 	=> RegReadData1,
          	b 	=> MuxAddrOut,
	        control => AluOp,
	        zero 	=> AluZero,
	        result 	=> AluResult
	);

	emuxIntr: mux Port map ( 
	        sel 	=> RegDest,
		a 	=> Rt,
          	b 	=> Rd,
	        output 	=> RegWriteAddr
	);
	
	-- Adder y shift 2 (no uso una ALU) combinacional
	AddResult <= NextInstrAddr + (InstrOffsetExt(29 downto 0) & "00");
end etapa_EX_arq;