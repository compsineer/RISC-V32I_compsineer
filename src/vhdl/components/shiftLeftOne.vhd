--------------------------------------------------------------------------------
--file: shiftLeftOne.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shiftLeftOne is
	port(
		--inputs
		from_se_sh: in std_logic_vector(31 downto 0);
		--outputs
		to_adder:   out std_logic_vector(31 downto 0)
	);
end shiftLeftOne;

architecture Behavioral of shiftLeftOne is

begin
	to_adder <= from_se_sh(30 downto 0) & "0"; 

end Behavioral;
