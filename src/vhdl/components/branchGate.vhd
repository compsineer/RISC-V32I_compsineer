--------------------------------------------------------------------------------
--file: branchGate.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity branchGate is
	port(
		--inputs
		branch_i :in std_logic;
		zero_i   :in std_logic;
     		gt_i     :in std_logic;
     		lt_i     :in std_logic;
      		--outputs
		gate_o   :out std_logic
	);
end branchGate;

architecture Behavioral of branchGate is 

	signal temp_out : std_logic;

begin
	process (branch_i, zero_i, gt_i, lt_i)
	begin
		if (branch_i = '1') then
			if (zero_i = '1') then
				temp_out <= '1';
			elsif (gt_i = '1') then
				temp_out <= '1';
			elsif (lt_i = '1') then
				temp_out <= '1';
			else
				temp_out <= '0';
			end if;
		else
			temp_out <= '0';
		end if;

	end process;

	gate_o <= temp_out;

end Behavioral;
