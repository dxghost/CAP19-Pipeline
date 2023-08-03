`include "defines.v"

module WBStage (MEM_R_EN, memData, aluRes, WB_res, clk,val1In,add_base_in);
  input clk;
  input MEM_R_EN;
  input [`WORD_LEN-1:0] memData, aluRes;
  input [15:0] val1In;
  input add_base_in;
  output [`WORD_LEN-1:0] WB_res;
  wire  [15:0] WB_res_Normal;

  assign WB_res_Normal = (MEM_R_EN) ? memData : aluRes;

  always @(posedge clk) begin
    $display("---------------- WB Stage ----------------");
    $display("MEM_R_EN = %b\nmemData = %b\naluRes = %b\nWB_res%b\nadd_base_in= %b\nval1In= %b", MEM_R_EN, memData, aluRes, WB_res, add_base_in, val1In);
  end

  assign WB_res = (!add_base_in)? WB_res_Normal : WB_res_Normal + val1In  ;

endmodule // WBStage
