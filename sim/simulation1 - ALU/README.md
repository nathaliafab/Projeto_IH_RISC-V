# Simulation Results

## ADDI, OR, ADD, SLL, SRL, SRA, SLT, SLTU, SLTI, SLTIU, SLLI, SRLI, SRAI, XORI, ORI, ANDI, XOR

We conducted a simulation using the instructions provided in the file [instruction.mif](instruction.mif) and the testbench [tb_top](/verif/tb_top.sv) to evaluate the pipeline's functionality.

The obtained result matches the expected outcome, which can be verified below.

### Instructions Tested

The simulation included testing the following instructions:

```assembly
addi x0,x0,0
addi x1,x0,8
addi x2,x0,4
or x3,x1,x2
or x4,x2,x0
add x6,x4,x2
addi x4,x0,2
addi x5,x0,-2
sll x18,x1,x4
srl x19,x5,x4
sra x20,x5,x4
slt x21,x1,x2
slt x22,x2,x1
sltu x23,x5,x1
sltu x24,x1,x5
slti x25,x1,8
slti x26,x1,16
addi x5,x0,-4
sltiu x27,x1,-2
sltiu x28,x5,-2
slli x29,x5,1
srli x30,x5,1
srai x31,x5,1
xori x6,x1,10
ori x7,x1,2
andi x8,x1,10
xor x9,x1,x2
```

### Registers after each instruction

The following information is extracted from the simulation log and can be interpreted as demonstrated in the example below:

```shell
tt: Register [x] written with value: [hhhhhhhh] | [dddddddd]
```

In the above example, `tt` represents the simulation time, `x` represents the register number, `hhhhhhhh` represents the hexadecimal value stored in the register, and `dddddddd` represents the same value in decimal.

---

```shell
55: Register [ 0] written with value: [00000000] | [          0]
65: Register [ 1] written with value: [00000008] | [          8]
75: Register [ 2] written with value: [00000004] | [          4]
85: Register [ 3] written with value: [0000000c] | [         12]
95: Register [ 4] written with value: [00000004] | [          4]
105: Register [ 6] written with value: [00000008] | [          8]
115: Register [ 4] written with value: [00000002] | [          2]
125: Register [ 5] written with value: [fffffffe] | [         -2]
135: Register [18] written with value: [00000020] | [         32]
145: Register [19] written with value: [3fffffff] | [ 1073741823]
155: Register [20] written with value: [ffffffff] | [         -1]
165: Register [21] written with value: [00000000] | [          0]
175: Register [22] written with value: [00000001] | [          1]
185: Register [23] written with value: [00000000] | [          0]
195: Register [24] written with value: [00000001] | [          1]
205: Register [25] written with value: [00000000] | [          0]
215: Register [26] written with value: [00000001] | [          1]
225: Register [ 5] written with value: [fffffffc] | [         -4]
235: Register [27] written with value: [00000001] | [          1]
245: Register [28] written with value: [00000001] | [          1]
255: Register [29] written with value: [fffffff8] | [         -8]
265: Register [30] written with value: [7ffffffe] | [ 2147483646]
275: Register [31] written with value: [fffffffe] | [         -2]
285: Register [ 6] written with value: [00000002] | [          2]
295: Register [ 7] written with value: [0000000a] | [         10]
305: Register [ 8] written with value: [00000008] | [          8]
315: Register [ 9] written with value: [0000000c] | [         12]
```

## SUB, AND, LUI

- [luiandsub.mif](luiandsub.mif)

### Instructions Tested

```assembly
addi x1,x0,8
sub x6,x6,x1
and x7,x6,x1
lui x6,3
```

### Registers after each instruction

```shell
55: Register [ 1] written with value: [00000008] | [          8]
65: Register [ 6] written with value: [fffffff8] | [         -8]
75: Register [ 7] written with value: [00000008] | [          8]
85: Register [ 6] written with value: [00003000] | [      12288]
```
