# RISC-VI Processor

# **Timeline**

| Deadline | Objective |
| :---- | :---- |
| June 25 | Finish RISC-IV Datapath \+ Vivado |
| September 5 | Finish OS Binary Code |
| August 1 | Purchase breadboard materials and components |
| August 10 | Send PCB Design to AIM Research Company. |
| August 17 | Assemble processor |
| September 30 | Finish Assembly Language \+ Compiler |

# **Documentation**

| Daily Progress  |  |  |  |
| :---- | :---- | :---- | :---- |
| ![Dates][image1] Date | ![No type][image2] Task | ![People][image3] Owner | ![Dropdowns][image4] Status |
| May 20, 2025 | Set up doc | [Tanmay](mailto:garudadri.tanmay17@gmail.com)[jiaypotato@gmail.com](mailto:jiaypotato@gmail.com) | Complete |
| May 21, 2025 | Began ISA Draft. Drafted register file. Began ALU without pipelining. Added CPU core module definition. | [Tanmay](mailto:garudadri.tanmay17@gmail.com) | Complete |
| May 22, 2025 | Research memory caching and implement basic 4 byte addressable, 4096 address space memory. | [Tanmay](mailto:garudadri.tanmay17@gmail.com) | Complete |
| May 29, 2025 | Write more of the ISA. | [Tanmay](mailto:garudadri.tanmay17@gmail.com) | Complete |
| Jun 3, 2025 | Finish Un-privileged ISA | [Tanmay](mailto:garudadri.tanmay17@gmail.com) | In progress |

## **Processor Documentation**

The RISC-VI Processor is a successor to the popular RISC-V processor. Based on the Von Neumann Architecture, it was designed and built using System Verilog in Xilinx Vivado.  
Code Repository Github: https://github.com/Doubleimpala/RISC-VI

### Instruction Set Architecture

RISC-VI is a 32-bit architecture. Instructions are 32 bits long.

#### Instruction Guide: 

	Instruction layout:  
Opcode: \[6:0\]  
		Description: Instruction description.  
		Encoding Format: Format for bits \[31:7\].  
	  
	**P-Type:** Processing Instructions:  
	ADD: 

- 0000001  
- Adds the contents of two operand registers and stores result in the destination register.  
  - 

	SUB:

- 0000010  
- Subtracts the contents of the second operand register from the first operand register. Stores result in the destination register.  
  - 

	OR: 

- 0000011  
- Performs logical OR on the contents of two operand registers and stores result in the destination register.  
  - 

	AND:

- 0000100  
- Performs logical AND on the contents of two operand registers and stores result in the destination register.  
  - 

	  
**J-Type:** Jump and Break Instructions:  
	BRCC:

- 0001000  
- Conditional break. If condition codes match the 3 bit nzp operand condition, then this instruction adds an offset to the program counter.  
  - \[9:7\] Operand condition  
  - \[31:10\] imm25, 25 bit immediate signed offset.

	BR:

- 0001001  
- Conditional break. If the value of the first operand register is greater than the second operand register, code p. If the values of both operand registers are equal, code z. If the value of the first operand register is less than the second operand register, code n.

  If condition codes match the 3 bit nzp operand condition, then this instruction adds an offset to the program counter.

  - \[9:7\] Operand condition  
  - \[21:10\] 12 bit offset  
  - \[26:22\] Operand Register 2  
  - \[31:27\] Operand Register 1

	JMP:

- 0001010  
- Unconditional jump. Stores PC in register x1.  
  - .

	RET:

- 0001011  
- Return from subprocess. Restores PC from register x1.  
  - \[\]

	  
	**M-Type:** Memory Instructions:  
	LD:

- 0010000  
- Loads the contents at the memory address \- found with program counter \+ offset- into the destination register.  
  - 

	LDR:

- 0010001  
- .  
  - 

	ST:

- 0010010  
- .  
  - 

	STR:

- 0010011  
- .  
  - 

	  
	**A-Type:**  
	TRAP**:** TRAP Routine Call.  
		HALT**:** Halt TRAP routine. Trap Vector: x0.  
		PUT:  
		  
	Op-Code: 0000000  
	**Privileged:**  
	INT: Interrupt Routine Call.  
		EXP: Exception Interrupt Routine. Int Vector: x0  
	Op-Code: 

### Datapath Overview

Diagram: 

### Controller

	

### Processing Unit

#### **Register file**

	Contains 32 registers, each one 5 bit addressable, supporting 4 byte data.  
	Register x0 is the zero register, automatically hardwired to 32’b0.

	Input signals:

- clk: Processor clock signal.  
- rst: Register reset signal  
- rw: Read/Write signal. (R=0, W=1)  
- \[4:0\] source1: Source register 1 address.  
- \[4:0\] source2: Source register 2 address.  
- \[4:0\] dest: Destination register address.  
- \[31:0\] write\_data: 32 bits of data to be loaded into the destination register.

	Output signals:

- \[31:0\] read\_data1: Data from source register 1\.  
- \[31:0\] read\_data2: Data from source register 2\.

#### **ALU**

	Performs 4 functions. Addition, subtraction, bitwise AND, bitwise OR.  
	Input signals:

- clk: Processor clock signal. (For future pipelining)  
- \[2:0\] func: Function selection signal. Allows 8 functions.  
- \[31:0\] operand\_1: First 4 byte operand.  
- \[31:0\] operand\_2: Second 4 byte operand.

	Output signals:

- \[31:0\] result: 4 byte result of the operation.

	Function guide:  
key: \[2:0\] func inputs \-\> operation

- 000 \-\> op1 \+ op2  
- 001 \-\> op1 \- op2  
- 010 \-\> op1 & op2  
- 011 \-\> op1 | op2  
- Default \-\> 32’b0

### Memory

	**MAR:** Memory Address Register  
		Size: 32 bits.  
	  
		Input signals:

- clk: Processor clock signal.  
- ld: Load signal from processor controller.  
- \[31:0\] address\_in: 32 bit value connected directly to the bus.


		Output signals:

- \[31:0\] address\_out: Connects to the address decoder of the memory.

	**Memory**:   
32 bit addressable, 4096 bit address space.

		Input signals:

- clk: Processor clock signal.  
- \[31:0\] address: 32 bit address truncated to \[11:0\].

		Output signals:

- \[31:0\] data: 32 bit value stored at address.

	  
**MDR:** Memory Data Register:  
Size: 32 bits.

Input signals:

- clk: Processor clock signal.  
- \[31:0\] data\_in: 32 bit data currently output by memory.


		Output signals:

- \[31:0\] data\_out: 32-bit data output to bus via tri-state buffer.

### Bus

	A 32 bit bus, and tri-state buffers for all inputs.

	List of bus inputs via tri-state buffers:

- MDR  
- .  
  List of bus outputs:  
- 

### I/O

## **FPGA Implementation**

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAQCAYAAAAWGF8bAAAAyklEQVR4XtWT0Q3CMAxEOwIjMAIjRErOyWdHYANGoCOwQUdghI7ACIzACGAHWWpNUR2JH0461bomT4mTdN3fKpSyT5meNk8ZEzLdbf5VIYRdIhpixkWAUs8tMM4fUhNRb+d/qEIaLAuwjIXqwJKCzddUgdwamy8kg2S7KOW4ZTewxT7gr7esQKnlG4CDXhU+3TMyRv3fBORenjTXKyIAhTQDt9QEnL8UAPVEpY6UrlzfdKwbaPM1+YH8Xrl/45ZdwEixf0M9xmTnvwDJcbf8f124twAAAABJRU5ErkJggg==>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAQAQMAAAAs1s1YAAAABlBMVEUAAABER0byc6G0AAAAAXRSTlMAQObYZgAAAB9JREFUeF5jYEAD9h8YmEA0MwOYZmSWWQjhs4H56BgAT4ECDeGaeV4AAAAASUVORK5CYII=>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAQCAMAAAAhxq8pAAADAFBMVEUAAABAQEBERkZFR0ZER0ZDR0VISEhFRUVERkVER0ZDR0dDRkNESERDRkZER0VESEhESEZCR0RDR0ZER0dERkZGRkZDRkRARUVASEhERkVFSEhDR0VER0ZGRkZDR0VFSEVFRUVFR0VER0YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACxWeV0AAAAInRSTlMAEH/fz58gMO/vn1BAoL9AgHDfcIBQoDAgz2CQr19vYGBvGxXIWQAAAIJJREFUeF5jYKAIMMIYHFIMDE9/QthMUDFmqRevGKRhKqBASQhECEM4MJUM32EMIGCG0n/FvwhLMDyDcFiggp9YZBkYvkI5WAFMO6M04x9p9m9QDpiUZofKMTz5BRNUYnjG8gXE4BVl+Pwa5qTPP8BiDJ/vMfAywGznBTERAO54ZAAAT90XrfZ0HKwAAAAASUVORK5CYII=>

[image4]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAQCAYAAAAWGF8bAAAAx0lEQVR4Xu2TYRHCMAyFKwEJSEBCjyVpXIAEHIATJCBhEpCAhEkA0tEtTVcod/zku8ufvDR7fduc+/NTmHkNge6t1QU82x0TQHRMg8i4t7rGI266QJc0b3Xt7Gq1d3jvV69zQyZUn9QAMHg5K8vnpuTBtFNzXzEawj5rKL0AmE7pFku3KXrR8jPHeaRELy00m2NhuYIstT1hPB8OqoF9dKmDbQQD3ZZcTznIJ2S1GmlZ5k4DhENa3FrbDz+Bk5eTIqhVdFbJ8wG0lJX5M/zhmwAAAABJRU5ErkJggg==>