--file: adderTwo.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adderTwo is
	port(
	--inputs
	from_se: in std_logic_vector(31 downto 0);
	from_pcplus4:  in std_logic_vector (31 downto 0);
	--outputs
	adder_o:   out std_logic_vector(31 downto 0));
end adderTwo;

architecture Behavioral of adderTwo is

begin
	adder_o <=std_logic_vector(unsigned(from_se) + unsigned(from_pcplus4));

end Behavioral;

