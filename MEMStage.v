`include "defines.v"

module MEMStage (clk, rst, MEM_R_EN, MEM_W_EN, ALU_res, ST_value, dataMem_out,PC,instructionIn);
  input clk, rst, MEM_R_EN, MEM_W_EN;
  input [`WORD_LEN-1:0] ALU_res, ST_value;
  input [`WORD_LEN-1:0] PC;
  input [15:0] instructionIn;
  output [`WORD_LEN-1:0]  dataMem_out;
  output [15:0] instructionOut;
  dataMem dataMem (
    .clk(clk),
    .rst(rst),
    .writeEn(MEM_W_EN),
    .readEn(MEM_R_EN),
    .address(ALU_res),
    .dataIn(ST_value),
    .PC(PC),
    .instruction(instructionOut),
    .dataOut(dataMem_out)
  );
  assign instructionOut=instructionIn;
  always @(posedge clk) begin
    $display("---------------- MEM Stage ----------------");
    $display("MEM_R_EN = %b\nMEM_W_EN = %b\nALU_res = %b\nST_value = %b\ndataMem_out = %b", MEM_R_EN, MEM_W_EN, ALU_res, ST_value, dataMem_out);
    $display("PC, instruction, %d %b",PC,instructionIn);
  end
endmodule // MEMStage
