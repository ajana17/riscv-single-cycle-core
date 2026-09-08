
`timescale 1ns / 1ps
module alu_decoder(
    input [1:0] ALUOp,
    input op5,
    input [2:0] funct3,
    input funct7_5,
    output reg [2:0] control
);
    always @(*) begin
        case (ALUOp)
            2'b00: control = 3'b000; 
            2'b01: control = 3'b001; 
            2'b10: begin             
                case (funct3)
                    3'b000: control = (op5 & funct7_5) ? 3'b001 : 3'b000; 
                    3'b010: control = 3'b101; 
                    3'b110: control = 3'b011; 
                    3'b111: control = 3'b010; 
                    default: control = 3'b000;
                endcase
            end
            default: control = 3'b000;
        endcase
    end
endmodule
