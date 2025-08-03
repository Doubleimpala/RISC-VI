# RISC VI Development Log

## RISC-VI Processor

The RISC-VI Processor is an unofficial successor to the popular RISC-V processor.
Based on the **Von Neumann Architecture**, it is being designed and built using **System Verilog**.
Synthesizing and testing is done in **Xilinx Vivado**.

This document is the development log and guide to the processor.
Updated daily with progress.

---

## Timeline

| Deadline     | Objective                            |
| ------------ | ------------------------------------ |
| TBD          | Finish RISC-IV Datapath + Simulation |
| September 5  | Finish OS Binary Code                |
| September 30 | Finish Assembly Language + Compiler  |

---

## Daily Progress

| Date         | Task                                                                                                                                   | Assigned | Status      |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------- | -------- | ----------- |
| May 20, 2025 | Set up doc                                                                                                                             | Tanmay   | Complete    |
| May 21, 2025 | Began ISA Draft. Drafted register file. Began ALU (no pipelining). Added CPU core module.                                              | Tanmay   | Complete    |
| May 22, 2025 | Researched memory caching. Implemented 4-byte addressable, 4096 address space memory.                                                  | Tanmay   | Complete    |
| May 29, 2025 | Wrote more of the ISA.                                                                                                                 | Tanmay   | Complete    |
| Jul 28, 2025 | Finish Un-privileged ISA                                                                                                               | Tanmay   | In progress |
| Jul 30, 2025 | Finish Privileged ISA: trap vectors, interrupts. Define pipeline stages (IF, ID, EX, MEM, WB).                                         | Tanmay   | Not started |
| Aug 2, 2025  | Finish instruction FSM/microcodes in control unit. Determine control signals and instruction decoder logic.                            | Tanmay   | Not started |
| Aug 11, 2025 | Create pipeline register modules (IF/ID, ID/EX, EX/MEM, MEM/WB). Add hazard detection skeleton. Integrate ALU, memory, reg file.       | Tanmay   | Not started |
| Aug 15, 2025 | Add branch/jump resolution logic. Implement basic branch predictor. Handle mispredictions. Test branch-heavy programs.                 | Tanmay   | Not started |
| Aug 31, 2025 | Hook up trap handler. Build CSR logic. Handle ECALL, EBREAK, TRAP-like instructions.                                                   | Tanmay   | Not started |
| Sep 7, 2025  | Finalize processor top module. Write testbench and memory preload script. Simulate instruction traces. Run a basic program end-to-end. | Tanmay   | Not started |

---

## Documentation

### Processor Documentation

* The RISC-VI Processor is based on the Von Neumann Architecture.
* Written in **System Verilog**, tested using **Xilinx Vivado**.
* [Code Repository (GitHub)](https://github.com/Doubleimpala/RISC-VI)

---

### Instruction Set Architecture

* **32-bit architecture**
* **Instructions are 32 bits long**

#### Instruction Layout

* **Opcode:** `[6:0]`

---

#### P-Type: Processing Instructions

##### ALU (Opcode: `0000001`)

* Performs selected operation on two operand registers.
* Stores result in destination register.
* `funct3 [9:7]`:

  * `000`: ADD
  * `001`: SUB
  * `010`: OR
  * `011`: AND
  * `100`: MUL
  * `101`: DIV
  * `110`: XOR
  * `111`: NOR
* `[16:11]`: `funct6`
* `[21:17]`: Destination Register
* `[26:22]`: Operand Register 2
* `[31:27]`: Operand Register 1

##### ALUI (Opcode: `0000010`)

* Operates on one register + immediate.
* Stores result in destination register.
* `funct3 [9:7]` same as above, ending with:

  * `111`: Unused
* `[21:10]`: 12-bit Immediate
* `[26:22]`: Destination Register
* `[31:27]`: Operand Register

##### SHIFT (Opcode: `0000011`)

* Shift operation using register or immediate.
* `funct3 [9:7]`:

  * `000`: SLL
  * `001`: SRL
  * `010`: SRA
  * `011`: SLLI
  * `100`: SRLI
  * `101`: SRAI

---

#### J-Type: Jump and Break Instructions

##### BRCC (Opcode: `0001000`)

* Conditional break using NZP flags
* `[9:7]`: Operand condition
* `[31:10]`: 25-bit signed immediate offset

##### BR (Opcode: `0001001`)

* Compare two registers, conditional jump
* `[9:7]`: Operand condition
* `[21:10]`: 12-bit offset
* `[26:22]`: Operand Register 2
* `[31:27]`: Operand Register 1

##### JAL (Opcode: `0001010`)

* Unconditional jump, stores PC in dest reg
* `[26:7]`: 20-bit immediate
* `[31:27]`: Destination Register

##### JALR (Opcode: `0001011`)

* Jump to reg + imm, store PC in reg
* `[21:7]`: 15-bit immediate
* `[26:22]`: Destination Register
* `[31:27]`: Operand Register

##### RET (Opcode: `0001100`)

* Return from subroutine
* `[31:27]`: Operand Register (holds return addr)

---

#### M-Type: Memory Instructions

##### Memory Loads (Opcode: `0010000`)

* `funct3 [9:7]`:

  * `000`: LD — PC + offset → dest
  * `001`: LDR — reg + offset → dest
  * `010`: LB — lower 8 bits, sign-extended
  * `011`: LBU — lower 8 bits, zero-extended
  * `100`: LH — lower 16 bits, sign-extended
  * `101`: LHU — lower 16 bits, zero-extended

##### Memory Stores (Opcode: `0010001`)

* `funct3 [9:7]`:

  * `000`: ST — PC + offset ← reg value
  * `001`: STR — reg2 + offset ← reg1 value
  * `010`: SB — Store lower 8 bits
  * `011`: SH — Store lower 16 bits

---

#### A-Type

##### TRAP

* `HALT`: Vector x0
* `PUT`: Output
* `INT`, `EXP`: Interrupts, exceptions

---

## Datapath Overview

### Controller

Handles instruction control logic.

---

### Processing Unit

#### Register File

* 32 registers, 4 bytes each.
* `x0` is always `0`.

**Inputs**:

* `clk`, `rst`, `rw`
* `source1`, `source2`, `dest` (5-bit addresses)
* `write_data` (32-bit)

**Outputs**:

* `read_data1`, `read_data2` (32-bit)

#### ALU

* Functions: ADD, SUB, AND, OR, SLL, SRL, SRA

**Inputs**:

* `clk`, `func` (3-bit), `operand_1`, `operand_2`

**Output**:

* `result` (32-bit)

---

### Memory

#### MAR: Memory Address Register

* Size: 32 bits
  **Inputs**: `clk`, `ld`, `address_in`
  **Output**: `address_out`

#### Main Memory

* Byte addressable, 16384-bit address space
  **Inputs**: `clk`, `address` (12-bit truncated)
  **Output**: `data`

#### MDR: Memory Data Register

**Inputs**: `clk`, `data_in`
**Output**: `data_out`

---

### Bus

* 32-bit shared bus
* All inputs use tri-state buffers

**Inputs**: MDR, etc.
**Outputs**: TBD

---

### I/O

---

## Compiler and Assembly Notes

* `NOT` instruction uses `funct3 = 111` with zero register
* Same opcode can map to multiple mnemonics

---

## FPGA Documentation
