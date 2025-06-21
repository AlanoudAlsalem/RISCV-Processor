This repository includes the verilog implementation files of a RISC-V 5-stage pipelined CPU. The CPU implements forwarding to resolve data hazards, cache for improved memory access, and a branch resolver unit with branch prediction functionality for performance enhancement. Additionally, an Python-based assembler was developed to support testing and optimization.

### Block Diagram
![blockDiagram-Page-5](https://github.com/user-attachments/assets/eb4d0ef3-fb5f-4f9f-b737-f221c561571c)

### Benchmarks
Rigorous testing through benchmarks allowed for the validation of the design’s success.

#### Waveforms
Testbench waveforms can be generated for validation, testing, and debugging:
<img width="1415" alt="Screenshot 2025-06-21 at 1 35 11 PM" src="https://github.com/user-attachments/assets/b8879263-55bb-45cc-b903-28570af261dd" />

#### Cycle Output
Module outputs, register file contents, data memory contents, and cycle counts at every positive edge are available for validation, testing, and debugging:
<div align="center">
<img width="700" alt="Screenshot 2025-06-21 at 1 37 35 PM" src="https://github.com/user-attachments/assets/137cec8a-eca3-4a57-bd71-20c9c2d6df05" />
</div>
