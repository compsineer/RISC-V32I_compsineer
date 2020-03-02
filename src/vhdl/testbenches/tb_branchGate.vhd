--------------------------------------------------------------------------------
--file: tb_branchGate.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_branchGate is
end tb_branchGate;

architecture Behavioral of tb_branchGate is

		signal tb_branch_i : std_logic;
		signal tb_zero_i   : std_logic;
     		signal tb_gt_i     : std_logic;
     		signal tb_lt_i     : std_logic;
		signal tb_gate_o   : std_logic;

begin

	UUT: entity work.branchGate (Behavioral)
	port map(
		branch_i => tb_branch_i,
		zero_i   => tb_zero_i,
     		gt_i     => tb_gt_i,
     		lt_i     => tb_lt_i,
		gate_o   => tb_gate_o
	);

	STIM_PROC: process

	begin	
		wait for 10 ns;
		tb_branch_i <= '1';
		tb_zero_i <= '1';
		wait for 10 ns;

		tb_branch_i <= '0';
		tb_zero_i <= '0';
		wait for 10 ns;

		tb_branch_i <= '1';
		tb_gt_i <= '1';
		wait for 10 ns;

		tb_branch_i <= '0';
		tb_gt_i <= '0';
		wait for 10 ns;

		tb_branch_i <= '1';
		tb_lt_i <= '1';
		wait for 10 ns;

		tb_branch_i <= '0';
		tb_lt_i <= '0';
		wait for 10 ns;
	
--	assert false
--		report "END"
--			severity failure;
	end process;

end Behavioral;
