# 多周期cpu分析
au:scarletborder
## 支持指令
add/sub/and/or/slt/sltu/addu/subu   
addi/ori/lw/sw/beq
j/jal
sll/nor/lui/slti/bne/andi/srl/sllv/srlv/jr/jalr
比单周期少，尤其是lb,sb这种存取指令。可以简化memory out端口

### 分析与案例差异
多了jr,jalr，于是PCSource需要拓展（PC+4|branch|拼接imm26|来源于rs）
多了各种移位，需要拓展第一操作数支持shamt，以及配套的零拓展

## 分析流程

1. IF取指

2. ID译码

    1. EXE 计算
    根据译码结果，将寄存器数据或者处理后的指令某些位传入ALU计算
    add,sub,and,or,slt,sltu,addu,subu,addi,sll,
    nor,lui,slti,andi,srl,sllv,srlv
        1. WB 写回
        将ALUout写回寄存器

    2. EXE 条件跳转
    beq,bne

    3. EXE 读写
    sw,lw
        1. MEM 内存单元
        sw,lw
           1. WB 写回
           lw
    4. 返回 
    无条件跳转直接根据信号更新PC
    j,jal,jr,jalr

## 控制单元
每次clk将nextstate赋值给state，触发下方监听决定各个具体信号