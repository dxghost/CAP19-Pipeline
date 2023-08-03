`include "defines.v"

module MEM2WB (clk, rst, WB_EN_IN, MEM_R_EN_IN, ALUResIn, memReadValIn, destIn,
                         WB_EN,    MEM_R_EN,    ALURes,   memReadVal,   dest,
                         customdestin, add_base_in, add_base_out, val1In, val1Out);
  input clk, rst;
  // TO BE REGISTERED FOR ID STAGE
  input WB_EN_IN, MEM_R_EN_IN;
  input [`REG_FILE_ADDR_LEN-1:0] destIn;
  input [`WORD_LEN-1:0] ALUResIn, memReadValIn;
  input add_base_in;
  input [`WORD_LEN-1:0]val1In;
  // REGISTERED VALUES FOR ID STAGE
  output reg WB_EN, MEM_R_EN;
  output reg [`REG_FILE_ADDR_LEN-1:0] dest;
  output reg [`WORD_LEN-1:0] ALURes, memReadVal;
  input [`REG_FILE_ADDR_LEN-1:0] customdestin;
  output reg [`WORD_LEN-1:0] val1Out;
  output reg add_base_out;
  always @ (posedge clk) begin
    // $monitor("################# MEM/WB ################");
    if (rst) begin
      // $monitor("MEM/WB : reset = 1;\n WB_EN_IN : %b,\n MEM_R_EN_IN : %b,\n ALUResIn : %b,\n memReadValIn : %b,\n destIn : %b\nend MEM/WB\n",WB_EN_IN,MEM_R_EN_IN,ALUResIn,memReadValIn,destIn);
      {WB_EN, MEM_R_EN, dest, ALURes, memReadVal} <= 0;
    end
    else begin
      // $monitor("MEM/WB :\n WB_EN_IN = %b,\n MEM_R_EN_IN = %b,\n ALUResIn = %b,\n memReadValIn = %b,\n destIn : %b \nend MEM/WB\n",WB_EN_IN,MEM_R_EN_IN,ALUResIn,memReadValIn,destIn);
      WB_EN <= WB_EN_IN;
      MEM_R_EN <= MEM_R_EN_IN;
      dest <= customdestin;
      ALURes <= ALUResIn;
      memReadVal <= memReadValIn;
      add_base_out <= add_base_in;
      val1Out <= val1In;
    end
    // $monitor("################# MEM/WB ################");
  end
endmodule // MEM2WB
