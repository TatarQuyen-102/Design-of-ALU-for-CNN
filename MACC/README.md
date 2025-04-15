Introduce an 8 bit MAC (Multiply Accumulate Unit) which is known as ALU (Arithmetic Logic Unit) to performs all the neural network computations. We utilize MACs, max pooling and ReLU as the activation function. Additionally, we apply an efficient fixed-point that aims to optimize such an accelerator for CNN to make it faster than other method.
Block Diagram of the MACC
![image](https://github.com/user-attachments/assets/6bcb5104-967c-4ac6-a5f7-6182522297f8)

The Macc handles MACs (Radix 4 booth + Carry Save Adder), max pooling, and ReLU as the activation function.

Block diagram of Radix 4 booth
![image](https://github.com/user-attachments/assets/721b3024-1db1-40d5-88a1-f14f4e2211b5)

Block Diagram of the Accumulator
![image](https://github.com/user-attachments/assets/386036ce-0d8b-4b48-9690-d0a58187b7e7)

Block diagram of the Max Pooling
![image](https://github.com/user-attachments/assets/42bf616e-790f-4864-9267-936924b77bb7)

Block diagram of ReLu
![image](https://github.com/user-attachments/assets/4271d2c5-de44-4e52-8cdc-140e25f3327b)
