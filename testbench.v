`timescale 1ns/1ns

module testbench ();
  reg clk,rst, forwarding_EN;
  MIPS_Processor top_module (clk, rst, forwarding_EN);

  initial begin
    clk=1;
    repeat(100)
    begin
      #50 clk=~clk ;
    end
  end

  always @(posedge clk) begin
    $display("\n\n#################################### clock changed ####################################");
  end

  initial begin
    rst = 1;
    forwarding_EN = 1;
    #100
    rst = 0;
  end
endmodule // test
