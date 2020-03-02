--------------------------------------------------------------------------------
--file: aluControl.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.riscv_lib.all;

entity aluControl is
	port(	
		--inputs
		aluop 	: in std_logic; --from control unit
		op_code	: in std_logic_vector(6 downto 0); --from decoder
		funct7	: in std_logic_vector(6 downto 0); --from decoder
		funct3	: in std_logic_vector(2 downto 0); --from decoder
		--ouputs
		alucontrol : out instruction
	);
end aluControl;

architecture Behavioral of aluControl is 

	signal sig_aluctrl : instruction;

begin
				
		process (op_code, funct7, funct3, aluop)
		begin

		if (aluop = '1') then

			case op_code is
				when "0110011" => --and, or, add, sub, slt 
					if (funct7 = "0000000") then
						if (funct3 = "000") then
							sig_aluctrl <= INST_ADD;
						elsif (funct3 = "001") then
							sig_aluctrl <= INST_SLL;
						elsif (funct3 = "010") then
							sig_aluctrl <= INST_SLT;
						elsif (funct3 = "011") then
							sig_aluctrl <= INST_SLTU;
						elsif (funct3 = "100") then
							sig_aluctrl <= INST_XOR;
						elsif (funct3 = "101") then
							sig_aluctrl <= INST_SRL;
						elsif (funct3 = "110") then
							sig_aluctrl <= INST_OR;
						elsif (funct3 = "111") then 
							sig_aluctrl <= INST_AND;
						end if;
					elsif (funct7 = "0100000") then 
						if (funct3 = "000") then
							sig_aluctrl <= INST_SUB;
						elsif(funct3 = "101") then
							sig_aluctrl <= INST_SRA;
						end if;
					end if;
--			------------------------------------------------------------------
				when "0010011" => --addi
					if (funct7 = "0000000") then
						if(funct3 = "001") then
							sig_aluctrl <= INST_SLLI;
						elsif(funct3 = "101") then
							sig_aluctrl <= INST_SRLI;
						end if;
					elsif(funct7 = "0100000") then
						if (funct3 = "101") then
							sig_aluctrl <= INST_SRAI;
						end if;					
					else
						if (funct3 = "000") then
							sig_aluctrl <= INST_ADDI;
						elsif (funct3 = "010") then
							sig_aluctrl <= INST_SLTI;
						elsif (funct3 = "011") then
							sig_aluctrl <= INST_SLTIU;
						elsif (funct3 = "100") then
							sig_aluctrl <= INST_XORI;
						elsif (funct3 = "110") then
							sig_aluctrl <= INST_ORI;
						elsif (funct3 = "111") then	
							sig_aluctrl <= INST_ANDI;
						end if;

					end if;
			------------------------------------------------------------------
				when "0000011" => --load word (lw) 
						if (funct3 = "010") then
							sig_aluctrl <= INST_LW;
						end if;
			------------------------------------------------------------------
				when "0100011" => --store word (sw)
						if(funct3 = "010") then
							sig_aluctrl <= INST_SW;
						end if;
			------------------------------------------------------------------
				when "1100011" => --branch equal (beq) 
						if(funct3 = "000") then
							sig_aluctrl <= INST_BEQ;
						elsif(funct3 = "100") then
							sig_aluctrl <= INST_BLT;
						elsif(funct3 = "101") then	
							sig_aluctrl <= INST_BGE;
						end if;
			------------------------------------------------------------------ 
				when "0110111" => --LUI
					sig_aluctrl <= INST_LUI;
			------------------------------------------------------------------    
				when others =>
				  	sig_aluctrl <= INST_NO_OP;
			end case;
			------------------------------------------------------------------	
		end if;

		end process;

		alucontrol <= sig_aluctrl;

end Behavioral;