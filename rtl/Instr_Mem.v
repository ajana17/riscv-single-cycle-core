`timescale 1ns / 1ps

module Instr_Mem(
    input         rst,
    input  [31:0] A,
    output [31:0] RD
);

    reg [31:0] Mem [0:1023];
    integer i;

    assign RD = (!rst) ? 32'd0 : Mem[A[31:2]];

    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            Mem[i] = 32'h00000013;
        end

        Mem[0] = 32'h01C02283;

        Mem[1] = 32'h00528333;

        Mem[2] = 32'h02602023;

        //Infinite loop on itself
        Mem[3] = 32'h00000063;
    end

endmodule
