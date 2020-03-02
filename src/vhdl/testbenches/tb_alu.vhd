--------------------------------------------------------------------------------
--file: tb_ALU.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;

library STD;
use std.textio.all;

use work.riscv_lib.all;

entity tb_ALU is 
end entity tb_ALU;

architecture behavioral of tb_ALU is
	
  signal tb_in1 : std_logic_vector(31 downto 0) := (others => '0');
  signal tb_in2 : std_logic_vector(31 downto 0) := (others => '0');
  signal tb_alu_ctrl : instruction;
  signal tb_output : std_logic_vector(31 downto 0);
  signal tb_zero   : std_logic;
  signal tb_gte     : std_logic;
  signal tb_lt     : std_logic;
 
  signal clk : std_logic;

  -- This declares, as suggested, a constant of type 'time' with a value of 100
  -- ns.
  constant PERIOD      : time := 10 ns;
  
begin
	--instantiate device under test
	tb_component: entity work.ALU (behavioral)
	port map (
          in1      => tb_in1,
          in2      => tb_in2,
          alu_ctrl => tb_alu_ctrl,
          output   => tb_output,
          zero     => tb_zero,
          gte       => tb_gte,
          lt       => tb_lt
          );

	-- generate clock signal
	clk_process: process
	begin
        clk <= '0';
        wait for PERIOD * 10;
	--wait for 10 ns;

        -- set up the ALU to execute the ADD operation during the whole testbench
        tb_alu_ctrl <= INST_ADD;
	--tb_alu_ctrl <= INST_SLL;
        
        -- This is a 'building block' for testing the circuit.
        -- Basically we 'emulate' a sequential circuit that feeds the ALU
        -- with a new value each clock cycle
        --
        -- "begin building block"
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';

        -- "Insert value updates here"
	tb_in1 <= std_logic_vector(to_unsigned(4,32));
	tb_in2 <= std_logic_vector(to_unsigned(6,32));

        -- wait for PERIOD/2;
        -- "end building block"

        -- Example:
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';

        -- we take the value 3 (or 9), tell the machine that we want a 'signed' (with
        -- sign bit, rather than 'unsigned') representation with 32 bits, and
        -- then tell it it to cast it as an std_logic_vector. We do this for
        -- both inputs.
        tb_in1 <= std_logic_vector(to_signed(3, 32));
        tb_in2 <= std_logic_vector(to_signed(9, 32));
        -- Now you should see in the output of the ALU the value "12".
        
        wait for PERIOD/2;

        -- Another example, same thing but now with an unsigned value:
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
	tb_alu_ctrl <= INST_SUB;
        tb_in1 <= std_logic_vector(to_signed(52, 32));
        tb_in2 <= std_logic_vector(to_signed(51, 32));
        -- Now you should see in the output of the ALU the value "1".
        -- We can use assert statements to check that automatically
        
        wait for PERIOD/2;

	 clk <= '1';
	tb_alu_ctrl <= INST_BGE;
        tb_in1 <= std_logic_vector(to_signed(52, 32));
        tb_in2 <= std_logic_vector(to_signed(51, 32));
        -- Now you should see in the output of the ALU the value "1".
        -- We can use assert statements to check that automatically
        
        wait for PERIOD/2;
	
        assert (tb_output(0) = '0') report "Output error" severity failure;
        
	end process;
	
	
end behavioral;
