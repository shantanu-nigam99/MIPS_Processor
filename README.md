# MIPS_Processor
MIPS pipeline processor for Computer Architecture Course

#### The processor looks like this- 
![IMAGE](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/Screenshot%20(58).png)



## PROBLEM STATEMENT
This is the [link](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/Project%20-%201.pdf) to the problem statement.

## MODEL FILES
The [main](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/processor.v)
file is the Processor, run the testbench in this file to simulate.

## INSTRUCTION MEMORY FILES
The instructions are coded according to MIPS instruction format. Idea about how to encode the instruction is shown [here](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/instruction%20memory.pdf)

#### There are 2 different instruction files- 
1.  [Instruction_memory1.txt](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/Instruction_memory1.txt): instructions which have data dependancy, has instructions from the problem statement.
2.  [Instruction_memory_only_add.txt](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/Instruction_memory_only_add.txt): instructions which are free from data dependancy, this helps in checking broader functionality of the processor.

To change the instruction file, go to [memory.v](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/memory.v) file and edit the file name in 17th line.

To get binary code for the instructions I have made a very simple [compiler](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/MIPS_compiler.ipynb). The instructions have to be according to the standard MIPS instruction format as shown [here](https://github.com/shantanu-nigam99/MIPS_Processor/blob/master/instructions.txt). 


## INSTRUCTIONS FOR EXECUTION
1. Copy the directory and compile all.
2. Run tb_processor file in processor.v
