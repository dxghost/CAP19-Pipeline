`include "defines.v"

module IFStage (clk, rst, brTaken, brOffset, freeze, PC, instruction, jumpEnable);
  input clk, rst, brTaken, freeze;
  input [`WORD_LEN-1:0] brOffset;
  input jumpEnable;
  output [`WORD_LEN-1:0] PC, instruction;

  wire [`WORD_LEN-1:0] adderIn1, adderOut, brOffserTimes2;
  wire [`WORD_LEN-1:0] PC_1;
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
    .regOut(PC_1)
  );

  instructionMem instructions (
    .rst(rst),
    .addr(PC),
    .instruction(instruction)
  );

  mux #(.LENGTH(`WORD_LEN)) jumpMux (
  .in1(PC_1),
  .in2(brOffserTimes2),
  .sel(jumpEnable),
  .out(PC)
);

  assign brOffserTimes2 = brOffset << 1;

  always @(posedge clk) begin
    $display("---------------- IF Stage ----------------");
    $display("brTaken = %b\nbrOffset = %b\nfreeze = %b\nPC = %d\ninstruction = %b\njumpEnable = %b",brTaken, brOffset, freeze, PC, instruction, jumpEnable);
  end

endmodule // IFStage
