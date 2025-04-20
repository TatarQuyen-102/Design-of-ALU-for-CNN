# 🧠 8-bit MACC (Multiply Accumulate Unit) for CNN Acceleration

This project introduces an **8-bit Multiply Accumulate Unit (MACC)**, also referred to as an **Arithmetic Logic Unit (ALU)**, specifically designed to accelerate Convolutional Neural Network (CNN) computations on FPGA.

We implement:

- ✅ **MAC operations** using Radix-4 Booth encoding + Carry Save Adder (CSA)
- ✅ **Max Pooling**
- ✅ **ReLU Activation**
- ✅ **Fixed-point optimization** for high performance

This efficient hardware accelerator improves latency, throughput, and area compared to conventional methods.

---

## 📦 System Overview

### 🔲 MACC Block Diagram
<img src="https://github.com/user-attachments/assets/6bcb5104-967c-4ac6-a5f7-6182522297f8" width="400"/>

The MACC integrates core CNN components: multiplier, accumulator, pooling, and ReLU activation.

---

## 🔧 Components Breakdown

### ⚙️ Radix-4 Booth Multiplier  
<img src="https://github.com/user-attachments/assets/721b3024-1db1-40d5-88a1-f14f4e2211b5" width="400"/>

This multiplier performs signed multiplication using radix-4 Booth encoding and partial product selection for better efficiency.

---

### ➕ Accumulator (Carry Save Adder)  
<img src="https://github.com/user-attachments/assets/386036ce-0d8b-4b48-9690-d0a58187b7e7" width="400"/>

The CSA accumulates multiplication results with minimal carry propagation, enhancing speed.

---

### 🌀 Max Pooling  
<img src="https://github.com/user-attachments/assets/42bf616e-790f-4864-9267-936924b77bb7" width="400"/>

Applies max pooling to reduce spatial dimensions while retaining the most critical features.

---

### ⚡ ReLU Activation  
<img src="https://github.com/user-attachments/assets/4271d2c5-de44-4e52-8cdc-140e25f3327b" width="400"/>

Implements the `ReLU(x) = max(0, x)` activation function to introduce non-linearity in neural network layers.

---

## 🛠️ Implementation Details

- **Platform**: Nexyx 4 DDR 
- **Language**: Verilog   
- **Simulation Tool**: Icarus Verilog  
- **Synthesis Tool**: Xilinx Vivado  
- **Target Applications**: CNN accelerators (e.g., image classification, edge inference)

---

## 📈 Evaluation Metrics

We evaluate the design based on:

- ⏱️ **Latency**  
- 📊 **Throughput**  
- 💾 **FPGA Resource Utilization (LUTs, FFs, DSPs)**

---

## 📂 Folder Structure

```bash
.
├── src/                # Verilog source files (MACC, ReLU, Pooling, Booth, etc.)
├── tb/                 # Testbenches for each module
├── sim/                # Simulation results
├── docs/               # Architecture diagrams and documentation
└── README.md           # Project overview
