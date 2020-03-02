--------------------------------------------------------------------------------
--file: pcbranch_mux.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pcbranch_mux is
	port(
		--inputs
		fr_pcplus4_i0	: in std_logic_vector(31 downto 0);
		fr_adder2_i1	: in std_logic_vector(31 downto 0);
		fr_n_gate_i	: in std_logic;
		--outputs
		pcbr_mux_o	: out std_logic_vector(31 downto 0)
	);
end pcbranch_mux;

architecture Behavioral of pcbranch_mux is
	
begin
	
		pcbr_mux_o <= fr_pcplus4_i0 when fr_n_gate_i = '0' else fr_adder2_i1;
	

end Behavioral;
