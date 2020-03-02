--------------------------------------------------------------------------------
--file: imm_mux.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imm_mux is
	port(
		--inputs
		frm_seo_imm	: in std_logic_vector(31 downto 0);
		frm_seo_lui	: in std_logic_vector(31 downto 0);
		imux_ctrl_code	: in std_logic;
		--outputs
		alu_mux_in2_o	: out std_logic_vector(31 downto 0)
	);
end imm_mux;

architecture Behavioral of imm_mux is

begin
	alu_mux_in2_o <= frm_seo_lui when imux_ctrl_code = '1' else frm_seo_imm;

end Behavioral;
