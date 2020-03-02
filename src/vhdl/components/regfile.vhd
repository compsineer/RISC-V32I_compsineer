--------------------------------------------------------------------------------
--file: regfile.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;

use std.textio.all;

entity regfile is 
	port(
		--inputs
     		clk_i 	    : in std_logic;
      		rst_i       : in std_logic;
      
      		rd_addr1_i  : in ieee.numeric_std.unsigned(4 downto 0);
      		rd_addr2_i  : in ieee.numeric_std.unsigned(4 downto 0);

      		wr_data_i   : in std_logic_vector(31 downto 0);
      		wr_addr_i   : in ieee.numeric_std.unsigned(4 downto 0);
      		wr_en_i     : in std_logic;
		--outputs
      		reg_data1_o : out std_logic_vector(31 downto 0);
      		reg_data2_o : out std_logic_vector(31 downto 0)
	);
end entity regfile;

architecture behavioral of regfile is
	
 	type reg_file_type is array (0 to 31) of std_logic_vector (31 downto 0);
	signal arr_reg : reg_file_type := (others => x"00000000");  
	signal rg_data1_o: std_logic_vector (31 downto 0) := (others => '0');
	signal rg_data2_o: std_logic_vector (31 downto 0) := (others => '0');

begin

	write_process: process(clk_i)
	begin

		if (rst_i = '1') then
			for i in 0 to 31 loop
				arr_reg(i) <= x"00000000";
			end loop;
		elsif rising_edge(clk_i) then
			--if wr_en_i, write data to wr_addr
			if (wr_en_i = '1') then 
				if (wr_addr_i /= "00000") then --avoid writing to the first location
					arr_reg(to_integer(wr_addr_i)) <= wr_data_i;
				end if;
			end if;
		end if;
 
	end process;

	--retrieve data from addr1 and addr2
	rg_data1_o <= arr_reg(to_integer(rd_addr1_i));
	rg_data2_o <= arr_reg(to_integer(rd_addr2_i));

	--assign data from addr1 and addr2 to signals	
	reg_data1_o <= rg_data1_o; --arr_reg(to_integer(rd_addr1_i));
	reg_data2_o <= rg_data2_o; --arr_reg(to_integer(rd_addr2_i));
		

end behavioral;