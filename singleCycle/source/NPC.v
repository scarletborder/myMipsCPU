/* 作为cpu输出的，成为顶层的下一个PC*/
module NPC (input [31:0] Branch, // 来自pc+4 or branch
            input [31:0] IFJ,
            input PCMUX,
            output [31:0] NPC);
assign NPC = (PCMUX == 1'b0 ? Branch : IFJ);
endmodule
