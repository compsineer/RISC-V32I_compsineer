--------------------------------------------------------------------------------
--file: tb_signextend.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_signextend is 

end tb_signextend;


architecture Behavioral of tb_signextend is

		signal tb_se_i	  : std_logic_vector (11 downto 0);
		signal tb_se_lui  : std_logic_vector (19 downto 0);
		signal tb_se_sh	  : std_logic_vector (11 downto 0);
		signal tb_se_o	  : std_logic_vector (31 downto 0);
		signal tb_se_lui_o: std_logic_vector (31 downto 0);
		signal tb_se_sh_o : std_logic_vector (31 downto 0);
begin

	U1_Test: entity work.signextend (Behavioral)
	port map(
		se_i	 => tb_se_i,
		se_lui   => tb_se_lui,
		se_sh	 => tb_se_sh,
		se_o	 => tb_se_o,
		se_lui_o => tb_se_lui_o,
		se_sh_o  => tb_se_sh_o
	);

	stim_proc: process
	begin
		tb_se_i <= x"7FF";
		wait for 10 ns;

		tb_se_lui <= x"00001";
		wait for 10 ns;

		tb_se_sh <= "001101100011";
		wait for 10 ns;
	
--	assert false
--	  report "END"
--	    severity failure;

	end process;

END;
