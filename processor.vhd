library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity processor is
port(
	Clk         : in  std_logic;
	Reset       : in  std_logic;
	-- Instruction memory
	I_Addr      : out std_logic_vector(31 downto 0);
	I_RdStb     : out std_logic;
	I_WrStb     : out std_logic;
	I_DataOut   : out std_logic_vector(31 downto 0);
	I_DataIn    : in  std_logic_vector(31 downto 0);
	-- Data memory
	D_Addr      : out std_logic_vector(31 downto 0);
	D_RdStb     : out std_logic;
	D_WrStb     : out std_logic;
	D_DataOut   : out std_logic_vector(31 downto 0);
	D_DataIn    : in  std_logic_vector(31 downto 0)
);
end processor;

architecture processor_arq of processor is 
	--Instrucciones tipo R
	alias op: std_logic_vector(5 downto 0) is I_DataOut(31 downto 26);
	alias rs: std_logic_vector(4 downto 0) is I_DataOut(25 downto 21);
	alias rt: std_logic_vector(4 downto 0) is I_DataOut(20 downto 16);
	alias rd: std_logic_vector(4 downto 0) is I_DataOut(15 downto 11);
	alias funct: std_logic_vector(5 downto 0) is I_DataOut(5 downto 0);
	-- Instrucciones tipo I
	alias offset: std_logic_vector(15 downto 0) is I_DataOut(15 downto 0);
  
begin 	
 
end processor_arq;
