/*
新state且使能情况下获得暂存的数据
在每个时钟周期上升沿，如果使能，那么将d传给q
用来在state_IF中将内存读入的数据赋值给instr，
和在PC该写的时候写入NPC
*/
module flopenr #(parameter WIDTH = 8)
              (clk, rst, en, d, q);

   input              clk;
   input              rst;
   input              en;
   input  [WIDTH-1:0] d;
   output reg [WIDTH-1:0] q;

 
   always @(posedge clk, posedge rst)
      if (rst)
         q <= 0;
      else if (en)
         q <= d;

endmodule
