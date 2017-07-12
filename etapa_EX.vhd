
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_EX is
port(
	RegDest: 		in std_logic;
	In_AluOp: 		in std_logic_vector (2 downto 0);
	In_AluSrc: 		in std_logic;

	In_NextInstrAddr: 	in std_logic_vector(31 downto 0);
	In_RegReadData1: 	in std_logic_vector(31 downto 0);
	In_RegReadData2: 	in std_logic_vector(31 downto 0);

	In_InstructOffset_Ext: 	in std_logic_vector(31 downto 0);
	Rt: 			in std_logic_vector(4 downto 0);
	Rd: 			in std_logic_vector(4 downto 0);

	Out_AddResult : 	out std_logic_vector(31 downto 0);
	Out_AluZero: 		out std_logic;
	Out_AluResult: 		out std_logic_vector(31 downto 0);
	Out_RegReadData2: 	out std_logic_vector(31 downto 0);
	Out_RegWriteAddr: 	out std_logic_vector(4 downto 0));
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
	
	signal mux_a_alu : std_logic_vector(31 downto 0);
begin

	emuxAlu: mux_addr Port map ( 
	        sel 	=> In_AluSrc,
		a 	=> In_RegReadData2,
          	b 	=> In_InstructOffset_Ext,l
	        output 	=> mux_a_alu
	);
	
	ealu: alu Port map ( 
		a 	=> In_RegReadData1,
          	b 	=> mux_a_alu,
	        control => In_AluOp,
	        zero 	=> Out_AluZero,
	        result 	=> Out_AluResult
	);

	emuxIntr: mux Port map ( 
	        sel 	=> RegDest,
		a 	=> Rt,
          	b 	=> Rd,
	        output 	=> Out_RegWriteAddr
	);
	
	-- Adder y shift 2 (no uso una ALU) combinacional
	Out_AddResult <= In_NextInstrAddr + (In_InstructOffset_Ext(29 downto 0) & "00");
end etapa_EX_arq;