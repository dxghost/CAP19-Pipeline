`include "defines.v"

module signExtend (in, out);
  input [7:0] in;
  output [`WORD_LEN-1:0] out;

  assign out = (in[7] == 1) ? {8'b11111111, in} : {8'b00000000, in};
endmodule // signExtend
