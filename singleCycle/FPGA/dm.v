// data memory
module dm(input clk,
          input  DMWr,
          input  [8:0]  addr, // 8 ~ 2,word; 1 ~ 0 byte
          input [31:0]   din,
          input [1:0]   MemByte,
          output [31:0] dout); // 输出
    
    reg [31:0] dmem[127:0];
    reg [31:0] debug;

    
    always @(posedge clk)
        if (DMWr) begin
            $display("din=0x%8X,dout=0x%8X,addr=0b%9b", din, dout,addr);
            case (MemByte)
                2'b10:begin
                    $display("kouwo");
                    dmem[addr[8:2]] = ((addr[1] == 0) ? {dout[31:16],din[15:0]} : {din[15:0],dout[15:0]});
                end
                2'b11:begin
                    dmem[addr[8:2]] = ((addr[1] == 0) ? (addr[0] == 0? {dout[31:8],din[7:0]} : {dout[31:16],din[7:0],dout[7:0]}) : ((addr[0]) == 0? {dout[31:24],din[7:0],dout[15:0]}:{din[7:0],dout[23:0]}));
                end
                default: begin
                    dmem[addr[8:2]] = din;
                end
            endcase
            
            debug = dmem[addr[8:2]];
            $display("dmem[0x%8X] = 0x%8X,MemByte=%2b", addr[8:2], debug,MemByte[1:0]);
        end
    assign dout = dmem[addr[8:2]];
    
endmodule
