--------------------------------------------------------------------------------
--file: wrback_mux.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wrback_mux is
	port(
		--inputs
		from_alu_i0	: in std_logic_vector(31 downto 0);	
		mem_rd_data_i1	: in std_logic_vector(31 downto 0);
		mem_to_reg_i	: in std_logic;
		--outputs
		mux_wr_data_o	: out std_logic_vector(31 downto 0)
	);
end wrback_mux;

architecture Behavioral of wrback_mux is

begin
	mux_wr_data_o <= from_alu_i0 when mem_to_reg_i = '0' else mem_rd_data_i1;

end Behavioral;
