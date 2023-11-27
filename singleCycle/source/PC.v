module PC (input clk,
           input rst,
           input [31:0] NPC,
           output reg [31:0] PC);
    always @(posedge clk,posedge rst) begin
        if (rst)
            PC <= 32'h00000000;
        else
            PC <= NPC;
    end
endmodule
