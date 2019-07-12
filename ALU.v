`include "defines.v"

module ALU (val1, val2, EXE_CMD, aluOut,SLLAmount);
  input [`WORD_LEN-1:0] val1, val2;
  input [`EXE_CMD_LEN-1:0] EXE_CMD;
  input [7:0] SLLAmount;
  output reg [`WORD_LEN-1:0] aluOut;
  reg [15:0] HI;
  reg [15:0] LO;
  reg [31:0] multProduct;
  always @ ( val1,val2 ) begin
    case (EXE_CMD)
      `EXE_ADD: aluOut <= val1 + val2;
      `EXE_SUB: aluOut <= val1 - val2;
      `EXE_AND: 
        begin 
          aluOut = val1 & val2;
        end
      `EXE_OR: aluOut <= val1 | val2;
      `EXE_NOR: aluOut <= ~(val1 | val2);
      `EXE_XOR: aluOut <= val1 ^ val2;
      `EXE_SLL:
        begin
          aluOut = val1 << SLLAmount;
        end
       // `EXE_SLL: aluOut <= val1 <<< val2;
      `EXE_SRA: aluOut <= val1 >> val2;
      `EXE_SRL: aluOut <= val1 >>> val2;
      `EXE_MULT: begin multProduct = val1 *val2; HI = multProduct[31:16]; LO = multProduct[15:0];end 

      default: aluOut <= 0;
    endcase
  end
endmodule // ALU
