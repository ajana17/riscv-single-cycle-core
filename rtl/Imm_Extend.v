`timescale 1ns / 1ps
module Imm_Extend(
    input  [31:7] instr,
    input  [1:0]  immsrc,
    output reg [31:0] immext
);
    always @(*) begin
        case (immsrc)
            2'b00: immext = {{20{instr[31]}}, instr[31:20]};                                // I-type
            2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};                  // S-type
            2'b10: immext = {{20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            default: immext = 32'd0;
        endcase
    end
endmodule
