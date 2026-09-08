`timescale 1ns / 1ps
module Data_Mem(
    input clk, rst, WE,
    input  [31:0] A, WD,
    output [31:0] RD
);
    reg [31:0] Data_MEM [0:1023];

    assign RD = (!rst || WE) ? 32'd0 : Data_MEM[A[31:2]];

    always @(posedge clk) begin
        if (WE)
            Data_MEM[A[31:2]] <= WD;
    end

    initial begin
        Data_MEM[7] = 32'h00000020;
    end
endmodule
