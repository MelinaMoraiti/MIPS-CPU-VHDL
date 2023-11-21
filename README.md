# MIPS CPU Implementation in VHDL

This repository contains the VHDL implementation of a simple MIPS processor. The processor takes reset and clock signals as inputs and has no direct outputs. The reset signal resets the program counter (PC) to zero, initializes the register file, and sets all registers to zero.
## Processor Components
1. ALU
2. Register File
3. Data Memory
4. Instruction Memory (implemented as ROM)
5. Control Unit
6. ALU Control Unit
7. Program Counter (PC)
8. 2-to-1 5-bit Multiplexer
9. Sign Extension Unit (16-to-32)
10. 10, 11, 12. 2-to-1 32-bit Multiplexers
11. ~~Left Shift Unit (32-bit)~~ (not used for this implementation)
__(When the Branch signal and the Zero signal from the ALU both have a value of 1 then a branch instruction (bne) is to be executed, the branch address must not be shifted 2 Bits left or else multiplied by 4 because the instruction memory consists of word lines (32 bits) and not bytes (8 bits) as in the normal implementation. In the normal implementation this unit is used for memory alignment due to each instruction starting at an address that is a multiple of 4)__
13. 14, 15. 32-bit Adders
14. 2-input AND Gate
    
The processor supports the following instructions: **add, sub, addi, lw, sw, bne.**

## Specifications

- Instruction Memory Size: 16 locations (32 bits each)
- Data Memory Size: 16 locations (32 bits each)
- Register File Size: 16 registers (32 bits each)
- After executing each instruction, __the content of the PC increases by 1.__

## Instructions

__Section of code in Assembly that will be placed in instruction memory, starting at position 0, to be executed by the processor.__

```assembly
addi $0, $0, 0      # Not necessary (registers are already zeroed)
addi $2, $2, 0      # Not necessary (registers are already zeroed)
addi $2, $4, 0      # Not necessary (registers are already zeroed)
addi $3, $0, 1
addi $5, $0, 3
L1: add $6, $3, $0
sw $6, 0($4)
addi $3, $3, 1
addi $4, $4, 1
addi $5, $5, -1
bne $5, $0, L1
```
## How to run

1. Open the VHDL project in your preferred simulation tool (e.g ModelSim)
2. Load the VHDL Files
3. Compile the Design
4. Load the Testbench
5. Run the Simulation
6. Observe Results.
   
Waveform diagrams show on each positive edge of the clock pc points to the next instruction and the corresponding instruction is loaded, but the contents of registers or memory
data for this instruction are changed to the next positive edge.
Registers values and memory locations should verify that the assembly code produces correct results.

## License
This project is licensed under the MIT License - see the LICENSE file for details.



