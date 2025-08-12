# MIPS32 Pipelined Processor

## Description

This project implements a **MIPS32 pipelined processor** in Verilog HDL, supporting a rich subset of **50+ MIPS Instructions**. It features a five-stage pipeline, an exception handling unit, and a 2-bit branch prediction mechanism to improve control hazard performance. The design is fully simulation-ready, complete with testbenches, waveform setups, and automation scripts.

## Architecture

// To be added

> For a clearer and scalable view of the architecture, open the `.drawio` block diagram file found in the main directory using [draw.io](https://www.drawio.com/). This allows full zoom and editing capabilities.

## Features

* **Pipelined MIPS32 Architecture**: Five-stage pipeline with hazard handling.
* **Exception Handling Unit**: Detects and manages runtime exceptions like undefined instruction, arithmetic overflow, and divide by zero.
* **2-Bit Branch Prediction**: Reduces control hazards and improves branch accuracy. In testing, it reduced execution time by saving approximately 5000 clock cycles compared to no prediction.
* **50+ instructions supported**, including:
  - R-type: `ADD`, `ADDU`, `MULT`, `MULTU`, `AND`, `OR`, `XOR`, `SLT`, `SLL`, `SRAV`, `JR`, `MFHI`, `MTLO`, ...
  - I-type: `LW`, `SW`, `LB`, `LH`, `ADDI`, `ADDIU`, `ANDI`, `ORI`, `BEQ`, `BNE`, `LUI`, `BLTZ/BGEZ`, ...
  - J-type: `J`, `JAL`
* **Simulation-Ready**: Includes assembly tests converted to `.hex` format for directed verification.
* **Extensible Design**: Modular structure makes it easy to add new instructions or features.
 
>  See `MIPS ISA.xlsx` for a complete list of supported instructions.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

You will need a Verilog/VHDL simulator to run and test the processor. Some popular options are:
* **ModelSim**
* **Xilinx Vivado**
* **Icarus Verilog (Open Source)**

### Simulation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/mo2menwael/MIPS32_Pipelined_Processor.git
    ```
2. **Navigate to the project directory:**
    ```sh
    cd MIPS32_Pipelined_Processor
    ```
3. **Open your simulator, create a new project, add all the RTL files, and run the provided script.** The `run.do` file contains the necessary commands to compile the source code and run the simulation. You can execute it by typing the following command in your simulator console:
    ```tcl
    do run.do
    ```

## Acknowledgement

This project was built with guidance and architecture principles from:

> **David Harris & Sarah Harris** —  
> _Digital Design and Computer Architecture, 2nd Edition_  
> Morgan Kaufmann, ISBN: 978-0123944245
