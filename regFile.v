`include "defines.v"

module regFile (clk, rst, src1, src2, dest, writeVal, writeEn, reg1, reg2,custominstruction);
  input clk, rst, writeEn;
  input [`REG_FILE_ADDR_LEN-1:0] src1, src2, dest;
  input [`WORD_LEN-1:0] writeVal;
  output [`WORD_LEN-1:0] reg1, reg2;
  input [`WORD_LEN-1:0] custominstruction;

  output[`WORD_LEN-1:0] firstreg;

  reg [`WORD_LEN-1:0] regMem [0:`REG_FILE_SIZE-1];
  integer i;

  always @ (negedge clk) begin
    if (rst) begin
      for (i = 0; i < `WORD_LEN; i = i + 1)
        regMem[i] <= 0;
	    end

    else if (writeEn)
      begin
      regMem[dest] = writeVal;
      end
    regMem[0] = 0;
  end

  // assign firstreg = (regMem[src2]);
  // // assign dest = src1;
  assign reg1 = (regMem[src1]);
  assign reg2 = (regMem[src2]);
  
  // assign reg1 = 4'b0100;
  // assign reg2 = 4'b1001;

  always @(writeEn) begin
    $display("---------------- REG FILE ----------------");
      for (i = 0; i < `WORD_LEN; i = i + 1)
        $display("i = %b\nregMEM[i] = %b\n", i, regMem[i]);
  end

endmodule // regFile
