// only zero extend 5 bits to 32bits
// All are zero extend, will be used in sll, srl etc shift tool.
module ext5 (input wire[4:0] in,
              output wire[31:0] out);
assign out = {27'b0,in};
endmodule
