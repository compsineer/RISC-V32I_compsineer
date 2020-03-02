--------------------------------------------------------------------------------
--file: tb_shiftLeftOne.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_shiftLeftOne is
	
end tb_shiftLeftOne;

architecture Behavioral of tb_shiftLeftOne is
	
	signal tb_from_se_sh: std_logic_vector(31 downto 0) := (others => '0');

	signal tb_to_adder : std_logic_vector(31 downto 0);

begin
	UUT: entity work.shiftLeftOne (Behavioral) 
		port map (
		from_se_sh => tb_from_se_sh,
		to_adder => tb_to_adder		
		);

	stim_proc: process is 
	begin
		tb_from_se_sh <= x"fff333f3" ;
		wait;

--	assert false
--		report "END"
--			severity failure;
	end process;

end Behavioral;
