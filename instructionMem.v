`include "defines.v"

module instructionMem (rst, addr, instruction);
  input rst;
  input [`WORD_LEN-1:0] addr;
  output [`WORD_LEN-1:0] instruction;

  wire [$clog2(`INSTR_MEM_SIZE)-1:0] address = addr[$clog2(`INSTR_MEM_SIZE)-1:0];
  reg [`MEM_CELL_SIZE-1:0] instMem [0:`INSTR_MEM_SIZE-1];

  always @ (*) begin
  	if (rst) begin

        instMem[8] <=  4'b0011; //-- Add	A1,10
        instMem[9] <= 4'b0001;
        instMem[10]<= 4'b0000;
        instMem[11]<= 4'b1010;

        instMem[12] <= 4'b0011; //-- Add A2,11
        instMem[13] <= 4'b0010;
        instMem[14] <= 4'b0000;
        instMem[15] <= 4'b1011;

        instMem[16] <= 4'b0011; //-- Add A3,1
        instMem[17] <= 4'b0011;
        instMem[18] <= 4'b0000;
        instMem[19] <= 4'b0001;

        instMem[24] <= 4'b1001; //-- SW A1, A2, 0
        instMem[25] <= 4'b0011; // data = A1 , Address = A2 , Offset : 0
        instMem[26] <= 4'b1100;
        instMem[27] <= 4'b1111;


        instMem[40] <= 4'b0111; //-- LW A3, A2
        instMem[41] <= 4'b0011; // register = A3
        instMem[42] <= 4'b1100; // address 
        instMem[43] <= 4'b1111; // address

      end
    end

  assign instruction = {instMem[address], instMem[address + 1], instMem[address + 2], instMem[address + 3]};

  always @(instruction) begin
      $display("---------------- Istruction Memory ----------------");
      $display("|Instruction = %b   |\n|PC          = %\d              |", instruction,addr);
  end
endmodule // insttructionMem
