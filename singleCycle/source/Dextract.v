/*从读取的数据中，根据lb,lw,lbu来确定mem的结果*/
module Dextract (
    input [1:0] MemByte,
    input [1:0] addr,
    input sign,
    input [31:0] data,
    output wire [31:0] out
);
  reg [31:0] result;
always @(*) begin
    if (sign == 1'b1) begin
        case (MemByte)
            2'b10:begin // lh
            result <= (addr[1] == 0 ? {{16{data[15]}},data[15:0]} : {{16{data[31]}},data[31:16]});
            end
            2'b11:begin // lb
            result <= (addr[1] == 0 ? (addr[0] == 0? {{24{data[7]}},data[7:0]} : {{24{data[15]}},data[15:8]}) : (addr[0] == 0? {{24{data[23]}},data[23:16]}:{{24{data[31]}},data[31:24]}));
            end
            default:    // lw
            result <= data ;
        endcase
    end
    else begin
        case (MemByte)
            2'b10:begin // lhu
            result <= (addr[1] == 0 ? {{16'b0},data[15:0]} : {{16'b0},data[31:16]});
            end
            2'b11:begin // lbu
            result <= (addr[1] == 0 ? (addr[0] == 0? {24'b0,data[7:0]} : {24'b0,data[15:8]}) : (addr[0] == 0? {24'b0,data[23:16]}:{24'b0,data[31:24]}));
            end
            default:    // lw
            result <= data ;
        endcase
    end
end
  assign out = result;  
endmodule