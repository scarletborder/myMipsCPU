module mux3 #(parameter WIDTH = 32)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    input [1:0] sel,
    output [WIDTH-1:0] out
);
    assign out = ((sel[1] == 1 ? c: ((sel[0] == 1) ? b : a)) );
endmodule