module BranchAdd (input [31:0] PC,
                  input [31:0] EXT16,
                  input Branch,
                  output [31:0] Badd);
assign Badd = ((Branch == 1'b1)? (PC+4+(EXT16 <<< 2)):(PC+4));
endmodule
