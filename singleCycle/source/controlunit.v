module cu (input wire[5:0] opcode,
           input wire[5:0] Funct,    //used by r-type, 感觉不需要alu control了
           input wire Zero,
           output [1:0] RegDst,      // rd,rt,[31] as the addr
           output ext5,              // 无符号拓展5bits，rs[4:0]或shamt
           output wire extsign,       // extend 16的符号,1为符号拓展
           output ALUop1,            // 0 means rs, 1 means zero extended shamt
           output ALUop2,            // 0 means rt, 1 means extended imm16无论是零还是符号拓展
           output [1:0] ToReg,       // 哪个数据去rf，alu, mem, pc+4
           output RegWr,             // 是否写入寄存器
           output MemWrite,          //是否写入dm
           output wire[1:0] MemByte, /* control the data have been get before MemRead mux
                                     and the length of data ready to write to data memory*/
           output MemSign,           // 读出的数据是否需要无符号拓展
           output PCMUX,             // PC(Branch)或者IFJ
           output IFJ,               // 无条件地址，j型或者寄存器
           output Branch,            // directly used by
           output wire [3: 0] ALUOP
           );

wire rtype = ~| opcode;  /*当且仅当是R型指令，此值为1
所以缩位或非操作（就是第一位和第二位或，结果再跟第三位或，如此到结尾）
可以确定这个值（OP码）是否为全0，这个结果再取非，如果为1就意味着是R型指令，相当于这是个R型指令的flag
R-R*/
wire  i_add = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0];
wire  i_sub = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0];
wire  i_and = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0];
wire  i_nor = rtype& Funct[5]&~Funct[4]& ~Funct[3]&Funct[2]&Funct[1]&Funct[0];
wire  i_or  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]& Funct[0];
wire i_xor  = rtype&Funct[5]&~Funct[4]& ~Funct[3]&Funct[2]&Funct[1]&~Funct[0];
wire  i_slt = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]&~Funct[0];

wire i_sltu = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]& Funct[0];
wire i_addu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0];
wire i_subu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0];

wire i_sllv = rtype&~Funct[5]&~Funct[4]& ~Funct[3]&Funct[2]&~Funct[1]&~Funct[0];
wire i_srlv = rtype&~Funct[5]&~Funct[4]& ~Funct[3]&Funct[2]&Funct[1]&~Funct[0];
wire i_srav = rtype&~Funct[5]&~Funct[4]& ~Funct[3]&Funct[2]&Funct[1]&Funct[0];

wire  i_sll = rtype&~Funct[5]&~Funct[4]& ~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0];
wire i_srl  = rtype&~Funct[5]&~Funct[4]& ~Funct[3]&~Funct[2]&Funct[1]&~Funct[0];
wire  i_sra = rtype&~Funct[5]&~Funct[4]& ~Funct[3]&~Funct[2]&Funct[1]&Funct[0];

wire i_jr   = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]&~Funct[0];
wire i_jalr = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]&Funct[0];

// R-I
wire i_addi = ~opcode[5]&~opcode[4]& opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];
wire i_andi = ~opcode[5]&~opcode[4]& opcode[3]&opcode[2]&~opcode[1]&~opcode[0];
wire i_lui  = ~opcode[5]&~opcode[4]& opcode[3]&opcode[2]&opcode[1]&opcode[0];
wire i_ori  = ~opcode[5]&~opcode[4]& opcode[3]& opcode[2]&~opcode[1]& opcode[0];
wire i_slti = ~opcode[5]&~opcode[4]& opcode[3]&~opcode[2]&opcode[1]&~opcode[0];
wire i_beq  = ~opcode[5]&~opcode[4]&~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];
wire i_bne  = ~opcode[5]&~opcode[4]& ~opcode[3]&opcode[2]&~opcode[1]&opcode[0];
wire i_lb   = opcode[5]&~opcode[4]& ~opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];
wire i_lbu  = opcode[5]&~opcode[4]& ~opcode[3]&opcode[2]&~opcode[1]&~opcode[0];
wire i_lh   = opcode[5]&~opcode[4]& ~opcode[3]&~opcode[2]&~opcode[1]&opcode[0];
wire i_lhu  = opcode[5]&~opcode[4]& ~opcode[3]&opcode[2]&~opcode[1]&opcode[0];
wire i_lw   = opcode[5]&~opcode[4]&~opcode[3]&~opcode[2]& opcode[1]& opcode[0];
wire i_sb   = opcode[5]&~opcode[4]& opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];
wire i_sh   = opcode[5]&~opcode[4]& opcode[3]&~opcode[2]&~opcode[1]&opcode[0];
wire i_sw   = opcode[5]&~opcode[4]& opcode[3]&~opcode[2]& opcode[1]& opcode[0];


// J
wire i_j   = ~opcode[5]&~opcode[4]&~opcode[3]&~opcode[2]& opcode[1]&~opcode[0];
wire i_jal = ~opcode[5]&~opcode[4]& ~opcode[3]&~opcode[2]&opcode[1]&opcode[0];


// bind wire to output signal wire
assign RegDst[1]  = i_jal | i_jalr ;
assign RegDst[0]  = i_addi|i_andi|i_ori|i_lui|i_lw|i_slti|i_lb|i_lbu|i_lh|i_lhu;
assign ext5       = i_sll|i_srl|i_sra;
assign extsign    = i_addi|i_lw|i_sw|i_slti|i_lb|i_lbu|i_lh|i_lhu|i_sb|i_sh;
assign ALUop1     = i_sll | i_srl|i_sra|i_sllv|i_srlv|i_srav;
assign ALUop2     = extsign | i_andi|i_ori|i_lui;
assign ToReg[1]   = i_jal|i_jalr;
assign ToReg[0]   = i_lw|i_lh|i_lhu|i_lb|i_lbu;
assign RegWr      = ~(i_jr&i_sw&i_beq&i_bne&i_j&i_sb&i_sh);
assign MemWrite   = i_sw|i_sb|i_sh;
assign MemByte[1] = i_lb|i_lbu|i_lh|i_lhu|i_sh|i_sb;
assign MemByte[0] = i_lb|i_lbu|i_sb;
assign MemSign    = i_lw|i_lb|i_lh;
assign PCMUX      = i_jr|i_j|i_jal|i_jalr;
assign IFJ        = i_jr|i_jalr;


assign ALUOP[3] = i_addu | i_sll | i_sllv|i_sra|i_srav | i_srl | i_srlv|i_subu|i_lui;
assign ALUOP[2] = i_nor| i_slt|i_sltu|i_sra|i_srav|i_srl|i_srlv|i_xor|i_slti;
assign ALUOP[1] = i_and|i_or|i_sll|i_sllv|i_slt|i_sltu|i_andi|i_lui|i_ori|i_slti;
assign ALUOP[0] = i_nor|i_or|i_sltu|i_sra|i_srav|i_sub|i_subu|i_lui|i_ori|i_beq|i_bne ;

assign Branch = (i_beq & Zero) | (i_bne & (~Zero));

always @(opcode) begin
    $display("op %6b,funct%6b,andi %1b, aluop2=%1b", opcode, Funct,i_andi,ALUop2);
end


endmodule
