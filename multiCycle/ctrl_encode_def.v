// ALU control signal
`define ALU_ADD   4'b0001     // also addi,lw,sw
`define ALU_SUB   4'b0010     // also beq,bne
`define ALU_AND   4'b0011     // also andi
`define ALU_OR    4'b0100     // also ori
// `define ALU_XOR   4'b0101
`define ALU_NOR   4'b0110     
`define ALU_SLT   4'b0111     // also slti
`define ALU_SLTU  4'b1000
`define ALU_ADDU  4'b1001
`define ALU_SUBU  4'b1010
`define ALU_SLL   4'b1011      // also sllv
`define ALU_LUI   4'b1100
`define ALU_SRL   4'b1101      // also srlv
// `define ALU_SRA// also srav
`define ALU_NOP   4'b0000