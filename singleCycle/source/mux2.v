// 2 way multi choose
// 0 from the front and 1 from the last
module mux2 #(parameter WIDTH = 32)(input [WIDTH-1:0] a,
             input [WIDTH-1:0] b,
             input wire sel,
             output wire[WIDTH-1:0] r);
assign r = (sel == 1'b0) ? a :b;
endmodule
