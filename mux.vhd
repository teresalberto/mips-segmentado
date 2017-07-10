library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux is
    Port ( 
	sel : in  std_logic;
        a : in  std_logic_vector (5 downto 0);
        b : in  std_logic_vector (5 downto 0);
        output : out  std_logic_vector (5 downto 0));
end mux;

architecture mux_arq of mux is
begin

process(sel,a,b)
begin
	case sel is
		when '0' =>
		output <= a;
		when '1' =>
		output <= b;
		when others =>	output <= b;
	end case;
end process;
end mux_arq;
