--------------------------------------------------------------------------------
--file: decoder.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity decoder is
	port(
		--inputs
		instr_i	: in std_logic_vector (31 downto 0); --receives output from instruction memory
		--outputs
		rs1_o	: out std_logic_vector (4 downto 0);		
		rs2_o	: out std_logic_vector (4 downto 0);	
		rd_o	: out std_logic_vector (4 downto 0);		
		imm_o	: out std_logic_vector (11 downto 0);
		imm_sh  : out std_logic_vector (11 downto 0);	
		imm_lui : out std_logic_vector (19 downto 0);
		opcod_o	: out std_logic_vector (6 downto 0);	
		func7_o	: out std_logic_vector (6 downto 0);		
		func3_o	: out std_logic_vector (2 downto 0)				
	);
end decoder;

architecture Behavioral of decoder is
	signal sig_instr   : std_logic_vector (31 downto 0);
	signal sig_rs1_o   : std_logic_vector (4 downto 0);		
	signal sig_rs2_o   : std_logic_vector (4 downto 0);	
	signal sig_rd_o	   : std_logic_vector (4 downto 0);		
	signal sig_imm_o   : std_logic_vector (11 downto 0);	
	signal sig_imm_sh  : std_logic_vector (11 downto 0);
	signal sig_imm_lui : std_logic_vector (19 downto 0);
	signal sig_opcod_o : std_logic_vector (6 downto 0);	
	signal sig_func7_o : std_logic_vector (6 downto 0);		
	signal sig_func3_o : std_logic_vector (2 downto 0);	

begin
	
	process (instr_i)
	begin
		--assign incoming instr_i to internal signal
			sig_instr   <= instr_i;
			sig_func7_o <= instr_i(31 downto 25);	
			sig_rs2_o   <= instr_i(24 downto 20);
			sig_rs1_o   <= instr_i(19 downto 15);	
			sig_func3_o <= instr_i(14 downto 12);
			sig_rd_o    <= instr_i(11 downto 7);		
			sig_opcod_o <= instr_i(6 downto 0);	

	end process;

	
	process (sig_instr)

	begin
		--decode or split instruction into sub-parts
		case (sig_opcod_o) is
				
			when "0010011" => --i-type
				sig_imm_o <= std_logic_vector(sig_instr(31 downto 20));

			when "0000011" => --load word (lw) 
				sig_imm_o <= std_logic_vector(sig_instr(31 downto 20));

			when "0100011" => --store word (sw) 
				sig_imm_sh <= std_logic_vector (sig_instr(31 downto 25) & sig_instr(11 downto 7)); 

			when "1100011" => --branch (beq, blt, bge) 
				sig_imm_o <= std_logic_vector (sig_instr(31) & sig_instr(7) & sig_instr(30 downto 25) & sig_instr(11 downto 8));

			when "0110111" => --LUI 
				sig_imm_lui <= std_logic_vector (sig_instr(31 downto 12));

			when others => null; --implement other instructions down here (No Jump implementation)
				sig_imm_o <= std_logic_vector(sig_instr(31 downto 20));
		end case;

	end process;

		rs1_o	<= sig_rs1_o;	
		rs2_o	<= sig_rs2_o;	
		rd_o	<= sig_rd_o;		
		imm_o	<= sig_imm_o;	
		imm_sh  <= sig_imm_sh;
		imm_lui	<= sig_imm_lui;
		opcod_o	<= sig_opcod_o;	
		func7_o	<= sig_func7_o;			
		func3_o	<= sig_func3_o;	

end Behavioral;
