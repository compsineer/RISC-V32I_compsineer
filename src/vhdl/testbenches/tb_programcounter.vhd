--file: tb_programcounter.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_programcounter is
end tb_programcounter;

architecture Behavioral of tb_programcounter is
		signal tb_clk_i      : std_logic;
		signal tb_rset_i     : std_logic;
		signal tb_pc_next    : std_logic_vector(31 downto 0);
		signal tb_pc_current : std_logic_vector(31 downto 0);
begin
	PC_Test:entity work.programcounter (Behavioral)
		port map(
			clk_i 	  => tb_clk_i,
			rset_i 	  => tb_rset_i,
			pc_next	  => tb_pc_next,
			pc_current=> tb_pc_current
		);

	pc_proc: process 
	begin
		tb_rset_i <= '1';
		wait for 10 ns;

		tb_rset_i <= '0';
		tb_clk_i <= '1';
		tb_pc_next <= x"00000001";

		wait for 10 ns;
		tb_clk_i <= '0';
		tb_rset_i <= '1';
		tb_pc_next <= x"00000003";
		wait for 10 ns;
		tb_clk_i <= '1';
		tb_pc_next <= x"00000005";
		wait for 10 ns;
			 
	
--	assert false
--		report "END"
--			severity failure;
	end process;
	
end Behavioral;
