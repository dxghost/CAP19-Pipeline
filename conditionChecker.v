`include "defines.v"

module conditionChecker (reg1, reg2, cuBranchComm, brCond, Z);
  input Z;
  input [`WORD_LEN-1: 0] reg1, reg2;
  input [1:0] cuBranchComm;
  output reg brCond;

  always @ ( * ) begin
    case (cuBranchComm)
      `COND_JUMP: brCond <= 1;
      `COND_BNE: brCond <= (Z == 0) ? 1 : 0;
      default: brCond <= 0;
    endcase
  end
endmodule // conditionChecker
