module IFJ (input [31:28] PC,
            input [25:0] imm26,
            input [31:0] rs,
            input j,
            output [31:0] IFJ);
assign IFJ = ((j == 1'b0)?{PC[31:28],imm26[25:0],2'b00}:rs);
endmodule
