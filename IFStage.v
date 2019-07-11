`include "defines.v"

module IFStage (clk, rst, brTaken, brOffset, freeze, PC, instruction);
  input clk, rst, brTaken, freeze;
  input [`WORD_LEN-1:0] brOffset;
  output [`WORD_LEN-1:0] PC, instruction;

  wire [`WORD_LEN-1:0] adderIn1, adderOut, brOffserTimes2;

  mux #(.LENGTH(`WORD_LEN)) adderInput (
    .in1(16'd4),
    .in2(brOffserTimes2),
    .sel(brTaken),
    .out(adderIn1)
  );

  adder add4 (
    .in1(adderIn1),
    .in2(PC),
    .out(adderOut)
  );

  register PCReg (
    .clk(clk),
    .rst(rst),
    .writeEn(~freeze),
    .regIn(adderOut),
    .regOut(PC)
  );

  instructionMem instructions (
    .rst(rst),
    .addr(PC),
    .instruction(instruction)
  );

  assign brOffserTimes2 = brOffset << 1;
endmodule // IFStage
