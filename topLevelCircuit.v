`include "defines.v"

module MIPS_Processor (input CLOCK_50, input rst, input forward_EN);
	wire clock = CLOCK_50;
	wire [`WORD_LEN-1:0] PC_IF, PC_ID, PC_EXE, PC_MEM;
	wire [`WORD_LEN-1:0] inst_IF, inst_ID,inst_EXE, inst_MEM;
	wire [`WORD_LEN-1:0] reg1_ID, reg2_ID, ST_value_EXE, ST_value_EXE2MEM, ST_value_MEM;
	wire [`WORD_LEN-1:0] val1_ID, val1_EXE, val1_MEM, val1_WB;
	wire [`WORD_LEN-1:0] val2_ID, val2_EXE;
	wire [`WORD_LEN-1:0] ALURes_EXE, ALURes_MEM, ALURes_WB;
	wire [`WORD_LEN-1:0] dataMem_out_MEM, dataMem_out_WB;
	wire [`WORD_LEN-1:0] WB_result;
	wire [`REG_FILE_ADDR_LEN-1:0] dest_EXE, dest_MEM; // dest_ID = instruction[25:21] thus nothing declared
	wire [`REG_FILE_ADDR_LEN-1:0] src1_ID, src2_regFile_ID, src2_forw_ID, src2_forw_EXE, src1_forw_EXE;
	wire [`EXE_CMD_LEN-1:0] EXE_CMD_ID, EXE_CMD_EXE;
	wire [`FORW_SEL_LEN-1:0] val1_sel, val2_sel, ST_val_sel;
	wire [1:0] branch_comm;
	wire Br_Taken_ID, IF_Flush, Br_Taken_EXE;
	wire MEM_R_EN_ID, MEM_R_EN_EXE, MEM_R_EN_MEM, MEM_R_EN_WB;
	wire MEM_W_EN_ID, MEM_W_EN_EXE, MEM_W_EN_MEM;
	wire WB_EN_ID, WB_EN_EXE, WB_EN_MEM, WB_EN_WB;
	wire hazard_detected, is_imm, ST_or_BNE;
	wire [`REG_FILE_ADDR_LEN-1:0] wire_customdest1;
	wire [`REG_FILE_ADDR_LEN-1:0] wire_customdest2;
	wire [`REG_FILE_ADDR_LEN-1:0] wire_customdest3;
	wire [`REG_FILE_ADDR_LEN-1:0] wire_customdest4;
	wire [7:0] SLLAmount;
	wire jumpEnable, BNE_Enable;
	wire add_base_ID,add_base_EXE,add_base_MEM, add_base_WB;

	regFile regFile(
		// INPUTS
		.clk(clock),
		.rst(rst),
		.src1(src1_ID),
		.src2(src2_regFile_ID),
		.dest(wire_customdest4),
		.writeVal(WB_result),
		.writeEn(WB_EN_WB),
		.custominstruction(inst_ID),
		// OUTPUTS
		.reg1(reg1_ID),
		.reg2(reg2_ID)
		
	);

	hazard_detection hazard (
		// INPUTS
		.forward_EN(forward_EN),
		.is_imm(is_imm),
		.ST_or_BNE(ST_or_BNE),
		.src1_ID(src1_ID),
		.src2_ID(src2_regFile_ID),
		.dest_EXE(dest_EXE),
		.dest_MEM(dest_MEM),
		.WB_EN_EXE(WB_EN_EXE),
		.WB_EN_MEM(WB_EN_MEM),
		.MEM_R_EN_EXE(MEM_R_EN_EXE),
		.is_add_base(add_base_ID),
		// OUTPUTS
		.branch_comm(branch_comm),
		.hazard_detected(hazard_detected)
	);

	forwarding_EXE forwrding_EXE (
		.src1_EXE(src1_forw_EXE),
		.src2_EXE(src2_forw_EXE),
		.ST_src_EXE(dest_EXE),
		.dest_MEM(dest_MEM),
		.dest_WB(wire_customdest4),
		.WB_EN_MEM(WB_EN_MEM),
		.WB_EN_WB(WB_EN_WB),
		.val1_sel(val1_sel),
		.val2_sel(val2_sel),
		.ST_val_sel(ST_val_sel)
	);

	//###########################
	//##### PIPLINE STAGES ######
	//###########################
	IFStage IFStage (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.jumpEnable(jumpEnable),
		.freeze(hazard_detected),
		.brTaken(Br_Taken_ID),
		.brOffset(val2_ID),
		// OUTPUTS
		.instruction(inst_IF),
		.PC(PC_IF)
	);

	IDStage IDStage (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.hazard_detected_in(hazard_detected),
		.instruction(inst_ID),
		.reg1(reg1_ID),
		.reg2(reg2_ID),
		// OUTPUTS
		.jumpEnable(jumpEnable),
		.src1(src1_ID),
		.src2_reg_file(src2_regFile_ID),
		.src2_forw(src2_forw_ID),
		.val1(val1_ID),
		.val2(val2_ID),
		.brTaken(Br_Taken_ID),
		.EXE_CMD(EXE_CMD_ID),
		.MEM_R_EN(MEM_R_EN_ID),
		.MEM_W_EN(MEM_W_EN_ID),
		.WB_EN(WB_EN_ID),
		.is_imm_out(is_imm),
		.ST_or_BNE_out(ST_or_BNE),
		.branch_comm(branch_comm),
		.customdest(wire_customdest1),
		.SLLAmount(SLLAmount),
		.is_add_base(add_base_ID)
	);

	EXEStage EXEStage (
		// INPUTS
		.SLLAmount(SLLAmount),
		.clk(clock),
		.EXE_CMD(EXE_CMD_EXE),
		.val1_sel(val1_sel),
		.val2_sel(val2_sel),
		.ST_val_sel(ST_val_sel),
		.val1(val1_EXE),
		.val2(val2_EXE),
		.ALU_res_MEM(ALURes_MEM),
		.result_WB(WB_result),
		.ST_value_in(ST_value_EXE),
		// OUTPUTS
		.ALUResult(ALURes_EXE),
		.ST_value_out(ST_value_EXE2MEM)
	);

	MEMStage MEMStage (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.MEM_R_EN(MEM_R_EN_MEM),
		.MEM_W_EN(MEM_W_EN_MEM),
		.ALU_res(ALURes_MEM),
		.ST_value(ST_value_MEM),
		.PC(PC_MEM),
		.instructionIn(inst_MEM),
		// OUTPUTS
		.dataMem_out(dataMem_out_MEM)
	);

	WBStage WBStage (
		// INPUTS
		.clk(clock),
		.MEM_R_EN(MEM_R_EN_WB),
		.memData(dataMem_out_WB),
		.aluRes(ALURes_WB),
		.val1In(val1_WB),
		.add_base_in(add_base_WB),
		// OUTPUTS
		.WB_res(WB_result)
	);

	//############################
	//#### PIPLINE REGISTERS #####
	//############################
	IF2ID IF2IDReg (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.flush(IF_Flush),
		.freeze(hazard_detected),
		.PCIn(PC_IF),
		.instructionIn(inst_IF),
		// OUTPUTS
		.PC(PC_ID),
		.instruction(inst_ID)
	);

	ID2EXE ID2EXEReg (
		.clk(clock),
		.rst(rst),
		// INPUTS
		.destIn(inst_ID[11:8]),
		.src1_in(src1_ID),
		.src2_in(src2_forw_ID),
		.reg2In(reg2_ID),
		.val1In(val1_ID),
		.val2In(val2_ID),
		.PCIn(PC_ID),
		.EXE_CMD_IN(EXE_CMD_ID),
		.MEM_R_EN_IN(MEM_R_EN_ID),
		.MEM_W_EN_IN(MEM_W_EN_ID),
		.WB_EN_IN(WB_EN_ID),
		.brTaken_in(Br_Taken_ID),
		.customdestin(wire_customdest1),
		.instructionIn(inst_ID),
		.add_base_in(add_base_ID),
		// OUTPUTS
		.customdest(wire_customdest2),
		.src1_out(src1_forw_EXE),
		.src2_out(src2_forw_EXE),
		.dest(dest_EXE),
		.ST_value(ST_value_EXE),
		.val1(val1_EXE),
		.val2(val2_EXE),
		.PC(PC_EXE),
		.EXE_CMD(EXE_CMD_EXE),
		.MEM_R_EN(MEM_R_EN_EXE),
		.MEM_W_EN(MEM_W_EN_EXE),
		.WB_EN(WB_EN_EXE),
		.brTaken_out(Br_Taken_EXE),
		.instructionOut(inst_EXE),
		.add_base_out(add_base_EXE)
		
	);

	EXE2MEM EXE2MEMReg (
		.clk(clock),
		.rst(rst),
		// INPUTS
		.WB_EN_IN(WB_EN_EXE),
		.MEM_R_EN_IN(MEM_R_EN_EXE),
		.MEM_W_EN_IN(MEM_W_EN_EXE),
		.PCIn(PC_EXE),
		.ALUResIn(ALURes_EXE),
		.STValIn(ST_value_EXE2MEM),
		.destIn(dest_EXE),
		.customdestin(wire_customdest2),
		.instructionIn(inst_EXE),
		.val1In(val1_EXE),
		.add_base_in(add_base_EXE),
		// OUTPUTS
		.customdest(wire_customdest3),
		.WB_EN(WB_EN_MEM),
		.MEM_R_EN(MEM_R_EN_MEM),
		.MEM_W_EN(MEM_W_EN_MEM),
		.PC(PC_MEM),
		.ALURes(ALURes_MEM),
		.STVal(ST_value_MEM),
		.dest(dest_MEM),
		.instructionOut(inst_MEM),
		.val1Out(val1_MEM),
		.add_base_out(add_base_MEM)
	);

	MEM2WB MEM2WB(
		.clk(clock),
		.rst(rst),
		// INPUTS
		.WB_EN_IN(WB_EN_MEM),
		.MEM_R_EN_IN(MEM_R_EN_MEM),
		.ALUResIn(ALURes_MEM),
		.memReadValIn(dataMem_out_MEM),
		.destIn(dest_MEM),
		.customdestin(wire_customdest3),
		.add_base_in(add_base_MEM),
		.val1In(val1_MEM),
		// OUTPUTS
		.WB_EN(WB_EN_WB),
		.MEM_R_EN(MEM_R_EN_WB),
		.ALURes(ALURes_WB),
		.memReadVal(dataMem_out_WB),
		.dest(wire_customdest4),
		.add_base_out(add_base_WB),
		.val1Out(val1_WB)
	);

	assign IF_Flush = Br_Taken_ID;
endmodule
