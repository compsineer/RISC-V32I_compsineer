--------------------------------------------------------------------------------
--file: tb_alusrc_mux.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alusrc_mux is
		
end tb_alusrc_mux;

architecture Behavioral of tb_alusrc_mux is
	--inputs
	signal tb_rd_data2_i0	: std_logic_vector(31 downto 0);
	signal tb_from_se_imm	: std_logic_vector(31 downto 0);
	signal tb_alusrc_ctrl	: std_logic;
	--outputs
	signal tb_mux_in2_o		: std_logic_vector(31 downto 0);

begin
	MuxUT: entity work.alusrc_mux(Behavioral)
	port map(
	rd_data2_i0 => tb_rd_data2_i0,
	from_se_imm => tb_from_se_imm,
	alusrc_ctrl => tb_alusrc_ctrl,
	mux_in2_o => tb_mux_in2_o);
	
	stim_proc: process is
	begin
		--32 bit 2-to-1 MUX
		tb_rd_data2_i0 <= x"AAAA5555";
		tb_from_se_imm <= x"5555AAAA";

		tb_alusrc_ctrl <= '0';
		wait for 100 ns;
		tb_alusrc_ctrl <= '1';
		wait for 100 ns;
		tb_alusrc_ctrl <= '0';
		wait for 100 ns;
	
	assert false
		report "END"
			severity failure;

	end process;

end Behavioral;
