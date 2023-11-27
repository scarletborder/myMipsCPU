// zero or signed extend 16 bits to 32bits
// 0 for zero extend and 1 for signed extend
// zero extend will be used in andi etc. immediate involved calculate
module ext16 (input wire[15:0] in,
              input wire sign,
              output wire[31:0] out);
assign out = ((sign==1) ? ({{16{in[15]}},in}) : {{16'b0},in});

endmodule
