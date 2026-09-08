`timescale 1ns / 1ps
module alu(
    input  [31:0] a, b,
    input  [2:0]  control,
    output [31:0] y,
    output        n, z, o, c,
    output [31:0] e
);
    wire [31:0] a_and_b = a & b;
    wire [31:0] a_or_b  = a | b;
    wire [31:0] not_b   = ~b;
    wire [31:0] mux_b   = control[0] ? not_b : b;
    wire [31:0] sum;
    wire carry;

    assign {carry, sum} = a + mux_b + control[0];

    wire overflow = (~control[1]) & (a[31] ^ sum[31]) & (~(control[0] ^ a[31] ^ b[31]));
    wire slt = sum[31] ^ overflow;
    assign e = {{31{1'b0}}, slt};

    assign y = (control == 3'b000) ? sum :      // ADD
               (control == 3'b001) ? sum :      // SUB
               (control == 3'b010) ? a_and_b :  // AND
               (control == 3'b011) ? a_or_b :   // OR
               (control == 3'b101) ? e : 32'd0; // SLT

    assign z = (y == 32'd0);
    assign n = y[31];
    assign c = carry & (~control[1]);
    assign o = overflow;
endmodule
