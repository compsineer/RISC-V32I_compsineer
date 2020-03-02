--------------------------------------------------------------------------------
--file: risc5_core.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.riscv_lib.all;

entity risc5_core is
	port(
		--inputs
		clk_i	  : in std_logic; 
		reset_i   : in std_logic;
		instr_i   : in std_logic_vector(31 downto 0); --receives from instruction mememory	
		rd_data_i : in std_logic_vector(31 downto 0); --read from data memory
		--outputs
		prcount_o : out std_logic_vector(31 downto 0); --into instruction memory
		mem_wri_o : out std_logic;
		memo_rd_o : out std_logic;
		alu_out_o : out std_logic_vector(31 downto 0);
		rd_data2_o: out std_logic_vector(31 downto 0) --read from register file read data 2
	);
end risc5_core;

architecture Behavioral of risc5_core is

	--Control path signal assignments
		signal sg_funct7_i      : std_logic_vector(6 downto 0);
		signal sg_funct3_i      : std_logic_vector(2 downto 0);
		signal sg_regdst_o      : std_logic;
		signal sg_immsrc_o      : std_logic;
		signal sg_branch_o      : std_logic;
		signal sg_memread_o     : std_logic;
		signal sg_memtoreg_o    : std_logic;
		signal sg_memwrite_o    : std_logic;
		signal sg_alusrc_o      : std_logic;
		signal sg_regwrite_o    : std_logic;
		signal sg_alucontrol_o  : instruction;	
		signal sg_opcode_i	: std_logic_vector (6 downto 0);
	--Data path signal assignments
		signal sg_clk_i		: std_logic;
		signal sg_rest_i	: std_logic;
		signal sg_memo_to_reg_i	: std_logic;
		signal sg_reg_wr_i	: std_logic;
		signal sg_branching	: std_logic;
		signal sg_reg_dst_i	: std_logic;
		signal sg_alusrc_i	: std_logic;
		signal sg_immsrc_i	: std_logic;
		signal sg_alucontrol_i	: instruction;
		signal sg_instru_i	: std_logic_vector(31 downto 0);
		signal sg_dm_rd_data_i	: std_logic_vector(31 downto 0);
		signal sg_prg_counter	: std_logic_vector (31 downto 0);
		signal sg_alu_out	: std_logic_vector (31 downto 0);
		signal sg_read_data2	: std_logic_vector (31 downto 0);
		signal sg_op_code	: std_logic_vector (6 downto 0);
		signal sg_funct_7	: std_logic_vector (6 downto 0); --to alu control
		signal sg_funct_3 	: std_logic_vector (2 downto 0); --to alu control

begin
	Ctrl_Path_add: entity work.controlPath (Behavioral)
	port map(
		opcode_i      => sg_opcode_i,
		funct7_i      => sg_funct7_i,
		funct3_i      => sg_funct3_i,
		regdst_o      => sg_regdst_o,
		immsrc_o      => sg_immsrc_o,
		branch_o      => sg_branch_o,
		memread_o     => sg_memread_o,
		memtoreg_o    => sg_memtoreg_o,
		memwrite_o    => sg_memwrite_o,
		alusrc_o      => sg_alusrc_o,
		regwrite_o    => sg_regwrite_o,
		alucontrol_o  => sg_alucontrol_o	
	);
	Data_Path_add: entity work.dataPath (Behavioral)
	port map(
		clk_i		=> sg_clk_i,
		rest_i		=> sg_rest_i,
		memo_to_reg_i	=> sg_memo_to_reg_i,
		branching	=> sg_branching,
		reg_dst_i	=> sg_reg_dst_i,
		alusrc_i	=> sg_alusrc_i,
		reg_wr_i	=> sg_reg_wr_i,
		immsrc_i	=> sg_immsrc_i,
		alucontrol_i	=> sg_alucontrol_i,
		instru_i	=> sg_instru_i,
		dm_rd_data_i	=> sg_dm_rd_data_i,
		prg_counter	=> sg_prg_counter,
		alu_out		=> sg_alu_out,
		read_data2	=> sg_read_data2,
		op_code		=> sg_op_code,
		funct_7		=> sg_funct_7,
		funct_3 	=> sg_funct_3
	);	
		--Connect input signals
		sg_clk_i <= clk_i;
		sg_rest_i <= reset_i;
		sg_funct7_i <= sg_funct_7; --receives funct7 from decoder into the control path
		sg_funct3_i <=  sg_funct_3; --receives funct3 from decoder into the control path
		sg_dm_rd_data_i  <= rd_data_i; --receives data read from data memory

		--Connect internal signals
		sg_reg_dst_i <= sg_regdst_o; --register multiplexor control
		sg_branching <= sg_branch_o; --and gate branch signal	
		sg_memo_to_reg_i <=sg_memtoreg_o; --write back multiplexor control
		sg_alusrc_i <= sg_alusrc_o; --alu multiplexor control
		sg_reg_wr_i <= sg_regwrite_o; --register file write signal
		sg_immsrc_i <= sg_immsrc_o; --immediate multiplexor control signal
		sg_alucontrol_i <= sg_alucontrol_o; --alu control signal

		--Connect output signals
		mem_wri_o  <= sg_memwrite_o; --data memory write signal 
		memo_rd_o  <= sg_memread_o; --data memory read signal
		prcount_o  <= sg_prg_counter;
		alu_out_o  <= sg_alu_out;
		rd_data2_o <= sg_read_data2; 
		sg_opcode_i<= sg_op_code; --from decoder to control unit	
		sg_instru_i<=instr_i;	                    

end Behavioral;
