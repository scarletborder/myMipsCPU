// 组合单元
// validated!
/**
 * ALU
 * need to support many calculate funtions
 * ignore overflow
 */

/*
 ALUop need to suuport
 add/sub/and/or/xor/nor   all need one spectified ALUop
 slt/sltu/addu/subu
 lui
 sll/bne/srl/sra
 
 from mux choose one data, read from regfile or instruction itself
 these cmd only need one ALUop that mentioned above
 srav
 andi
 slti
 sllv
 srlv
 
 sum 14
 4bits ALUop
 
 deposited: these cmd need to immigrant to other unit
 
 */
module ALU (input wire signed [31:0] A, // operand 1, rs or s(shift used)
            input wire signed [31:0] B, // operand 2, rt or immediate
            input wire [3:0] ALUop,
            output reg signed [31:0] C, //C
            output wire Zero);
    reg [32:0] tmp;
    always @(*) begin
        case (ALUop)
            /* 算数,immediate comes from mux*/
            4'b0000: C <= A + B;                              // add , addi
            4'b0001: C <= A - B;                              // sub , beq
            4'b0010: C <= A & B;                              // and , andi
            4'b0011: C <= A | B;                              // or
            4'b0100: C <= A ^ B;                              // xor
            4'b0101: C <= ~(A | B);                           // nor
            /* 比较*/
            4'b0110: C <= (A < B) ? 32'b1 : 32'b0;            // slt lower set 1
            4'b0111: C <= ({1'b0,A} < {1'b0,B}) ? 32'b1:32'b0;//unsigned slt, lower set 1
            /* unsigned add and sub*/
            4'b1000: begin
                /* addu*/
                tmp = {1'b0,A} + {1'b0,B};
                C   = tmp[31:0];
            end
            4'b1001: begin
                /* subu*/
                tmp = {1'b0,A} - {1'b0,B};
                C   = tmp[31:0];
            end
            // shift sll/sra
            4'b1010 : begin
                /* sll or sllv*/
                C <= B << {1'b0,A[4:0]} ;// from mux
            end
            // lui immediate load to highest bits, left shift 16 bits
            4'b1011: begin
                C <= B << 'd16;
            end
            // srl or srlv
            4'b1100 : begin
                C <= B >> {1'b0,A[4:0]};  // from mux
            end
            // sra,right shift with arthibary
            4'b1101 : begin
                C <= B >>> {1'b0,A[4:0]} ;// from mux
            end
            4'b1110: begin
                C <= (A == B ? 32'b1 : 32'b0);// bne
            end
            default: begin
                C <= A;
            end
        endcase
        $display("opr1 0x%8X, opr2 0x%8X", A, B);
    end
    assign   Zero = ((C == 32'b0) ? 1'b1 : 1'b0);
    
    
endmodule
    
