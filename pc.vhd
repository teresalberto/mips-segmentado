library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pc is
port(
	input:  in   std_logic_vector(31 downto 0);
	we:     in   std_logic;
	clk:    in   std_logic;
	rst:    in   std_logic;
	output: out  std_logic_vector(31 downto 0)
);
end pc;

architecture pc_arq of pc is
	signal temp: std_logic_vector(31 downto 0) := x"00000000";
begin 
  process(clk, rst)
  begin
	if (rst='1') then
		temp <= (others => '0');
	elsif (clk'event and clk = '1') then
		if (we = '1') then
			temp <= input;
		end if;	
	end if;	
  end process; 

  output <= temp;
end pc_arq;
