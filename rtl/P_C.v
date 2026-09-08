`timescale 1ns / 1ps

module P_C(
    input clk,
    input rst,
    input  [31:0] PC_NEXT,
    output reg [31:0] PC
);

    always @(posedge clk or negedge rst) begin
        if (!rst)
            PC <= 32'd0;
        else
            PC <= PC_NEXT;
    end

endmodule
