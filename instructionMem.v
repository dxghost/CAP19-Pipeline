`include "defines.v"

module instructionMem (rst, addr, instruction);
  input rst;
  input [`WORD_LEN-1:0] addr;
  output [`WORD_LEN-1:0] instruction;

  wire [$clog2(`INSTR_MEM_SIZE)-1:0] address = addr[$clog2(`INSTR_MEM_SIZE)-1:0];
  reg [`MEM_CELL_SIZE-1:0] instMem [0:`INSTR_MEM_SIZE-1];

  always @ (*) begin
  	if (rst) begin

        // instMem[0] <= 4'b0011; //-- Add	A2,A3
        // instMem[1] <= 4'b0010;
        // instMem[2] <= 4'b0000;
        // instMem[3] <= 4'b0001;

        // instMem[4] <= 4'b0000; //-- Add	A2,A3
        // instMem[5] <= 4'b0010;
        // instMem[6] <= 4'b0110;
        // instMem[7] <= 4'b0000;

        // instMem[4] <= 4'b0011; //-- Add	A2,A3
        // instMem[5] <= 4'b0011;
        // instMem[6] <= 4'b0000;
        // instMem[7] <= 4'b0011;

        instMem[8] <= 4'b0011; //-- Add	A7,9
        instMem[9] <= 4'b0111;
        instMem[10] <= 4'b0000;
        instMem[11] <= 4'b1001;

        instMem[12] <= 4'b0011; //-- Add A0,15
        instMem[13] <= 4'b0000;
        instMem[14] <= 4'b0000;
        instMem[15] <= 4'b1111;

        instMem[16] <= 4'b0011; //-- Add A15,11
        instMem[17] <= 4'b1111;
        instMem[18] <= 4'b0000;
        instMem[19] <= 4'b0111;

        instMem[20] <= 4'b0000; //-- Add A3, A1
        instMem[21] <= 4'b0011;
        instMem[22] <= 4'b0001;
        instMem[23] <= 4'b0000;

        instMem[24] <= 4'b1101; //-- CMP A0, A7
        instMem[25] <= 4'b0000;
        instMem[26] <= 4'b0111;
        instMem[27] <= 4'b0000;

        // instMem[28] <= 4'b1110; //-- BNE	12
        // instMem[29] <= 4'b0000;
        // instMem[30] <= 4'b0111;
        // instMem[31] <= 4'b1111;

        instMem[28] <= 4'b1001; //-- SW A7, A15, 0
        instMem[29] <= 4'b0111; // data = A7 , Address = A15 , Offset : 0
        instMem[30] <= 4'b1111;
        instMem[31] <= 4'b0000;


        instMem[48] <= 4'b0111; //-- LW A1, A15
        instMem[49] <= 4'b0001; // register = A1
        instMem[50] <= 4'b0111; // address = A7
        instMem[51] <= 4'b0000; // offset = 0

      end
    end

  assign instruction = {instMem[address], instMem[address + 1], instMem[address + 2], instMem[address + 3]};
  always @(addr) begin
      $display("---------------- Istruction Memory ----------------");
      $display("|Instruction = %b   |\n|PC          = %\d              |", instruction,addr);
  end
endmodule // insttructionMem
