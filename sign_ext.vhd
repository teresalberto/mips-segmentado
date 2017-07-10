library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sign_ext is
    Port ( 
        Input : in  std_logic_vector (15 downto 0);
        Output : out  std_logic_vector (31 downto 0));
end sign_ext;

architecture sign_ext_arq of sign_ext is
begin

	Output(15 downto 0) <= Input;
  	Output(31 downto 16) <= (others=>Input(15));

end sign_ext_arq;