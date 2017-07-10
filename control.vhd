--No le pude hacer andar los maits para que espere en cada etapa. 
--No son compatibles waits y process

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
    Port ( 
	--IN: toda la instruccion
	Input : in  std_logic_vector (32 downto 0);
	--OUT: WE
	RegWrite : out  std_logic;
	MemToReg : out  std_logic;
	--OUT: MEM
	Branch : out  std_logic;
	MemRead : out  std_logic;
	MemWrite : out  std_logic;
	--OUT: EX
	RegDest : out  std_logic;
	AluOp : out  std_logic_vector (2 downto 0);
	AluSrc : out  std_logic
	);
end control;

architecture control_arq of control is
	alias Op: std_logic_vector(5 downto 0) is input(31 downto 26);
	alias Funct: std_logic_vector(5 downto 0) is input(5 downto 0);

begin 

  process (Op,Funct)
  begin
	case Op is
	--Instr Tipo R
        when "000000" =>
		case Funct is
		--op ADD
		when "100000" =>
			--OUT: WE
			--wait for 30 ns; --se considera un ciclo de 10ns
			RegWrite  <= '1';
			MemToReg  <= '0';

			--OUT: MEM
			--wait for 20 ns;
			Branch  <= '0';
			MemRead  <= '0';
			MemWrite  <= '0';

			--OUT: EX
			--wait for 10 ns;
			RegDest  <= '1';
			AluOp  <= "010";
			AluSrc  <= '0';
		--op SUB
		when "100010" =>
			--OUT: WE
			--wait for 30 ns;

			RegWrite  <= '1';
			MemToReg  <= '0';

			--OUT: MEM
			--wait for 20 ns;
			Branch  <= '0';
			MemRead  <= '0';
			MemWrite  <= '0';

			--OUT: EX
			--wait for 10 ns;
			RegDest  <= '1';
			AluOp  <= "110";
			AluSrc  <= '0';
		
		--op AND
		when "100100" =>
			--OUT: WE
			--wait for 30 ns;
			RegWrite  <= '1';
			MemToReg  <= '0';

			--OUT: MEM
			--wait for 20 ns;
			Branch  <= '0';
			MemRead  <= '0';
			MemWrite  <= '0';

			--OUT: EX
			--wait for 10 ns;
			RegDest  <= '1';
			AluOp  <= "000";
			AluSrc  <= '0';

		--op OR
		when "100101" =>
			--OUT: WE
			--wait for 30 ns;
			RegWrite  <= '1';
			MemToReg  <= '0';

			--OUT: MEM
			--wait for 20 ns;
			Branch  <= '0';
			MemRead  <= '0';
			MemWrite  <= '0';

			--OUT: EX
			--wait for 10 ns;
			RegDest  <= '1';
			AluOp  <= "001";
			AluSrc  <= '0';		

		--op SLT
		when "101010" =>
			--OUT: WE
			--wait for 30 ns;
			RegWrite  <= '1';
			MemToReg  <= '0';

			--OUT: MEM
			--wait for 20 ns;
			Branch  <= '0';
			MemRead  <= '0';
			MemWrite  <= '0';

			--OUT: EX
			--wait for 10 ns;
			RegDest  <= '1';
			AluOp  <= "111";
			AluSrc  <= '0';
		--op SLT
		when others =>
			--OUT: WE
			--wait for 30 ns;
			RegWrite  <= '1';
			MemToReg  <= '0';

			--OUT: MEM
			--wait for 20 ns;
			Branch  <= '0';
			MemRead  <= '0';
			MemWrite  <= '0';

			--OUT: EX
			--wait for 10 ns;
			RegDest  <= '1';
			AluOp  <= "111";
			AluSrc  <= '0';
		end case;
	--Instr Tipo I
        when "100011" =>			
        --op LW
		--OUT: WE
		--wait for 30 ns;
		RegWrite  <= '1';
		MemToReg  <= '1';

		--OUT: MEM
		--wait for 20 ns;
		Branch  <= '0';
		MemRead  <= '1';
		MemWrite  <= '0';

		--OUT: EX
		--wait for 10 ns;
		RegDest  <= '0';
		AluOp  <= "010";
		AluSrc  <= '1';

        when "101011" =>			
        --op SW
		--OUT: WE
		--wait for 30 ns;
		RegWrite  <= '0';
		MemToReg  <= '0';

		--OUT: MEM
		--wait for 20 ns;
		Branch  <= '0';
		MemRead  <= '0';
		MemWrite  <= '1';

		--OUT: EX
		--wait for 10 ns;
		--RegDest  <= "";
		AluOp  <= "010";
		AluSrc  <= '1';

        when "001111" =>			
        --op LUI
		--OUT: WE
		--wait for 30 ns;
		RegWrite  <= '1';
		MemToReg  <= '0';

		--OUT: MEM
		--wait for 20 ns;
		Branch  <= '0';
		MemRead  <= '0';
		MemWrite  <= '0';

		--OUT: EX
		--wait for 10 ns;
		RegDest  <= '0';
		AluOp  <= "010";
		AluSrc  <= '1';


        when "000100" =>			
        --op BEQ
		--OUT: WE
		--wait for 30 ns;
		RegWrite  <= '0';
		MemToReg  <= '0';

		--OUT: MEM
		--wait for 20 ns;
		Branch  <= '1';
		MemRead  <= '0';
		MemWrite  <= '0';

		--OUT: EX
		--wait for 10 ns;
		--RegDest  <= "";
		AluOp  <= "110";
		AluSrc  <= '0';
	when others =>
        --op LW
		--OUT: WE
		--wait for 30 ns;
		RegWrite  <= '1';
		MemToReg  <= '1';

		--OUT: MEM
		--wait for 20 ns;
		Branch  <= '0';
		MemRead  <= '1';
		MemWrite  <= '0';

		--OUT: EX
		--wait for 10 ns;
		RegDest  <= '0';
		AluOp  <= "010";
		AluSrc  <= '1';
	end case;
  end process; 
end control_arq;
