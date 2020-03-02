--------------------------------------------------------------------------------
--file: tb_regfile.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;

use std.textio.all;

entity tb_regfile is 
end entity tb_regfile;

architecture behavioral of tb_regfile is
	
  signal clk : std_logic;
  signal rst : std_logic;
  
  signal rd_addr1 : ieee.numeric_std.unsigned(4 downto 0);
  signal rd_addr2 : ieee.numeric_std.unsigned(4 downto 0);


  signal wr_data  : std_logic_vector(31 downto 0);
  signal wr_addr : ieee.numeric_std.unsigned(4 downto 0);
  signal wr_en  : std_logic;

  signal reg_data1 : std_logic_vector(31 downto 0);
  signal reg_data2 : std_logic_vector(31 downto 0);

  constant PERIOD      : time := 10 ns; --origianlly 100ns
  
begin
	
	tb_component : entity work.regfile (behavioral)
		port map(
			clk_i      => clk,
			rst_i      => rst,
			
			rd_addr1_i => rd_addr1,
			rd_addr2_i => rd_addr2,
			
			wr_data_i   => wr_data,
			wr_addr_i  => wr_addr,
			wr_en_i    => wr_en,
			
			reg_data1_o => reg_data1,
			reg_data2_o => reg_data2
		);
	
	-- generate clock signal
	clk_process: process
	begin
		-- reset time for 10 clock cycles
		clk <= '0';
		rst <= '1';
		for t in 1 to 2*10 loop
			wait for PERIOD/2;
			clk <= not clk;
		end loop;
		rst <= '0';
		
		wait for PERIOD*5;	

		-- loops forever generating the clock signal
		loop
			wait for PERIOD/2;
			clk <= not clk;
		end loop;
	end process;
	
	read_write_process: process
	begin
		rd_addr1 <= (others => '0');
		rd_addr2 <= (others => '0');
		wr_data <= (others => '0');
		wr_addr <= (others => '0');
		wr_en <=  '0'; --originally '0'

		-- wait for the reset time to end
		wait for PERIOD*15; --originally 15
		
		-- the initial state (after reset) of the register file should be zero.
		-- read everything and make sure it is initially zero.
		for i in 0 to 5 loop --5
			rd_addr1 <= to_unsigned(2*i, 5);
			rd_addr2 <= to_unsigned(2*i+1, 5);
			
			wait for PERIOD;
			assert (reg_data1 =  std_logic_vector(to_unsigned(0, 32)))
				report "RegData1 not initially zero!"
				severity failure;
			assert (reg_data2 = std_logic_vector(to_unsigned(0, 32))) 
				report "RegData2 not initially zero!"
				severity failure;
		end loop;
			
		-- write some values to the register file
		-- notice that one should not be able to write to the first register
		-- (the zero register) - so a write to 'zero' should be ignored by the register file.
		wr_en   <= '1';

		for i in 0 to 1 loop
			wr_data  <= std_logic_vector(to_unsigned(i*7 + 42, 32));
			wr_addr <= to_unsigned(i, 5);
			wait for PERIOD;
		end loop;
		wr_en <= '0'; --originally '0'
		
		-- if write enable = 0, the register should not be written to
		wr_data  <= std_logic_vector(to_unsigned(1234567890, 32)); --originally 1234567890
		wr_addr <= to_unsigned(1, 5); -- try writing to reg 1 --originally (1, 5)
		wait for PERIOD;
		rd_addr1 <= to_unsigned(1, 5); -- read reg 1
		wait for PERIOD;
		assert (reg_data1 =  std_logic_vector(to_unsigned(1*7 + 42, 32)) )
			report "Reg [1] was written to even if wr_en = 1!"
			severity failure;
        
        -- now we try to read from those registers and see if everything worked.
        rd_addr1 <= to_unsigned(0, 5); -- read reg 0
        rd_addr2 <= to_unsigned(1, 5); -- read reg 1
        
		wait for PERIOD;
		assert (reg_data1 = std_logic_vector(to_unsigned(0, 32))) 
			report "Register [0] is not zero after write!"
			severity failure;
		assert (reg_data2 =  std_logic_vector(to_unsigned(1*7 + 42, 32)) )
			report "Reg [1] not written to!"
			severity failure;
			
--        --now we try to read from those registers and see if everything worked.
--        rd_addr1 <= to_unsigned(2, 5); -- read reg 0
--        rd_addr2 <= to_unsigned(3, 5); -- read reg 1
--        
--		wait for PERIOD;
--		assert (reg_data1 = std_logic_vector(to_unsigned(2*7 + 42, 32))) 
--			report "Register [2] is not zero after write!"
--			severity failure;
--		assert (reg_data2 =  std_logic_vector(to_unsigned(3*7 + 42, 32)) )
--			report "Reg [3] not written to!"
--			severity failure;
			
	end process;

		
		
end behavioral;
