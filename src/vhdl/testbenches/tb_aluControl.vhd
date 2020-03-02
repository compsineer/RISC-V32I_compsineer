--------------------------------------------------------------------------------
--file: tb_aluControl.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.riscv_lib.all;

entity tb_aluControl is
end tb_aluControl;

architecture Behavioral of tb_aluControl is 

		signal tb_aluop 	: std_logic; --from control unit;
		signal tb_op_code	: std_logic_vector(6 downto 0); --from decoder
		signal tb_funct7	: std_logic_vector(6 downto 0); --from decoder
		signal tb_funct3	: std_logic_vector(2 downto 0); --from decoder
		signal tb_alucontrol 	: instruction;
begin

	AluC_Test:entity work.aluControl (Behavioral)
		port map(
			aluop 	   => tb_aluop,
			op_code	=> tb_op_code,
			funct7	=> tb_funct7,
			funct3	=> tb_funct3,
			alucontrol => tb_alucontrol
		);
	STIM_PROC: process
		begin
			-- assign appropriate values here
			tb_aluop <= '1';
			tb_op_code <="0110011";
			tb_funct7 <= "0100000";
			tb_funct3 <="101";
			wait for 10 ns;
			tb_aluop <= '0';
			tb_op_code <="0000011";
			tb_funct7 <= "XXXXXXX";
			tb_funct3 <= "010";
			wait for 10 ns;
			tb_aluop <= '1';
			tb_op_code <="0010011";
			tb_funct7 <="0100000";
			tb_funct3 <="101";
			
		
		end process;

end Behavioral;
