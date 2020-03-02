library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--use work.riscv_lib.all;

entity tb_controlUnit is
end tb_controlUnit;

architecture Behavioral of tb_controlUnit is   
		
		signal tb_opcode   : std_logic_vector (6 downto 0);
		signal tb_regdst   : std_logic;
		signal tb_branch   : std_logic;
		signal tb_memread  : std_logic;
		signal tb_memtoreg : std_logic;
		signal tb_aluop	   : std_logic;
		signal tb_memwrite : std_logic;
		signal tb_alusrc   : std_logic;
		signal tb_regwrite : std_logic;         

begin
	CU_Test:entity work.controlUnit (Behavioral)
		port map(
			--inputs
			opcode 	 => tb_opcode,
			--outputs
			regdst	 => tb_regdst,
			branch	 => tb_branch,
			memread  => tb_memread,
			memtoreg => tb_memtoreg,
			aluop	 => tb_aluop,
			memwrite => tb_memwrite,
			alusrc	 => tb_alusrc,
			regwrite => tb_regwrite
		);

		process
		begin
			tb_opcode <= "0110011"; --and, or, add, sub, slt : 0x00
			wait for 5 ns;
			tb_opcode <= "0010011"; --addi
			wait for 5 ns;
			tb_opcode <= "0000011"; --load word (lw) : 0x00
			wait for 5 ns;
			tb_opcode <= "0100011"; --store word (sw) : 0x2b
			wait for 5 ns;
			tb_opcode <= "1100011"; --branch equal (beq) : 0x04
			wait for 5 ns;

		end process;

end Behavioral;
