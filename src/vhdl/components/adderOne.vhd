--------------------------------------------------------------------------------
--file: adderOne.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adderOne is
	port(
		--inputs
		pc_current: in std_logic_vector(31 downto 0);
		--outputs
		pcplus4_o:   out std_logic_vector(31 downto 0)
	);
end adderOne;

architecture Behavioral of adderOne is

begin
	pcplus4_o <=std_logic_vector(unsigned(pc_current) + x"00000004");

end Behavioral;
