`timescale 1ns / 1ps
module Reg_files(
    input clk, rst, WE3,
    input  [4:0]  A1, A2, A3,
    input  [31:0] WD3,
    output [31:0] RD1, RD2
);
    reg [31:0] Registers [31:0];
    integer i;

    assign RD1 = (!rst || A1 == 5'd0) ? 32'd0 : Registers[A1];
    assign RD2 = (!rst || A2 == 5'd0) ? 32'd0 : Registers[A2];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1)
                Registers[i] <= 32'd0;
        end else if (WE3 && (A3 != 5'd0)) begin
            Registers[A3] <= WD3;
        end
    end
endmodule
