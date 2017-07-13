library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity etapa_IF is
port(
	Clk: 		in std_logic;
	Reset: 		in std_logic;
	PCSrc: 		in std_logic;
	PCNextAddr: 	in std_logic_vector(31 downto 0);

	CurrInstrAddr: out std_logic_vector(31 downto 0);
	NextInstrAddr: out std_logic_vector(31 downto 0)
);
end etapa_IF;

architecture etapa_IF_arq of etapa_IF is
	component mux_addr port(
		sel: 	in  std_logic;
       		a:   	in  std_logic_vector(31 downto 0);
        	b:   	in  std_logic_vector(31 downto 0);
        	output: out std_logic_vector(31 downto 0)
	); 
	end component;

	component pc port(
		clk:    in 	std_logic;
		rst:    in 	std_logic;
		input:  in 	std_logic_vector(31 downto 0);
		we:     in 	std_logic;
		output: out 	std_logic_vector(31 downto 0)
	); 
	end component;
 
	signal NextInstrAddrSignal: std_logic_vector(31 downto 0);
	signal CurrInstrAddrSignal: std_logic_vector(31 downto 0);
	signal PcIn: 		    std_logic_vector(31 downto 0);

begin
	pc_in_mux: mux_addr Port map ( 
	        sel    => PCSrc,
		a      => NextInstrAddrSignal,
          	b      => PCNextAddr,
	        output => PcIn
	);

	pc_inst: pc Port map (
		we     => '1',
		clk    => Clk,
		rst    => Reset,
		output => CurrInstrAddrSignal,
		input  => PcIn
	);

	NextInstrAddrSignal <= CurrInstrAddrSignal + 4;

	CurrInstrAddr <= CurrInstrAddrSignal;
	NextInstrAddr <= NextInstrAddrSignal;
end etapa_IF_arq;