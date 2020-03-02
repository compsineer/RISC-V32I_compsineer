--------------------------------------------------------------------------------
--file: tb_reg_mux.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_reg_mux is
		
end tb_reg_mux;

architecture Behavioral of tb_reg_mux is
	--inputs
	signal tb_rs2_i0	: ieee.numeric_std.unsigned(4 downto 0);
	signal tb_dst_reg_i1	: ieee.numeric_std.unsigned(4 downto 0);
	signal tb_rg_dst	: std_logic;
	--outputs
	signal tb_wr_dst_o	: ieee.numeric_std.unsigned(4 downto 0);

begin
	Reg_MuxUT: entity work.reg_mux(Behavioral)
	port map(
	rs2_i0 	=> tb_rs2_i0,
	dst_reg_i1 => tb_dst_reg_i1,
	rg_dst => tb_rg_dst,
	wr_dst_o => tb_wr_dst_o);
	
	stim_proc: process is
	begin
		--5 bit 2-to-1 MUX
		tb_rs2_i0 <= "00001";
		tb_dst_reg_i1 <= "00010";

		tb_rg_dst <= '0';
		wait for 100 ns;
		tb_rg_dst <= '1';
		wait for 100 ns;
		tb_rg_dst <= '0';
		wait for 100 ns;
	
--	assert false
--		report "END"
--			severity failure;

	end process;

end Behavioral;
