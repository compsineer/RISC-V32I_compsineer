--------------------------------------------------------------------------------
--file: ALU.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.riscv_lib.all;

entity ALU is
	port(
		--inputs
      		in1 	: in std_logic_vector(31 downto 0);
      		in2 	: in std_logic_vector(31 downto 0);   
     		alu_ctrl: in instruction;
		--outputs
     		output  : out std_logic_vector(31 downto 0);
      		zero    : out std_logic; --sets when two input numbers are equal
    		gte     : out std_logic;	--sets when one input number is greater than or equal to the other
      		lt      : out std_logic --sets when one input number is less than the other
	);
end ALU;

architecture Behavioral of ALU is
	--Declare internal signals
	signal temp_output : std_logic_vector (31 downto 0); --defined for intermediate case output
	signal temp_zero   : std_logic := '0'; --sets when intermediate case for two input numbers are equal
    	signal temp_gte    : std_logic := '0';	--sets when intermediate case for one input number is greater than or equal to the other
      	signal temp_lt     : std_logic := '0'; --sets when intermediate case for one input number is less than the other

begin	

	ALU_Output: process (in1, in2, alu_ctrl)
	begin
		case (alu_ctrl) is
			-- Load (upper) immediate operation
   			-- U-type
  			when INST_LUI =>
				temp_output <= std_logic_vector(unsigned(in2));
    			-- Control operations
    			-- B-type
    			when INST_BEQ =>
				if (signed(in1) /= signed(in2)) then
					temp_zero <= '0'; 
				else 
					temp_zero <= '1';
				end if;
    			when INST_BLT =>
				if (signed(in1) < signed(in2)) then
					temp_lt <= '1'; 
				else 
					temp_lt <= '0';
				end if;
    			when INST_BGE =>
				if (signed(in1) >= signed(in2)) then
					temp_gte <= '1'; 
				else 
					temp_gte <= '0';
				end if;

    			-- Memory operations
    			when INST_LW => -- I-type
				temp_output <= std_logic_vector(signed(in1) + signed(in2));
    			when INST_SW => -- S-type
				temp_output <= std_logic_vector(unsigned(in1) + unsigned(in2));

    			-- Immediate operations
    			-- I-type
    			when INST_ADDI =>
				temp_output <= std_logic_vector(signed(in1) + signed(in2));
    			when INST_SLTI =>
				if (signed(in1) < signed(in2)) then
	  				temp_output <= (0 => '1', others => '0'); --x"00000001";
				else
	  				temp_output <= (others => '0');  --x"00000000";
				end if;
    			when INST_SLTIU =>
				if (unsigned(in1) < unsigned(in2)) then
	 				temp_output <= (0 => '1', others => '0'); --x"00000001";
				else
	  				temp_output <= (others => '0'); --x"00000000";
				end if;
    			when INST_XORI =>
				temp_output <= std_logic_vector(unsigned(in1) xor unsigned(in2));
    			when INST_ORI =>
				temp_output <= std_logic_vector(unsigned(in1) or unsigned(in2));
    			when INST_ANDI =>
				temp_output <= std_logic_vector(unsigned(in1) and unsigned(in2));

    			-- Shifts
    			-- R-type
    			when INST_SLLI =>
				temp_output <= std_logic_vector(shift_left(unsigned(in1), to_integer(unsigned(in2(4 downto 0)))));
    			when INST_SRLI =>
				temp_output <= std_logic_vector(shift_right(unsigned(in1), to_integer(unsigned(in2(4 downto 0)))));
    			when INST_SRAI =>
				temp_output <= std_logic_vector(shift_right(signed(in1), to_integer(unsigned(in2(4 downto 0))))); 

    			-- Register-to-Register
    			-- R-type
    			when INST_ADD =>
        			temp_output <= std_logic_vector(signed(in1) + signed(in2));
    			when INST_SUB =>
				temp_output <= std_logic_vector(unsigned(in1) - unsigned(in2));
    			when INST_SLL =>
				temp_output <= std_logic_vector(shift_left(unsigned(in1), to_integer(unsigned(in2(4 downto 0))))); 
    			when INST_SLT =>
				if (signed(in1) < signed(in2)) then
	  				temp_output <= (0 => '1', others => '0'); --x"00000001";
				else
	  				temp_output <= (others => '0');  --x"00000000";
				end if;
    			when INST_SLTU =>
				if (unsigned(in1) < unsigned(in2)) then
	 				temp_output <= (0 => '1', others => '0'); --x"00000001";
				else
	  				temp_output <= (others => '0'); --x"00000000";
				end if;
    			when INST_XOR =>
				temp_output <= std_logic_vector(unsigned(in1) xor unsigned(in2));
    			when INST_SRL =>
				temp_output <= std_logic_vector(shift_right(unsigned(in1), to_integer(unsigned(in2(4 downto 0)))));
    			when INST_SRA =>
				temp_output <= std_logic_vector(shift_right(signed(in1), to_integer(unsigned(in2(4 downto 0)))));
    			when INST_OR =>
				temp_output <= std_logic_vector(unsigned(in1) or unsigned(in2));
    			when INST_AND =>
				temp_output <= std_logic_vector(unsigned(in1) and unsigned(in2));
			when others =>
       				temp_output <= (others => '0');        
    		end case;

	end process;

	--Connect internal signals to output signals
		output <= temp_output;
      		zero   <= temp_zero;
    		gte    <= temp_gte;
      		lt     <= temp_lt;

end Behavioral;
