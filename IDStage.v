`include "defines.v"

module IDStage (clk,SLLAmount, rst, hazard_detected_in, is_imm_out, ST_or_BNE_out, instruction, reg1, reg2, src1, src2_reg_file, src2_forw, val1, val2, brTaken, EXE_CMD, MEM_R_EN, MEM_W_EN, WB_EN, branch_comm,customdest, jumpEnable);
  input clk, rst, hazard_detected_in;
  input [`WORD_LEN-1:0] instruction, reg1, reg2;
  output brTaken, MEM_R_EN, MEM_W_EN, WB_EN, is_imm_out, ST_or_BNE_out, jumpEnable;
  output [1:0] branch_comm;
  output [`EXE_CMD_LEN-1:0] EXE_CMD;
  output [`REG_FILE_ADDR_LEN-1:0] src1, src2_reg_file, src2_forw;
  output [`WORD_LEN-1:0] val1, val2;
  output [`REG_FILE_ADDR_LEN-1:0] customdest;
  output [7:0] SLLAmount;
  wire CU2and, Cond2and;
  wire [1:0] CU2Cond;
  wire Is_Imm, ST_or_BNE;
  wire [`WORD_LEN-1:0] signExt2Mux;
  wire jumpEnableWire,BNE_EnableWire;
  wire Z_wire;

  controller controller(
    // INPUT
    .opCode(instruction[15:12]),
    .branchEn(CU2and),
    .custominstruction(instruction),
    .src1(reg1),
    .src2(reg2),
    // OUTPUT
    .jumpEnable(jumpEnable),
    .EXE_CMD(EXE_CMD),
    .Branch_command(CU2Cond),
    .Is_Imm(Is_Imm),
    .Z(Z_wire),
    .ST_or_BNE(ST_or_BNE),
    .WB_EN(WB_EN),
    .MEM_R_EN(MEM_R_EN),
    .MEM_W_EN(MEM_W_EN),
    .hazard_detected(hazard_detected_in),
    .clk(clk)
  );

  mux #(.LENGTH(`REG_FILE_ADDR_LEN)) mux_src2 ( // determins the register source 2 for register file
    .in1(instruction[7:4]),
    .in2(instruction[11:8]),
    .sel(ST_or_BNE),
    .out(src2_reg_file)
  );

  mux #(.LENGTH(`WORD_LEN)) mux_val2 ( // determins whether val2 is from the reg file of the immediate value
    .in1(reg2),
    .in2(signExt2Mux),
    .sel(Is_Imm),
    .out(val2)
    
  );

  mux #(.LENGTH(`REG_FILE_ADDR_LEN)) mux_src2_forw ( // determins the register source 2 for forwarding
    .in1(instruction[7:4]), // src2 = instruction[15:11]
    .in2(4'b0),
    .sel(Is_Imm),
    .out(src2_forw)
  );

  signExtend signExtend(
    .in(instruction[7:0]),
    .out(signExt2Mux)
  );

  conditionChecker conditionChecker (
    .Z(Z_wire),
    .reg1(reg1),
    .reg2(reg2),
    .cuBranchComm(CU2Cond),
    .brCond(Cond2and)
  );

  

  assign brTaken = CU2and && Cond2and;
  assign jumpEnable = jumpEnableWire;
  assign val1 = reg1;
  assign src1 = instruction[11:8];
  assign customdest = src1;
  assign is_imm_out = Is_Imm;
  assign ST_or_BNE_out = ST_or_BNE;
  assign branch_comm = CU2Cond;
  assign SLLAmount = signExt2Mux;


  always @(posedge clk) begin
    $display("---------------- ID Stage ----------------");
    $display("brTaken = %b\njumpEnable = %b\nval1 = %b\nval2 = %b\nsrc1 = %b\ncustomdest = %b\nis_imm_out = %b\ninstruction = %b\nreg1 = %b\nreg2 = %b"
            , brTaken,jumpEnable,val1,val2, src1,customdest,is_imm_out, instruction,reg1, reg2);
  end
endmodule // IDStage
