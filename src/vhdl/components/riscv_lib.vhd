--------------------------------------------------------------------------------
--file: riscv_lib.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all; -- import std_logic types
use IEEE.std_logic_arith.all; -- import add/sub of std_logic_vector
use IEEE.std_logic_unsigned.all;


package riscv_lib is

  	type instruction is (
		-- Load (upper) immediate operation
    		-- U-type
    		INST_LUI,

   		-- Control operations
    		-- B-type
    		INST_BEQ, 
    		INST_BLT,
    		INST_BGE,

    		-- Memory operations
    		INST_LW, -- I-type
    		INST_SW, -- S-type

    		-- Immediate operations
    		-- I-type
    		INST_ADDI,
    		INST_SLTI,
    		INST_SLTIU,
    		INST_XORI,
    		INST_ORI,
    		INST_ANDI,

    		-- Shifts
    		-- R-type
    		INST_SLLI,
    		INST_SRLI,
    		INST_SRAI,

    		-- Register-to-Register
    		-- R-type
    		INST_ADD,
    		INST_SUB,
    		INST_SLL,
    		INST_SLT,
    		INST_SLTU,
    		INST_XOR,
    		INST_SRL,
    		INST_SRA,
    		INST_OR,
    		INST_AND,

    		-- No operation
    		INST_NO_OP);

end package riscv_lib;
