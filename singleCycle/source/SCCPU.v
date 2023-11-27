/*
* @author: scarletborder
* @website: blog.scarletborders.top
* @date: 2023/11/23
*/
module sccpu(input clk,               // input: cpu clock
             input rst,               // input: reset
             input [31:0] instr,      // input: instruction
             input [31:0] readdata,   // input: data to cpu
             input MemWrite,          // output: memory write signal
             output [31:0] PC,        // output: PC
             output [31:0] aluout,    // output: address from cpu to memory
             output [31:0] writedata, // output: RD2, data from cpu to memory
             output [1:0] MemByte,    // output: length of data out
             input [4:0] reg_sel,     // input: register selection
             output [31:0] reg_data); // output: register data
    
    // 控制信号
    wire [5:0] opcode;
    wire [5:0] Funct;
    wire [1:0] RegDst;
    wire ext5;
    wire ALUop1;
    wire ALUop2;
    wire [1:0] ToReg;
    wire RegWr;
    wire MemSign;
    wire PCMUX;
    wire IFJ;
    wire Branch;
    wire [3:0] ALUOP;
    
    // 数据线
    /*
     instruction
     */
    // address
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    // data
    wire [4:0] shamt;
    wire [15:0] imm16; // also as offset(the same position)
    wire [25:0] imm26;
    wire [31:0] Rdata1;
    // Rdata2 is writedata*
    
    /*
     数据通路线
     位宽还没写
     */
    /* NPC*/
    wire [31:0] NPC;   // the final next pc out to sim top
    
    /* RegFile*/
    wire [31:0] WD;        // data to regfile
    wire [4:0] RegAddr;    // write address of reg, also known as A3
    wire [31:0] RD1;
    //RD2: writedata, directly picked from RD2(rt)
    
    /*ALU*/
    wire [31:0] ALUoprand1;
    wire [31:0] ALUoprand2;
    wire Zero;
    // out: aluout
    
    /*Extended 16bits*/
    wire [31:0] EXT16; // 区分符号和零拓展，使用模块得到其一结果
    wire extsign;
    
    /*Extended 5bits*/
    wire [4:0] b5in;   // 谁去零拓展5bits
    wire [31:0] EXT5;  // shamt和rs[4:0]拓展到32位都是零拓展
    
    /*ADD branch used*/
    wire [31:0] Badd;// pc+4 or pc+4+offset
    
    /*the final pc which from j(j,jr,jal,jalr)
     module({PC[31:28],imm26[25:0],2'b0})
     */
    wire [31:0] Jslice;
    
    /*DM*/
    // addr: aluout
    // writedata: rt[31:0]
    // dataout: readdata
    
    /*Dextract
     process dataout
     */
    wire [31:0] Dextract;
    
    // 读取instruction
    assign opcode = instr[31:26];
    assign Funct  = instr[5:0];
    assign rs     = instr[25:21];
    assign rt     = instr[20:16];
    assign rd     = instr[15:11];
    assign imm16  = instr[15:0];
    assign imm26  = instr[25:0];
    assign shamt  = instr[10:6];
    
    cu u_cu(
    .opcode   (opcode),
    .Funct    (Funct),
    .Zero     (Zero),
    .RegDst   (RegDst),
    .ext5     (ext5),
    .extsign  (extsign),
    .ALUop1   (ALUop1),
    .ALUop2   (ALUop2),
    .ToReg    (ToReg),
    .RegWr    (RegWr),
    .MemWrite (MemWrite),
    .MemByte  (MemByte),
    .MemSign  (MemSign),
    .PCMUX    (PCMUX),
    .IFJ      (IFJ),
    .Branch   (Branch),
    .ALUOP    (ALUOP)
    );
    
    PC u_PC(
    .clk (clk),
    .rst (rst),
    .NPC (NPC),
    .PC  (PC)
    );
    
    NPC u_NPC(
    .Branch (Badd),
    .IFJ    (Jslice),
    .PCMUX  (PCMUX),
    .NPC    (NPC)
    );
    
    BranchAdd u_BranchAdd(
    .PC     (PC),
    .EXT16  (EXT16),
    .Branch (Branch),
    .Badd   (Badd)
    );
    
    IFJ u_IFJ(
    .PC    (PC[31:28]),
    .imm26 (imm26),
    .rs    (RD1),
    .j     (IFJ),
    .IFJ   (Jslice)
    );
    
    RegisterFile u_RegisterFile(
    .clk      (clk),
    .rst      (rst),
    .A1       (rs),
    .A2       (rt),
    .A3       (RegAddr),
    .WD       (WD),
    .RFWr     (RegWr),
    .RD1      (RD1),
    .RD2      (writedata),
    .reg_sel  (reg_sel),
    .reg_data (reg_data)
    );
    
    ext16 u_ext16(
    	.in   (imm16   ),
        .sign ( extsign),
        .out  (EXT16  )
    );

    mux2 #(5) u_mux2_WhotoEx5(
    	.a   (RD1[4:0]   ),
        .b   (shamt   ),
        .sel (ext5 ),
        .r   (b5in   )
    );
    

    ext5 u_ext5(
    	.in  (b5in ),
        .out (EXT5 )
    );

    mux2 #(32) u_mux2_ALUoprand1(
    	.a   (RD1   ),
        .b   (EXT5   ),
        .sel (ALUop1 ),
        .r   (ALUoprand1   )
    );

    mux2 #(32) u_mux2_ALUoprand2(
    	.a   (writedata   ),
        .b   (EXT16   ),
        .sel (ALUop2 ),
        .r   (ALUoprand2   )
    );

    ALU u_ALU(
    	.A     (ALUoprand1     ),
        .B     (ALUoprand2     ),
        .ALUop (ALUOP ),
        .C     (aluout     ),
        .Zero  (Zero  )
    );
    
    Dextract u_Dextract(
        .MemByte (MemByte ),
        .addr    (aluout[1:0]    ),
        .sign    (MemSign    ),
        .data    (readdata    ),
        .out     (Dextract     )
    );

    mux3 #(5) u_mux3_regdst(
    	.a   (rd   ),
        .b   (rt   ),
        .c   (5'd31   ),
        .sel (RegDst ),
        .out (RegAddr )
    );
    
    mux3 #(32) u_mux3_toreg(
    	.a   (aluout   ),
        .b   (Dextract   ),
        .c   (PC+'d4   ),
        .sel (ToReg ),
        .out (WD )
    );
    
    
    
endmodule
