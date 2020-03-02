--------------------------------------------------------------------------------
--file: tb_decoder.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_decoder is
end tb_decoder;

architecture Behavioral of tb_decoder is

		constant period : time := 20 ns;

		signal tb_instr_i	: std_logic_vector (31 downto 0);
		
		--outputs
		signal tb_rs1_o		: std_logic_vector (4 downto 0);		
		signal tb_rs2_o		: std_logic_vector (4 downto 0);	
		signal tb_rd_o		: std_logic_vector (4 downto 0);		
		signal tb_imm_o		: std_logic_vector (11 downto 0);	
		signal tb_imm_sh 	: std_logic_vector (11 downto 0);	
		signal tb_imm_lui 	: std_logic_vector (19 downto 0);
		signal tb_opcod_o	: std_logic_vector (6 downto 0);	
		signal tb_func7_o	: std_logic_vector (6 downto 0);		
		signal tb_func3_o	: std_logic_vector (2 downto 0);	

begin
	UUT: entity work.decoder (Behavioral)
	port map (
		instr_i	=> tb_instr_i,
		
		rs1_o	=> tb_rs1_o,	
		rs2_o	=> tb_rs2_o,
		rd_o	=> tb_rd_o,	
		imm_o   => tb_imm_o,
		imm_sh  => tb_imm_sh,
		imm_lui => tb_imm_lui,
		opcod_o	=> tb_opcod_o,
		func7_o	=> tb_func7_o,		
		func3_o	=> tb_func3_o
	);

	
	stim_proc: process 

	begin
		
		wait for period;
		tb_instr_i <= x"000011B7";	--0x0040 0004: each address increases by 4	
		wait for period;

		tb_instr_i <= x"00004937";	--0x0040 0008:
		wait for period;
						
		tb_instr_i <= x"00F00313";
		wait for period;
		
		
		tb_instr_i <= x"006282B3";
		wait for period;
		
		tb_instr_i <= x"00C95913";	--0x0040 000C:
		wait for period;

		tb_instr_i <= x"0121A023";	--0x0040 0010:
		wait for period;

		tb_instr_i <= x"00008937";
		wait for period;
	
--	assert false
--		report "END"
--			severity failure;
	end process;

end Behavioral;
