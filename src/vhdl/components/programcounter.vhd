--------------------------------------------------------------------------------
--file: programcounter.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity programcounter is
	port(
		--inputs
		clk_i 	: in std_logic := '0';
		rset_i 	: in std_logic := '0';
		pc_next	: in std_logic_vector(31 downto 0);
		--outputs
		pc_current: out std_logic_vector(31 downto 0)
	);
end programcounter;

architecture Behavioral of programcounter is
	
	signal s_pc_current: std_logic_vector(31 downto 0);
begin

	pc_proc: process (clk_i, rset_i)
	begin
		
		if (rset_i = '1') then
			s_pc_current <= x"00000000";
		elsif rising_edge(clk_i) then
			s_pc_current <= pc_next;
		end if;
 
	end process;

	pc_current <= s_pc_current;
	
end Behavioral;