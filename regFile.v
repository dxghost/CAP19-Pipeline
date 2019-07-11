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
      // $monitor("writeEn is enabled");
      regMem[dest] = writeVal;
      $display("################ RegFile start ###############\ninstruction = %b,\n src1 = %b, val = %b\n src2 = %b, val = %b\n dest = %b, val = %b\n writeVal = %b\nwriteEn = %b\n############# Regfile end #############",
    custominstruction,src1,regMem[src1],src2,regMem[src2],dest,regMem[dest],writeVal,writeEn);
      end
    regMem[0] = 0;
    
    // $display("################ RegFile start ###############\ninstruction = %b,\n src1 = %b, val = %b\n src2 = %b, val = %b\n dest = %b, val = %b\n writeVal = %b\nwriteEn = %b\n############# Regfile end #############",
    // custominstruction,src1,regMem[src1],src2,regMem[src2],dest,regMem[dest],writeVal,writeEn);

  end

  // assign firstreg = (regMem[src2]);
  // // assign dest = src1;
  assign reg1 = (regMem[src1]);
  assign reg2 = (regMem[src2]);
  
  // assign reg1 = 4'b0100;
  // assign reg2 = 4'b1001;

endmodule // regFile
