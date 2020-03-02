--------------------------------------------------------------------------------
--file: controlUnit.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlUnit is
	port(	
		--inputs
		opcode 	: in  std_logic_vector(6 downto 0); --instruction(6 downto 0)
		--outputs
		regdst	: out std_logic;
		immsrc	: out std_logic;
		branch	: out std_logic;
		memread : out std_logic;
		memtoreg: out std_logic;
		aluop	: out std_logic;
		memwrite: out std_logic;
		alusrc	: out std_logic;
		regwrite: out std_logic
	);
end controlUnit;

architecture Behavioral of controlUnit is   

		signal s_regdst	  : std_logic;
		signal s_branch	  : std_logic;
		signal s_memread  : std_logic;
		signal s_memtoreg : std_logic;
		signal s_aluop	  : std_logic;
		signal s_memwrite : std_logic;
		signal s_alusrc	  : std_logic;
		signal s_regwrite : std_logic;   
		signal s_immsrc	  : std_logic;      

begin
		process (opcode)
		begin
			
		case opcode is
			when "0110011" => --and, or, add, sub, slt : 0x00
				s_regdst	<= '1';
				s_immsrc  	<= '0';
				s_branch	<= '0';
				s_memread 	<= '0';
				s_memtoreg 	<= '0';
				s_aluop		<= '1';
				s_memwrite	<= '0';
				s_alusrc	<= '0';
				s_regwrite	<= '1'; 
			when "0010011" => --addi
				s_regdst	<= '0';
				s_immsrc  	<= '0';
				s_branch	<= '0';
				s_memread 	<= '0';
				s_memtoreg 	<= '0';
				s_aluop		<= '1';
				s_memwrite	<= '0';
				s_alusrc	<= '1';
				s_regwrite 	<= '1';          
			when "0000011" => --load word (lw)  
				s_regdst	<= '1';
				s_immsrc  	<= '0';
				s_branch	<= '0';
				s_memread 	<= '1';
				s_memtoreg	<= '1';
				s_aluop		<= '1';
				s_memwrite	<= '0';
				s_alusrc	<= '1';
				s_regwrite 	<= '1'; 
			when "0100011" => --store word (sw) : 0x2b
				s_regdst	<= 'X'; --don't care
				s_immsrc  	<= '0';
				s_branch	<= '0';
				s_memread 	<= '0';
				s_memtoreg	<= 'X'; --don't care
				s_aluop		<= '1';
				s_memwrite	<= '1';
				s_alusrc	<= '1';
				s_regwrite 	<= '0';
			when "1100011" => --branch equal (beq)  
				s_regdst	<= 'X'; --don't care
				s_immsrc  	<= '0';
				s_branch	<= '1'; 
				s_memread	<= '0';
				s_memtoreg	<= 'X'; --don't care
				s_aluop		<= '1';
				s_memwrite	<= '0';
				s_alusrc	<= '0';
				s_regwrite	<= '0';
			when "0110111" => --load upper immediate
				s_regdst	<= '1'; 
				s_immsrc  	<= '1';
				s_branch	<= '0'; 
				s_memread	<= '0';
				s_memtoreg	<= '0'; 
				s_aluop		<= '1';
				s_memwrite	<= '0';
				s_alusrc	<= '1';
				s_regwrite	<= '1';
			when others => null; --implement other instructions down here
				s_regdst	<= '0';
				s_immsrc  	<= '0';
				s_branch	<= '0';
				s_memread 	<= '0';
				s_memtoreg	<= '0';
				s_aluop		<= '0';
				s_memwrite	<= '0';
				s_alusrc	<= '0';
				s_regwrite 	<= '0';
		end case;
		
 
		end process;
		--Connect internal signals to output signals
		regdst	  <= s_regdst;	
		branch	  <= s_branch;
		memread   <= s_memread;
		memtoreg  <= s_memtoreg;
		aluop	  <= s_aluop;
		memwrite  <= s_memwrite;
		alusrc	  <= s_alusrc;
		immsrc	  <= s_immsrc;
		regwrite  <= s_regwrite;

end Behavioral;