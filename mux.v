`include "defines.v"

module mux #(parameter integer LENGTH=16) (in1, in2, sel, out);
  input sel;
  input [LENGTH-1:0] in1, in2;
  output [LENGTH-1:0] out;
  assign out = (sel == 0) ? in1 : in2;

endmodule // mxu

module mux_3input #(parameter integer LENGTH=16) (in1, in2, in3, sel, out);
  input [LENGTH-1:0] in1, in2, in3;
  input [1:0] sel;
  output [LENGTH-1:0] out;
  assign out = (sel == 2'd0) ? in1 :
               (sel == 2'd1) ? in2 : in3;
endmodule // mux


module mux1bit #(parameter integer LENGTH=1) (in1, in2, sel, out);
  input sel;
  input  in1, in2;
  output  out;

    

  assign out = (sel == 0) ? in1 : in2;

endmodule // mxu