`include "defines.v"

module IF2ID (clk, rst, flush, freeze, PCIn, instructionIn, PC, instruction);
  input clk, rst, flush, freeze;
  input [`WORD_LEN-1:0] PCIn, instructionIn;
  output reg [`WORD_LEN-1:0] PC, instruction;

  always @ (posedge clk) begin

    // $monitor("################# IF/ID ################");
    if (rst) begin
      $monitor("IF/ID : reset = 1;\n instruction input : %b,\n PC input : %b \nend IF/ID\n",instructionIn,PCIn);
      PC <= 0;
      instruction <= 0;
    end
    else begin
      if (~freeze) begin
        if (flush) begin
          $monitor("IF/ID : flush = 1;\n instruction input : %b,\n PC input : %b \nend IF/ID\n",instructionIn,PCIn);
          instruction <= 0;
          PC <= 0;
        end
        else begin
          
          instruction <= instructionIn;
          PC <= PCIn;
          $monitor("IF/ID :\n instruction input : %b,\n PC input : %b\nend IF/ID\n",instructionIn,PCIn);
        end
      end
    end
    // $monitor("################# IF/ID ################");
  end
endmodule // IF2ID
