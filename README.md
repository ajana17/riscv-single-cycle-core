# 32-Bit Single-Cycle RISC-V Processor Core

A synthesizable, single-cycle RISC-V processor core modeled in Verilog HDL and verified via behavioral simulation in Xilinx Vivado. This design implements the core single-cycle datapath.

---

## Architecture Overview

The core follows the classic single-cycle datapath model where every instruction completes within one clock cycle:

1. **Instruction Fetch (IF):** The Program Counter (`P_C`) points to the instruction in `Instr_Mem` using word-aligned addressing (`A[31:2]`). A dedicated adder computes $PC + 4$ in parallel.
2. **Instruction Decode (ID):** The instruction opcode is decoded by `Control_Unit_Top` (splitting control across `main_decoder` and `alu_decoder`). Source registers are fetched from `Reg_files`, while `Imm_Extend` constructs sign-extended 32-bit immediate values.
3. **Execute (EX):** The Arithmetic Logic Unit (`alu`) performs arithmetic/logical operations and generates zero and overflow condition flags. A secondary adder calculates the branch target address ($PC + \text{ImmExt}$).
4. **Memory Access (MEM):** If a store instruction is present, `Data_Mem` performs a synchronous write at the calculated address. Load instructions asynchronously read data from memory.

---

## Supported Instruction Set

| Instruction | Type | Format |
|:---|:---:|:---|
| `ADD` | R-type | `add rd, rs1, rs2` | 
| `SUB` | R-type | `sub rd, rs1, rs2` |
| `AND` | R-type | `and rd, rs1, rs2` |
| `OR` | R-type | `or rd, rs1, rs2` |
| `SLT` | R-type | `slt rd, rs1, rs2` |
| `LW` | I-type | `lw rd, offset(rs1)` |
| `SW` | S-type | `sw rs2, offset(rs1)` |
| `BEQ` | B-type | `beq rs1, rs2, label` |

---

## Hardware Modules

* **`alu.v`**: 32-bit arithmetic logic unit handling addition, subtraction, bitwise AND/OR, and signed comparison (`SLT`) with zero and overflow detection.
* **`alu_decoder.v`**: Decodes `ALUOp`, `funct3`, and `funct7` bits into 3-bit ALU operation control vectors.
* **`main_decoder.v`**: Generates high-level datapath controls: `RegWrite`, `MemWrite`, `ResultSrc`, `ALUSrc`, `Branch`, `ImmSrc`, and `ALUOp`.
* **`Control_Unit_Top.v`**: Top-level control decoder encapsulating main and ALU decoding logic.
* **`Imm_Extend.v`**: Immediate generator formatting sign-extended 32-bit constants for I, S, and B instructions.
* **`Reg_files.v`**: 32-register dual-read, single-write register file with `x0` hardwired to zero.
* **`Instr_Mem.v`**: Word-addressable instruction memory (ROM) with initial machine-code program sequences.
* **`Data_Mem.v`**: Word-addressable data memory (RAM) with asynchronous read and synchronous write capabilities.
* **`P_C.v` & `PC_Adder.v`**: Program counter register with asynchronous reset and 32-bit adders for PC incrementing and branch target calculation.
* **`RISC_V_Single_Cycle_Top.v`**: Integrates all modules into the single-cycle processing datapath.

---

## Verification & Simulation

The design was simulated using a custom behavioral testbench (`tb_riscv.v`) running the following test program:

```assembly
lw   x5, 28(x0)     # Load word from Data_Mem[7] (value: 0x00000020) into x5
add  x6, x5, x5     # Compute 32 + 32 = 64 (0x00000040), store in x6
sw   x6, 32(x0)     # Store 64 into Data_Mem[8] (byte address 32)
beq  x0, x0, 0      # Infinite loop trap
