`include "defines.v"

module EXE2MEM (clk, rst, WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, PCIn, ALUResIn, STValIn, destIn,
                          WB_EN,    MEM_R_EN,    MEM_W_EN,    PC,   ALURes,   STVal,   dest,
                          customdestin,customdest,
                          instructionIn,instructionOut, val1Out , val1In,add_base_in,add_base_out);
  input clk, rst;
  // TO BE REGISTERED FOR ID STAGE
  input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN;
  input [`REG_FILE_ADDR_LEN-1:0] destIn;
  input [`WORD_LEN-1:0] PCIn, ALUResIn, STValIn;
  input [15:0] instructionIn;
  input [`WORD_LEN-1:0] val1In;
  input add_base_in;
  // REGISTERED VALUES FOR ID STAGE
  output reg [15:0] instructionOut;
  output reg WB_EN, MEM_R_EN, MEM_W_EN;
  output reg [`REG_FILE_ADDR_LEN-1:0] dest;
  output reg [`WORD_LEN-1:0] PC, ALURes, STVal;
  output reg [`WORD_LEN-1:0] val1Out;
  output reg add_base_out;
  input [`REG_FILE_ADDR_LEN-1:0] customdestin;
  output reg [`REG_FILE_ADDR_LEN-1:0] customdest;

  always @ (posedge clk) begin
    if (rst) begin
      // $monitor("EXE/MEM : reset = 1;\n WB_EN_IN : %b,\n MEM_R_EN_IN : %b,\n MEM_W_EN_IN : %b,\n PCIn : %b,\n destIn : %b,\n ALUResIn : %b,\n STValIn : %b\nend EXE/MEM\n"
      // ,WB_EN_IN,MEM_R_EN_IN,MEM_W_EN_IN,PCIn,destIn,ALUResIn,STValIn);
      {WB_EN, MEM_R_EN, MEM_W_EN, PC, ALURes, STVal, dest} <= 0;
    end
    else begin
      customdest<=customdestin;
      // $monitor("EXE/MEM:\n WB_EN_IN : %b,\n MEM_R_EN_IN : %b,\n MEM_W_EN_IN : %b,\n PCIn : %b,\n destIn : %b,\n ALUResIn : %b,\n STValIn : %b\nend EXE/MEM\n"
      // ,WB_EN_IN,MEM_R_EN_IN,MEM_W_EN_IN,PCIn,destIn,ALUResIn,STValIn);
      WB_EN <= WB_EN_IN;
      MEM_R_EN <= MEM_R_EN_IN;
      MEM_W_EN <= MEM_W_EN_IN;
      PC <= PCIn;
      instructionOut<=instructionIn;
      ALURes <= ALUResIn;
      STVal <= STValIn;
      dest <= destIn;
      val1Out<=val1In;
      add_base_out<=add_base_in;
    end
  end

endmodule // EXE2MEM
