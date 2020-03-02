--------------------------------------------------------------------------------
--file: signextend.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signextend is
	port(
		--inputs
		se_i	: in std_logic_vector(11 downto 0);
		se_lui	: in std_logic_vector (19 downto 0);
		se_sh	: in std_logic_vector (11 downto 0);
		--outputs
		se_o	: out std_logic_vector(31 downto 0);
		se_lui_o: out std_logic_vector (31 downto 0);
		se_sh_o : out std_logic_vector (31 downto 0)
	);
end signextend;

architecture Behavioral of signextend is
	
	
begin
	--se_o <= "00000000000000000000" & se_i when se_i(11) = '0' else "11111111111111111111" & se_i;
	
	se_lui_o <= se_lui & x"000";

	se_o <= x"00000" & se_i when se_i(11) = '0' else x"fffff" & se_i;
			
	se_sh_o <= x"00000" & se_sh when se_sh(11) = '0' else x"fffff" & se_sh;

end Behavioral;
