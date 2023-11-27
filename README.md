# 《计算机设计实践》

2023年秋季
武汉大学国家网络安全学院 
author:[scarletborder](blog.scarletborders.top)

## 说明
### 实验内容一——单周期CPU 
对示例单周期CPU进行指令扩展，至少支持以下指令（红色和蓝色为增加的指令）
add/sub/and/or/slt/sltu/addu/subu   
addi/ori/lw/sw/beq
j/jal
sll/nor/lui/slti/bne/andi/srl/sllv/srlv/jr/jalr
xor/sra/srav
lb/lh/lbu/lhu/sb/sh (数据在内存中以小端形式存储little endian)

验收要求&实验报告（占55%，以下二选一）
在ModelSim仿真中CPU加载mipstest_extloop.asm、extendedtest.asm和studentnosorting_cut.asm对应代码运行正确 （up to 45%）
如果单周期SCPU只完成仿真，没有下载到开发板，需扩展上述 红色 + 蓝色指令
extendedtest.asm在Mars中做对比时，需设置为Settings -> Memory Configuration -> Compact, Data at address 0
在Nexys 4 DDR 开发板上正确实现学号排序 (up to 55%)
具体说明见后
如果单周期CPU实现下板仿真，也需扩展上述 红色+ 蓝色 指令，对学号排序前和排序后的结果拍照并放入实验报告。


### 实验内容二——多周期CPU
实现多周期CPU，至少支持以下指令（红色为增加的指令）
add/sub/and/or/slt/sltu/addu/subu   
addi/ori/lw/sw/beq
j/jal
sll/nor/lui/slti/bne/andi/srl/sllv/srlv/jr/jalr
能够正确处理多周期CPU中的状态机
指令和数据放在同一个存储器
验收要求&实验报告（占30%，以下二选一）
在ModelSim仿真中CPU加载studentnosorting_cut.asm对应代码运行正确 （up to 18%）
在Nexys 4 DDR2 开发板上正确实现学号排序，对学号排序前和排序后的结果拍照并放入实验报告(up to 30%) 。


