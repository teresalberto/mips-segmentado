library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_addr is
    Port ( 
	sel : in  std_logic;
        a : in  std_logic_vector (31 downto 0);
        b : in  std_logic_vector (31 downto 0);
        output : out  std_logic_vector (31 downto 0));
end mux_addr;

architecture mux_addr_arq of mux_addr is
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
end mux_addr_arq;
