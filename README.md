# RISC-VI Processor

## Timeline

| Deadline       | Objective                                      |
|---------------|--------------------------------------------------|
| June 25       | Finish RISC-IV Datapath + Vivado               |
| August 1      | Purchase breadboard materials and components    |
| August 10     | Send PCB Design to AIM Research Company         |
| August 17     | Assemble processor                              |
| September 5   | Finish OS Binary Code                           |
| September 30  | Finish Assembly Language + Compiler             |

---

## Documentation

### Daily Progress

| Date         | Task                                                                                   | Owner                                                                                      | Status     |
|--------------|------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|------------|
| May 20, 2025 | Set up doc                                                                             | [Tanmay](mailto:garudadri.tanmay17@gmail.com), [jiaypotato@gmail.com](mailto:jiaypotato@gmail.com) | Complete   |
| May 21, 2025 | Began ISA Draft. Drafted register file. Began ALU. Added CPU core module definition.    | [Tanmay](mailto:garudadri.tanmay17@gmail.com)                                               | Complete   |
| May 22, 2025 | Research memory caching and implement 4-byte addressable, 4096 address space memory     | [Tanmay](mailto:garudadri.tanmay17@gmail.com)                                               | Complete   |
| May 29, 2025 | Write more of the ISA                                                                  | [Tanmay](mailto:garudadri.tanmay17@gmail.com)                                               | Complete   |
| June 3, 2025 | Finish Unprivileged ISA                                                                | [Tanmay](mailto:garudadri.tanmay17@gmail.com)                                               | In progress |

---

## Processor Documentation

The RISC-VI Processor is a 32-bit Von Neumann Architecture CPU designed using SystemVerilog in Xilinx Vivado.

**Code Repository:** [GitHub - RISC-VI](https://github.com/Doubleimpala/RISC-VI)

---

### Instruction Set Architecture (ISA)

- **Word Size:** 32-bit
- **Instruction Size:** 32 bits

#### Instruction Format
- **Opcode:** [6:0]
- **Encoding Format:** [31:7] (varies by instruction type)

#### Instruction Types

**P-Type (Processing Instructions)**
- `ADD` - 0000001: Adds operand registers
- `SUB` - 0000010: Subtracts operand2 from operand1
- `OR`  - 0000011: Bitwise OR
- `AND` - 0000100: Bitwise AND

**J-Type (Jump and Branch)**
- `BRCC` - 0001000: Conditional PC update with NZP flags
  - [9:7] Condition
  - [31:10] 25-bit signed immediate
- `BR` - 0001001: Conditional jump using two operands
  - [9:7] Condition, [21:10] 12-bit offset, [26:22] R2, [31:27] R1
- `JMP` - 0001010: Unconditional jump. Saves PC to x1
- `RET` - 0001011: Restore PC from x1

**M-Type (Memory Instructions)**
- `LD`  - 0010000: Load from PC-relative offset into destination
- `LDR` - 0010001: TBD
- `ST`  - 0010010: TBD
- `STR` - 0010011: TBD

**A-Type (Trap Instructions)**
- `TRAP` - Trap Routine Call
  - `HALT`: Vector x0
  - `PUT`: TBD
  - OpCode: 0000000

**Privileged**
- `INT`: Interrupt
  - `EXP`: Exception Vector x0

---

### Datapath Overview

**(Diagram Placeholder)**

---

### Controller

**(To be added)**

---

### Processing Unit

#### Register File
- 32 registers (x0-x31)
- x0 hardwired to 32'b0
- 5-bit addressing
- 32-bit data

**Inputs:**
- clk, rst, rw
- [4:0] source1, source2, dest
- [31:0] write_data

**Outputs:**
- [31:0] read_data1, read_data2

#### ALU
- 4 operations: ADD, SUB, AND, OR

**Inputs:**
- clk
- [2:0] func
- [31:0] operand_1, operand_2

**Outputs:**
- [31:0] result

**Function Guide:**
- 000 → ADD
- 001 → SUB
- 010 → AND
- 011 → OR
- default → 32'b0

---

### Memory System

#### Memory Address Register (MAR)
- 32-bit

**Inputs:**
- clk, ld
- [31:0] address_in

**Outputs:**
- [31:0] address_out

#### Memory
- 4096 address space (12-bit truncated addressing)
- 32-bit word size

**Inputs:**
- clk
- [31:0] address

**Outputs:**
- [31:0] data

#### Memory Data Register (MDR)
- 32-bit

**Inputs:**
- clk
- [31:0] data_in

**Outputs:**
- [31:0] data_out

---

### Bus

- 32-bit shared bus
- Tri-state buffers for all I/O

**Inputs via Tri-State:**
- MDR, (others TBD)

**Outputs:**
- (TBD)

---

### I/O

**(To be added)**

---

## FPGA Implementation

**(Images and diagrams to be added)**

