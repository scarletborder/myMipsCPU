/*
新state下获得暂存的数据
在每个时钟周期上升沿，将d传给q
如在上个state中，RD1存储了从rs中读出的数据，
那么这个state的clk上升沿，将RD1赋值给这次state用于计算的A，
防止同步读取时冲掉数据
*/
module flopr #(parameter WIDTH = 8)
              (clk, rst, d, q);
   input              clk;
   input              rst;
   input  [WIDTH-1:0] d;
   output [WIDTH-1:0] q;
   
   reg [WIDTH-1:0] q_r;
               
   always @(posedge clk or posedge rst) begin
      if ( rst ) 
         q_r <= 0;
      else 
         q_r <= d;
   end // end always
   
   assign q = q_r;
      
endmodule

