`timescale 1ns / 1ps
module RISC_V_Single_Cycle_Top(
    input clk,
    input rst
);
    // PC signals
    wire [31:0] PC, PCNext, PCPlus4, PCTarget;
    wire PCSrc;

    wire [31:0] Instr;

    // Control signals
    wire RegWrite, ALUSrc, MemWrite, ResultSrc, Branch;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;

    wire [31:0] RD1, RD2, WriteData;

    wire [31:0] ImmExt;

    wire [31:0] SrcA, SrcB, ALUResult;
    wire Zero;

    wire [31:0] ReadData, Result;

    assign PCNext = PCSrc ? PCTarget : PCPlus4;

    P_C pc_unit (
        .clk(clk),
        .rst(rst),
        .PC_NEXT(PCNext),
        .PC(PC)
    );

    PC_Adder pc_add4 (
        .a(PC),
        .b(32'd4),
        .c(PCPlus4)
    );

    PC_Adder pc_branch (
        .a(PC),
        .b(ImmExt),
        .c(PCTarget)
    );

    Instr_Mem imem (
        .rst(rst),
        .A(PC),
        .RD(Instr)
    );

    Control_Unit_Top control_unit (
        .Op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7_5(Instr[30]),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );

    assign PCSrc = Branch & Zero;

    Reg_files reg_file (
        .clk(clk),
        .rst(rst),
        .WE3(RegWrite),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WD3(Result),
        .RD1(RD1),
        .RD2(RD2)
    );

    Imm_Extend imm_ext (
        .instr(Instr[31:7]),
        .immsrc(ImmSrc),
        .immext(ImmExt)
    );

    assign SrcA = RD1;
    assign SrcB = ALUSrc ? ImmExt : RD2;
    assign WriteData = RD2;

    alu alu_core (
        .a(SrcA),
        .b(SrcB),
        .control(ALUControl),
        .y(ALUResult),
        .n(),
        .z(Zero),
        .o(),
        .c(),
        .e()
    );

    //.......Data Memory
    Data_Mem dmem (
        .clk(clk),
        .rst(rst),
        .WE(MemWrite),
        .A(ALUResult),
        .WD(WriteData),
        .RD(ReadData)
    );

    assign Result = ResultSrc ? ReadData : ALUResult;

endmodule
