`include "defines.v"

module dataMem (clk, rst, writeEn, readEn, address, dataIn, dataOut,PC,instruction);
  input clk, rst, readEn, writeEn;
  input [`WORD_LEN-1:0] address, dataIn;
  input [`WORD_LEN-1:0] PC;
  input [15:0] instruction;
  output [`WORD_LEN-1:0] dataOut;

  integer i;
  reg [`MEM_CELL_SIZE-1:0] dataMem [0:`DATA_MEM_SIZE-1];
  wire [`WORD_LEN-1:0] base_address;
  wire [15:0] customAddress;
  always @ (posedge clk) begin
    if (rst)
      for (i = 0; i < `DATA_MEM_SIZE; i = i + 1)
        dataMem[i] <= 0;
    else if (writeEn)
      {dataMem[base_address], dataMem[base_address + 1], dataMem[base_address + 2], dataMem[base_address + 3]} <= dataIn;
  end


  assign customAddress= {8'b00000000, instruction[7:0]<<1};
  // assign base_address = ((address & 16'b1111101111111111) >> 2) << 2;
  assign base_address = customAddress;
  // assign dataOut = (address < 1024) ? 0 : {dataMem[base_address], dataMem[base_address + 1], dataMem[base_address + 2], dataMem[base_address + 3]};
  assign dataOut =  {dataMem[base_address], dataMem[base_address + 1], dataMem[base_address + 2], dataMem[base_address + 3]};
  
  always @(posedge clk) begin
    $display("---------------- Data Memory ----------------");
    $display("writeEn = %b\nreadEn = %b\naddress = %b\ndataIn = %b\ndataOut = %b", writeEn, readEn, address, dataIn, dataOut);
  end

  always @ (posedge clk) begin
    $display("---------------- Data Memory Inside ----------------");
    $display("custom address: %b",customAddress);
    $display("PC is %d",PC);
    $display("base address = %d\nMemory = %b%b%b%b", base_address, dataMem[base_address],dataMem[base_address+1],dataMem[base_address+2],dataMem[base_address+3]);
  end

endmodule // dataMem
