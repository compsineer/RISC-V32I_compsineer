--file: dataPath.vhd
--date: 2/2020
--author: Kwame Owusu Ampadu
--email: KwameOwusu.Ampadu@b-tu.de
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.riscv_lib.all;

entity dataPath is 
	port(
		--inputs
		clk_i		: in std_logic;
		rest_i		: in std_logic;

		memo_to_reg_i	: in std_logic; --write back multiplexor control
		branching	: in std_logic; --to branch gate
		reg_dst_i	: in std_logic; --destination register multiplexor control
		alusrc_i	: in std_logic; --alu multiplexor control
		reg_wr_i	: in std_logic; --to write to register file
		immsrc_i	: in std_logic; --immediate multiplexor control

		alucontrol_i	: in instruction; --from alu control
		instru_i	: in std_logic_vector(31 downto 0); --from instruction memory
		dm_rd_data_i	: in std_logic_vector(31 downto 0); --data memory read data
		--outputs
		op_code		: out std_logic_vector (6 downto 0); --to control path
		funct_7		: out std_logic_vector (6 downto 0); --to alu control
		funct_3 	: out std_logic_vector (2 downto 0); --to alu control
		prg_counter	: out std_logic_vector (31 downto 0); --to instruction memory
		alu_out		: out std_logic_vector (31 downto 0); --to data memory address
		read_data2	: out std_logic_vector (31 downto 0) --read register 2 data
		
		
	);
end dataPath;

architecture Behavioral of dataPath is 
		signal sig_clk_i     : std_logic;
		signal sig_rset_i    : std_logic;
		signal sig_pc_next   : std_logic_vector(31 downto 0);
		signal sig_pc_current: std_logic_vector(31 downto 0);
		-------------------------------------------------------------programcounter
		signal sig_pcg_current: std_logic_vector(31 downto 0);
		signal sig_pcplus4_o  : std_logic_vector(31 downto 0);
		-------------------------------------------------------------adder one
		signal sig_instr_i	: std_logic_vector (31 downto 0);
		signal sig_rs1_o	: std_logic_vector (4 downto 0);		
		signal sig_rs2_o	: std_logic_vector (4 downto 0);	
		signal sig_rd_o		: std_logic_vector (4 downto 0);		
		signal sig_imm_o	: std_logic_vector (11 downto 0);	
		signal sig_imm_sh  	: std_logic_vector (11 downto 0);	
		signal sig_imm_lui 	: std_logic_vector (19 downto 0);
		signal sig_opcod_o	: std_logic_vector (6 downto 0);	
		signal sig_func7_o	: std_logic_vector (6 downto 0);		
		signal sig_func3_o	: std_logic_vector (2 downto 0);
		-------------------------------------------------------------decoder
		signal sig_rs2_i0	: ieee.numeric_std.unsigned(4 downto 0);
		signal sig_dst_reg_i1	: ieee.numeric_std.unsigned(4 downto 0);
		signal sig_rg_dst	: std_logic;
		signal sig_wr_dst_o	: ieee.numeric_std.unsigned(4 downto 0);
		-------------------------------------------------------------register multiplexor
		signal sig_se_i 	: std_logic_vector(11 downto 0);
		signal sig_se_lui	: std_logic_vector (19 downto 0);
		signal sig_se_sh	: std_logic_vector (11 downto 0);
		signal sig_se_o 	: std_logic_vector(31 downto 0);
		signal sig_se_lui_o	: std_logic_vector (31 downto 0);
		signal sig_se_sh_o 	: std_logic_vector (31 downto 0); 
		-------------------------------------------------------------sign extender
		signal sig_clck_i      : std_logic;
     		signal sig_rst_i       : std_logic;
     		signal sig_rd_addr1_i  : ieee.numeric_std.unsigned(4 downto 0);
     		signal sig_rd_addr2_i  : ieee.numeric_std.unsigned(4 downto 0);
     		signal sig_wri_data_i  : std_logic_vector(31 downto 0);
      		signal sig_wr_addr_i   : ieee.numeric_std.unsigned(4 downto 0);
      		signal sig_wr_en_i     : std_logic;
     		signal sig_reg_data1_o : std_logic_vector(31 downto 0);
      		signal sig_reg_data2_o : std_logic_vector(31 downto 0);
		-------------------------------------------------------------register file
		signal sig_rd_data2_i0	: std_logic_vector(31 downto 0);
		signal sig_from_se_imm	: std_logic_vector(31 downto 0);
		signal sig_alusrc_ctrl	: std_logic;
		signal sig_mux_in2_o	: std_logic_vector(31 downto 0);
		-------------------------------------------------------------alu multiplexor
		signal sig_in1 	    : std_logic_vector(31 downto 0);
     		signal sig_in2 	    : std_logic_vector(31 downto 0);   
     		signal sig_alu_ctrl : instruction;
     		signal sig_output   : std_logic_vector(31 downto 0);
   		signal sig_zero     : std_logic;
     		signal sig_gte      : std_logic;
     		signal sig_lt       : std_logic;
		-------------------------------------------------------------alu
		signal sig_from_alu_i0	 : std_logic_vector(31 downto 0);	
		signal sig_mem_rd_data_i1: std_logic_vector(31 downto 0);
		signal sig_mem_to_reg_i	 : std_logic;
		signal sig_mux_wr_data_o : std_logic_vector(31 downto 0);
		-------------------------------------------------------------write back multiplexor
		signal sig_from_se_sh 	: std_logic_vector(31 downto 0);
		signal sig_to_adder 	: std_logic_vector(31 downto 0);
		-------------------------------------------------------------shift left one
		signal sig_from_sh : std_logic_vector (31 downto 0);
		signal sig_from_pc : std_logic_vector (31 downto 0);
		signal sig_adder_o : std_logic_vector (31 downto 0);
		-------------------------------------------------------------adder two
		signal sig_branch_i : std_logic;
		signal sig_zero_i   : std_logic;
     		signal sig_gt_i     : std_logic;
     		signal sig_lt_i     : std_logic;
   		signal sig_gate_o   : std_logic;
		-------------------------------------------------------------and gate
		signal sig_fr_pcplus4_i0: std_logic_vector(31 downto 0);
		signal sig_fr_adder2_i1	: std_logic_vector(31 downto 0);
		signal sig_fr_n_gate_i	: std_logic;
		signal sig_pcbr_mux_o	: std_logic_vector(31 downto 0);
		-------------------------------------------------------------branch multiplexor
		signal sig_frm_seo_imm	  : std_logic_vector(31 downto 0);
		signal sig_frm_seo_lui	  : std_logic_vector(31 downto 0);
		signal sig_imux_ctrl_code : std_logic;
		signal sig_alu_mux_in2_o  : std_logic_vector(31 downto 0);
		-------------------------------------------------------------sign extend multiplexor
                     

begin
	PC_ADD: entity work.programcounter (Behavioral)
	port map(
		clk_i 	   => sig_clk_i,
		rset_i 	   => sig_rset_i,
		pc_next	   => sig_pc_next,
		pc_current => sig_pc_current
	);
	ADDER1_ADD: entity work.adderOne (Behavioral)
	port map(
		pc_current => sig_pcg_current,
		pcplus4_o => sig_pcplus4_o
	);
	
	DCode_ADD: entity work.decoder (Behavioral)
	port map(
		instr_i	=> sig_instr_i,
		rs1_o	=> sig_rs1_o,	
		rs2_o	=> sig_rs2_o,
		rd_o	=> sig_rd_o,	
		imm_o	=> sig_imm_o,	
		imm_sh  => sig_imm_sh,	
		imm_lui => sig_Imm_lui,
		opcod_o	=> sig_opcod_o,
		func7_o	=> sig_func7_o,	
		func3_o	=> sig_func3_o
	);
	REG_MUX_ADD: entity work.reg_mux (Behavioral)
	port map(
		rs2_i0		=> sig_rs2_i0,
		dst_reg_i1	=> sig_dst_reg_i1,
		rg_dst		=> sig_rg_dst,
		wr_dst_o	=> sig_wr_dst_o
	);
	SE_ADD: entity work.signextend (Behavioral)
	port map (
		se_i	 => sig_se_i,
		se_lui	 => sig_se_lui,
		se_sh	 => sig_se_sh,
		se_o	 => sig_se_o,
		se_lui_o => sig_se_lui_o,
		se_sh_o  => sig_se_sh_o 
	);
	REG_FILE_ADD: entity work.regfile (Behavioral)
	port map (
		clk_i => sig_clck_i,
     		rst_i => sig_rst_i,
     		rd_addr1_i => sig_rd_addr1_i,
     		rd_addr2_i => sig_rd_addr2_i,
     		wr_data_i  => sig_wri_data_i,
      		wr_addr_i => sig_wr_addr_i,
      		wr_en_i   => sig_wr_en_i,
     		reg_data1_o => sig_reg_data1_o,
      		reg_data2_o => sig_reg_data2_o
	);
	ALU_MUX_ADD: entity work.alusrc_mux (Behavioral)
	port map(
		rd_data2_i0	=> sig_rd_data2_i0,
		from_se_imm	=> sig_from_se_imm,
		alusrc_ctrl	=> sig_alusrc_ctrl,
		mux_in2_o	=> sig_mux_in2_o
	);
	ALU_ADD: entity work.ALU (Behavioral)
	port map(
		in1 => sig_in1,
     		in2 => sig_in2, 
     		alu_ctrl => sig_alu_ctrl,
     		output => sig_output,
   		zero   => sig_zero,
     		gte    => sig_gte,
     		lt     => sig_lt
	);
	WRBACK_MUX_ADD: entity work.wrback_mux (Behavioral)
	port map(
		from_alu_i0	=> sig_from_alu_i0,
		mem_rd_data_i1	=> sig_mem_rd_data_i1,
		mem_to_reg_i	=> sig_mem_to_reg_i, 
		mux_wr_data_o	=> sig_mux_wr_data_o
	);
	SHFLFT_ADD: entity work.shiftLeftOne (Behavioral)
	port map(
		from_se_sh  => sig_from_se_sh,
		to_adder => sig_to_adder
	);
	ADDER2_ADD: entity work.adder (Behavioral)
	port map(
		from_se => sig_from_sh,
		from_pc => sig_from_pc,
		adder_o => sig_adder_o
	);
	BRNCH_GATE_ADD: entity work.branchGate (Behavioral)
	port map(
		branch_i => sig_branch_i,
		zero_i   => sig_zero_i,
     		gt_i     => sig_gt_i,
     		lt_i     => sig_lt_i,
  		gate_o   => sig_gate_o
	);
	BRNCH_MUX_ADD: entity work.pcbranch_mux (Behavioral)
	port map(
		fr_pcplus4_i0	=> sig_fr_pcplus4_i0,
		fr_adder2_i1	=> sig_fr_adder2_i1,
		fr_n_gate_i	=> sig_fr_n_gate_i,
		pcbr_mux_o	=> sig_pcbr_mux_o
	);
	SE_MUX_ADD: entity work.imm_mux (Behavioral)
	port map(
		frm_seo_imm	=> sig_frm_seo_imm,
		frm_seo_lui	=> sig_frm_seo_lui,
		imux_ctrl_code	=> sig_imux_ctrl_code,
		alu_mux_in2_o	=> sig_alu_mux_in2_o
	);

	--connect input to signals  
	sig_instr_i <= instru_i; --from instruction memory
	sig_rg_dst <= reg_dst_i; --register multiplexor control comes in
	sig_se_i <= sig_imm_o;	 --sign extender receives immediate address
	
	sig_wr_addr_i	<= sig_wr_dst_o; --set register destination address from reg mux
	sig_rd_addr1_i	<= ieee.numeric_std.unsigned(sig_rs1_o);    --set source register
	sig_rd_addr2_i	<= ieee.numeric_std.unsigned(sig_rs2_o);    --set transfer register

	sig_in1 <= sig_reg_data1_o;	    --alu receives source data (rs1)
	sig_rd_data2_i0	<= sig_reg_data2_o; --alu source multiplexor receives transfer data (rs2)

	sig_alusrc_ctrl <= alusrc_i;	    --alu source multiplexor receives control signal
	sig_in2 <= sig_mux_in2_o;	    --alu receives source multiplexor output

	sig_se_sh <= sig_imm_sh; --Connect immediate signals to sign extender
	sig_se_lui <= sig_Imm_lui;
	sig_from_alu_i0 <= sig_output;	     --write back multiplexor receives alu output
	sig_mem_rd_data_i1 <= dm_rd_data_i;  --write back multiplexor receives memory read data
	sig_mem_to_reg_i <= memo_to_reg_i;   --write back multiplexor receives control signal
	sig_wri_data_i <= sig_mux_wr_data_o ; -- register file receives write back multiplexor output

	sig_branch_i <= branching; --and gate receives branch signal from control unit
	sig_zero_i  <= sig_zero;   --and gate receives zero signal from alu
     	sig_gt_i    <= sig_gte;	   --and gate receives "greater than" signal from alu
     	sig_lt_i    <= sig_lt;     --and gate receives "less than" signal from alu
    
	sig_from_se_sh <= sig_se_sh_o ; --shift left one receives sign extended immediate short value [shift left two in mips]

	sig_pcg_current <= sig_pc_current; --adder one receives current address and generates "pc+4"

	--Adder2
	sig_from_sh <= sig_to_adder; --adder two receives output of shift left one [shift left2 in mips but shift left1 in riscv]
	sig_from_pc <= sig_pc_current; --adder two receives current address [mips uses pc + 4]

	--pcbranch_mux
	sig_fr_pcplus4_i0 <= sig_pcplus4_o;   --pc branch multiplexor receives "pc+4" from adder one, sig_pcplus4_o
	sig_fr_adder2_i1 <= sig_adder_o; --pc branch multiplexor receives output of adder two
	sig_fr_n_gate_i	 <= sig_gate_o;  --pc branch multiplexor receives control signal from and gate

	sig_pc_next <= sig_pcbr_mux_o; --branch mux output goes into program counter

	--Connect signals to output
	prg_counter <= sig_pc_current; --address to instruction memory
	read_data2  <= sig_reg_data2_o; --register data to store in data memory
	alu_out <= sig_output; --executed result	
	op_code <= sig_opcod_o; --opcode from decoder to the control unit	
	funct_7	<= sig_func7_o; --to alu control
	funct_3 <= sig_func3_o;	--to alu control
	
	--Connect signals to global clock
	sig_clk_i  <= clk_i;
	sig_rset_i <= rest_i;	
	sig_clck_i <= clk_i;
	sig_rst_i  <= rest_i;	
	sig_alu_ctrl <= alucontrol_i;   --alu receives instruction from alu control
	sig_wr_en_i <= reg_wr_i	;	--register file receives write signal from control unit  
	
	--Connect decoder to register multiplexor
	sig_rs2_i0 <= ieee.numeric_std.unsigned(sig_rs2_o);	--receives output of register2 from decoder         
	sig_dst_reg_i1 <= ieee.numeric_std.unsigned(sig_rd_o);  --receives destination register from decoder

	--Sign extender multiplexor
	sig_frm_seo_imm    <= sig_se_o;		--receives immediate value from sign extender into alu src
	sig_frm_seo_lui    <= sig_se_lui_o;	--receives LUI immediate value from sign extender into alu src
	sig_imux_ctrl_code <= immsrc_i;	        --receives immediate source from control unit
	sig_from_se_imm    <= sig_alu_mux_in2_o;--alu src recieves one immediate value from sign extender

end Behavioral;
