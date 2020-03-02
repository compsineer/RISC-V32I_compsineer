--------------------------------------------------------------------------------
--file: controlPath.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.riscv_lib.all;

entity controlPath is
	port(
		--inputs
		opcode_i      : in std_logic_vector(6 downto 0); --receives opcode from decoder
		funct7_i      : in std_logic_vector(6 downto 0);
		funct3_i      : in std_logic_vector(2 downto 0);
		--outputs
		regdst_o      : out std_logic;
		immsrc_o      : out std_logic;
		branch_o      : out std_logic;
		memread_o     : out std_logic;
		memtoreg_o    : out std_logic;
		memwrite_o    : out std_logic;
		alusrc_o      : out std_logic;
		regwrite_o    : out std_logic;
		alucontrol_o  : out instruction
		);
end controlPath;

architecture Behavioral of controlPath is 

		signal sig_opcode     : std_logic_vector (6 downto 0);
		signal sig_regdst     : std_logic;  
		signal sig_immsrc     : std_logic;
		signal sig_branch     : std_logic; 
		signal sig_memread    : std_logic;
		signal sig_memtoreg   : std_logic;
		signal sig_aluop      : std_logic;
		signal sig_memwrite   : std_logic;
		signal sig_alusrc     : std_logic;
		signal sig_regwrite   : std_logic;
		signal sig_aluopr     : std_logic; ---alu control signals begin here 
		signal sig_op_code     : std_logic_vector(6 downto 0);
		signal sig_funct7     : std_logic_vector(6 downto 0);
		signal sig_funct3     : std_logic_vector(2 downto 0);
		signal sig_alucontrol : instruction;

begin
	CU_ADD: entity work.controlUnit (Behavioral)
	port map(
		opcode	 => sig_opcode,
		regdst	 => sig_regdst,
		immsrc	 => sig_immsrc,
		branch	 => sig_branch,
		memread  => sig_memread,
		memtoreg => sig_memtoreg,
		aluop	 => sig_aluop,
		memwrite => sig_memwrite,
		alusrc	 => sig_alusrc,
		regwrite => sig_regwrite
	);
	ALU_CTRL_ADD: entity work.aluControl (Behavioral)
	port map(
		aluop 	   => sig_aluopr,
		op_code    => sig_op_code,
		funct7     => sig_funct7,
		funct3     => sig_funct3,
		alucontrol => sig_alucontrol
	);
	
	--connect internal signals to input
	sig_opcode <= opcode_i; --picks the opcode from decoder
	sig_op_code <= opcode_i;--opcode goes into alu control
	sig_funct7 <= funct7_i; --funct7 from decoder into alu control
	sig_funct3 <= funct3_i; --funct3 from decoder into alu control
	sig_aluopr <= sig_aluop; --receives aluop from the control unit
	
	--connect internal signals to output
	regdst_o      <= sig_regdst;
	branch_o      <= sig_branch;
	memread_o     <= sig_memread;
	memtoreg_o    <= sig_memtoreg;
	memwrite_o    <= sig_memwrite;
	alusrc_o      <= sig_alusrc;
	regwrite_o    <= sig_regwrite;
	immsrc_o      <= sig_immsrc;
	alucontrol_o  <= sig_alucontrol;	
	

end Behavioral;
