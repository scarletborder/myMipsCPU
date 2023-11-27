/* Status unit*/
module RegisterFile (input wire clk,          // clock signal
                     input wire rst,          //reset signal
                     input wire [4:0] A1,     // rs
                     input wire [4:0] A2,     // rt
                     input wire [4:0] A3,     // rd, write reg address
                     input wire [31:0] WD,    // write data, if used, write to A3(rd)
                     input wire RFWr,         // whether write to rf now, A3<-WD
                     output wire [31:0] RD1,
                     output wire [31:0] RD2,
                     input [4:0] reg_sel,
                     output [31:0] reg_data);
    reg [31:0] regfile[31:0];// 32 registers
    integer idx;
    
    // read
    assign RD1 = (A1 == 5'b0) ? 32'b0 : regfile[A1];
    assign RD2 = (A2 == 5'b0) ? 32'b0 : regfile[A2];
    
    always @(posedge clk,posedge rst) begin
        if (rst) begin//reset
            for(idx = 0;idx < 32;idx = idx + 1) begin
                regfile[idx] <= 32'b0;
            end
        end
        else
            if (RFWr) begin
                // 只能写入支持写入的寄存器
                // https://blog.csdn.net/u011057409/article/details/122151867
                regfile[A3] <= ((A3 == 0)? 32'b0 : WD);
                $display("r[%2d] = 0x%8X,", A3, WD);
            end
    end
    
    assign reg_data = ((reg_sel != 0) ? regfile[reg_sel] : 0);
endmodule
