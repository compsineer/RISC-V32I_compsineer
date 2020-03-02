--------------------------------------------------------------------------------
--file: reg_mux.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_mux is
	port(
		--inputs
		rs2_i0		: in ieee.numeric_std.unsigned(4 downto 0);
		dst_reg_i1	: in ieee.numeric_std.unsigned(4 downto 0);
		rg_dst		: in std_logic;
		--outputs
		wr_dst_o	: out ieee.numeric_std.unsigned(4 downto 0)
	);
end reg_mux;

architecture Behavioral of reg_mux is

begin
	wr_dst_o <= rs2_i0 when rg_dst = '0' else dst_reg_i1;

end Behavioral;
