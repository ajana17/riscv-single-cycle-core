`timescale 1ns / 1ps
module Control_Unit_Top(
    input  [6:0] Op,
    input  [2:0] funct3,
    input        funct7_5,
    output       RegWrite,
    output [1:0] ImmSrc,
    output       ALUSrc,
    output       MemWrite,
    output       ResultSrc,
    output       Branch,
    output [2:0] ALUControl
);
    wire [1:0] ALUOp;

    main_decoder mainpart (
        .op(Op),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
    );

    alu_decoder alupart (
        .ALUOp(ALUOp),
        .op5(Op[5]),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .control(ALUControl)
    );
endmodule
