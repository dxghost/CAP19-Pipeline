`include "defines.v"

module controller (opCode, branchEn, EXE_CMD, Branch_command, Is_Imm, ST_or_BNE, WB_EN, MEM_R_EN, MEM_W_EN, hazard_detected,custominstruction, jumpEnable, src1, src2, Z, N,clk);
  input hazard_detected;
  input clk;
  input [`OP_CODE_LEN-1:0] opCode;
  input [15:0] custominstruction;
  input [`WORD_LEN-1:0] src1, src2;
  output reg branchEn;
  output reg jumpEnable;
  output reg [`EXE_CMD_LEN-1:0] EXE_CMD;
  output reg [1:0] Branch_command;
  output reg Is_Imm, ST_or_BNE, WB_EN, MEM_R_EN, MEM_W_EN;
  output reg N;
  output reg Z;
  integer F;

  always @ ( * ) begin
    if (hazard_detected == 0) begin
      {branchEn, EXE_CMD, Branch_command, Is_Imm, ST_or_BNE, WB_EN, MEM_R_EN, MEM_W_EN} <= 0;
      case (opCode)
        // R-typehazard_detected operations
        `OP_ADD: begin EXE_CMD <= `EXE_ADD; WB_EN <= 1; end
        `OP_SUB: begin EXE_CMD <= `EXE_SUB; WB_EN <= 1; end
        `OP_AND: begin EXE_CMD <= `EXE_AND; WB_EN <= 1; end
        `OP_MULT: begin EXE_CMD <= `EXE_MULT; WB_EN <=0;end
        // `OP_OR:  begin EXE_CMD <= `EXE_OR;  WB_EN <= 1; end
        // `OP_NOR: begin EXE_CMD <= `EXE_NOR; WB_EN <= 1; end
        // `OP_XOR: begin EXE_CMD <= `EXE_XOR; WB_EN <= 1; end
        // `OP_SLA: begin EXE_CMD <= `EXE_SLA; WB_EN <= 1; end
        `OP_SLL: begin EXE_CMD <= `EXE_SLL; WB_EN <= 1; end
        // `OP_SRA: begin EXE_CMD <= `EXE_SRA; WB_EN <= 1; end
        // `OP_SRL: begin EXE_CMD <= `EXE_SRL; WB_EN <= 1; end
        // I-type operations
        `OP_ADDI: begin EXE_CMD <= `EXE_ADD; WB_EN <= 1; Is_Imm <= 1; end
        // `OP_SUBI: begin EXE_CMD <= `EXE_SUB; WB_EN <= 1; Is_Imm <= 1; end
        // memory operations
        `OP_LW: begin EXE_CMD <= `EXE_ADD; WB_EN <= 1; Is_Imm <= 1; ST_or_BNE <= 1; MEM_R_EN <= 1; end
        `OP_SW: begin EXE_CMD <= `EXE_ADD; Is_Imm <= 1; MEM_W_EN <= 1; ST_or_BNE <= 1; end
        // branch operations
      `OP_CMP: 
        begin 
          F = src1 - src2;
          if (F == 0)     begin Z = 1'b1;end
          else if (F < 0) begin N = 1'b1; Z = 1'b0;end
          else if (F > 0) begin Z = 1'b0; N = 1'b0;end
          
        end
        `OP_BNE: begin EXE_CMD <= `EXE_NO_OPERATION; Is_Imm <= 1; Branch_command <= `COND_BNE; branchEn <= 1; end
        `OP_JMP: begin EXE_CMD <= `EXE_NO_OPERATION; Is_Imm <= 1; Branch_command <= `COND_JUMP; branchEn <= 1; jumpEnable <= 1; end
        default: {branchEn, EXE_CMD, Branch_command, Is_Imm, ST_or_BNE, WB_EN, MEM_R_EN, MEM_W_EN,jumpEnable} <= 0;
      endcase
    end

    else if (hazard_detected ==  1) begin
      {EXE_CMD, WB_EN, MEM_W_EN} <= 0;
    end
  end
endmodule // controller
