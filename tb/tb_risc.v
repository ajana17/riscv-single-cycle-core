`timescale 1ns / 1ps

module tb_riscv;
    reg clk;
    reg rst;

    RISC_V_Single_Cycle_Top dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;

        #3;
        rst = 1;

        #250;
        $finish;
    end
endmodule
