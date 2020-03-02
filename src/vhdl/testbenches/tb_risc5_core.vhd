--------------------------------------------------------------------------------
--file: tb_risc5_core.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use STD.textio.all;

use work.riscv_lib.all;

entity tb_risc5_core is
end entity tb_risc5_core;

architecture Behavioral of tb_risc5_core is

	-- set the path to your memory file directory here!
	constant MEM_DIR       : string := "C:\Users\LENOVO\Desktop\RISCV32I_Compsineer\";
	-- instruction memory file is specified here!
	constant INST_MEM_FILE : string := "inst.mem"; --sample instructions kept in the folder
	-- data memory file is specified here!
	constant DATA_MEM_FILE : string := "data.mem"; --sample instructions kept in the folder

	constant PERIOD          : time := 100 ns;
	constant RESET_DELAY     : time := 500 ns;
	constant SIMULATION_TIME : time := 90000 ns;

	-- We assume small memories
	type t_IMEMORY is array (4096-1 downto 0) of std_logic_vector(31 downto 0);
	type t_DMEMORY is array (8192-1 downto 0) of std_logic_vector(31 downto 0);

	signal inst_memory   : t_IMEMORY;
	signal data_memory   : t_DMEMORY;

	signal tb_clk_i	     : std_logic; 
	signal tb_reset_i    : std_logic;
	signal tb_instr_i   : std_logic_vector(31 downto 0); --receives from instruction mememory	
	signal tb_rd_data_i  : std_logic_vector(31 downto 0); --read from data memory
	signal tb_prcount_o  : std_logic_vector(31 downto 0);
	signal tb_mem_wri_o  : std_logic;
	signal tb_memo_rd_o  : std_logic;
	signal tb_alu_out_o  : std_logic_vector(31 downto 0);
	signal tb_rd_data2_o : std_logic_vector (31 downto 0); --read from register file read data 2

begin
	
	-- instantiate your top level here!
	risc5_core : entity work.risc5_core (Behavioral)
	port map(
		clk_i	   => tb_clk_i,
		reset_i    => tb_reset_i,
		instr_i    => tb_instr_i,
		rd_data_i  => tb_rd_data_i,
		prcount_o  => tb_prcount_o,
		mem_wri_o  => tb_mem_wri_o,
		memo_rd_o  => tb_memo_rd_o,
		alu_out_o  => tb_alu_out_o,
		rd_data2_o => tb_rd_data2_o
	);

	-- generate clock signal
	clk_process : process
	begin
		loop
			tb_clk_i <= '0';
			wait for PERIOD / 2;
			tb_clk_i <= '1';
			wait for PERIOD / 2;

			assert now < SIMULATION_TIME
			report "End of Simulation!"
			severity failure;           -- throw failure to break simulation
		end loop;
	end process;

	tb_reset_i <= '1', '0' after RESET_DELAY;


	-- simulates data memory
	data_mem : process(tb_reset_i, tb_clk_i, tb_alu_out_o, tb_mem_wri_o, data_memory)
		file dmem_init_file : text open read_mode is MEM_DIR & DATA_MEM_FILE;

		variable line_buf   : line;      -- Line buffers
		variable str_buf    : string(1 to 10); -- string to modify
		variable value_buf  : std_logic_vector(31 downto 0);
		variable address    : integer := 0;
	begin
		if tb_reset_i = '1' then
	
			-- Initialize the instruction memory
			address := 0;
			loop
				if endfile(dmem_init_file) then
					exit;
				else
					readline(dmem_init_file, line_buf);
					read(line_buf, str_buf);
					str_buf := str_buf(str_buf'left + 2 to str_buf'right) & "  ";
					write(line_buf, str_buf);
	
					hread(line_buf, value_buf);
	
					data_memory(address) <= value_buf;
					address              := address + 1;
				end if;
			end loop;
		else
			-- assynchronous read
			tb_rd_data_i <= data_memory(to_integer(shift_right(unsigned(tb_alu_out_o), 2)));
			
			-- synchronous write
			if rising_edge(tb_clk_i) and tb_mem_wri_o = '1' then
				data_memory(to_integer(unsigned(tb_alu_out_o))) <= tb_rd_data2_o;
			end if;
		end if;
	end process;

	-- simulates program memory
	inst_mem: process(tb_reset_i, tb_prcount_o, inst_memory)
		file imem_init_file : text open read_mode is MEM_DIR & INST_MEM_FILE;

		variable line_buf   : line;      -- Line buffers
		variable str_buf    : string(1 to 10); -- string to modify
		variable value_buf  : std_logic_vector(31 downto 0);
		variable address    : integer := 0;
	begin
		if tb_reset_i = '1' then
			address := 0;
			loop
				if endfile(imem_init_file) then
					exit;
				else
					readline(imem_init_file, line_buf);
					read(line_buf, str_buf);
					assert 0 = 1 report "Read: " & str_buf severity warning;
					str_buf := str_buf(str_buf'left + 2 to str_buf'right) & "  ";
					write(line_buf, str_buf);
	
					hread(line_buf, value_buf);
	
					inst_memory(address) <= value_buf;
					address              := address + 1;
				end if;
			end loop;
		else 
			tb_instr_i <= inst_memory(to_integer(shift_right(unsigned(tb_prcount_o), 2)));
		end if;
	end process;

end Behavioral;
