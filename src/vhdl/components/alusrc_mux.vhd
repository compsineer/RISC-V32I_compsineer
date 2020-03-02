--------------------------------------------------------------------------------
--file: alusrc_mux.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alusrc_mux is
	port(
		--inputs
		rd_data2_i0	: in std_logic_vector(31 downto 0);
		from_se_imm	: in std_logic_vector(31 downto 0);
		alusrc_ctrl	: in std_logic;
		--outputs
		mux_in2_o	: out std_logic_vector(31 downto 0)
	);
end alusrc_mux;

architecture Behavioral of alusrc_mux is

begin
	mux_in2_o <= rd_data2_i0 when alusrc_ctrl = '0' else from_se_imm;

end Behavioral;
