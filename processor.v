//the model is based on L-16-Slide-6

module processor(input reg clk, rst, initializeMemoryinstr,printOutputdata);

	reg [31:0]if_id_pc_plus4; //if_id (64 bits)= if_id_pc_plus4(reg) + instr_memout(wire{internal register present in memory module})  
	reg [78:0]id_ex; // also wire A[31:0], B[31:0] and control signals(wire, registers are internal to the controller) are a part of this
	reg [74:0]ex_mem; // ALUout, zero and overflow should also be a part of this register (wires, registers are internal to the module) 
	reg [38:0]mem_wb; // data_memout also a part of this reg (wire, register internal to the module)
	wire [31:0] pcout,pcin; //if 
	wire [31:0]pc_plus4out; //if 
	wire  PCsrc;
	wire [31:0] aluB; // ex
	wire [2:0] ALUop; //ex
	wire [4:0]muxregdst; //ex
	wire [31:0] PC_jump; //ex
	wire RegDst, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg;
	wire [1:0] ALUop2;
	wire [31:0] writeData; //wb
	wire zero, overflow;
	wire[31:0] ALUout;
	wire [31:0] data_memout;
	wire [1:0] fwA, fwB;
	wire [31:0] outA, outB;// forwarded output
///////////////////////////// IF Stage //////////////////////////////

	pc pc1(clk, rst ,pcin[31:0] , pcout[31:0]);
	mux32 muxpc(pc_plus4out[31:0] , ex_mem[68:37] , PCsrc ,pcin[31:0]);
	Adder32bit PC_plus4( pcout[31:0], 32'd4, pc_plus4out[31:0] , 1'b0, , );
	wire [31:0]instr_memout;
	memory instruction_memory(instr_memout[31:0], pcout[31:0], , clk, 1'b1, 1'b0, initializeMemoryinstr, );
	always@(posedge clk)
	begin
	if_id_pc_plus4[31:0]<=pc_plus4out[31:0];
	end
///////////////////////////// ID Stage //////////////////////////////
wire [31:0] A, B;
	register regfile( A[31:0], B[31:0], clk, rst, mem_wb[38], instr_memout[25:21] , instr_memout[20:16] , mem_wb[4:0] ,  writeData[31:0]);
	controller main_controller(instr_memout[31:26], RegDst, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg, ALUop2[1:0], clk);
	
	always@(posedge clk) 
	begin
		id_ex[78:74]<=instr_memout[25:21]; //rs
		id_ex[4:0]<=instr_memout[15:11]; //rd
		id_ex[9:5]<=instr_memout[20:16]; //rt
		id_ex[25:10]<=instr_memout[15:0]; //immediate value
		if(instr_memout[15]) //sign extending the number
			begin
			id_ex[41:26]<=16'hffff;
			end
		else
			begin
			id_ex[41:26]<=16'h0000;
			end
		id_ex[73:42]<=if_id_pc_plus4[31:0];
	end	
	
///////////////////////////// EX Stage //////////////////////////////	

	mux32_4x1 muxfwA(A[31:0],mem_wb[36:5], ALUout[31:0], , fwA[1:0], outA[31:0] );
	mux32_4x1 muxfwB(B[31:0],mem_wb[36:5], ALUout[31:0], , fwB[1:0], outB[31:0] );
	
		//////////////////////////// INSERTING THE FORWARDING UNIT //////////////////////////////

		forwarding_unit fw_unit1(ex_mem[4:0] , mem_wb[4:0] , id_ex[78:74] , id_ex[9:5] ,  fwA[1:0], fwB[1:0], clk);

		//////////////////////////// INSERTING THE FORWARDING UNIT //////////////////////////////				

	mux32 muxalusrc(outB[31:0] , id_ex[41:10] , ALUSrc ,aluB[31:0]);
	ALUcontroller ALU_control(ALUop2[1:0], id_ex[15:10], ALUop[2:0]);
	ALU alu1( outA[31:0], aluB[31:0] , ALUout[31:0],zero, overflow,  ALUop[2:0], clk);	
	assign muxregdst= RegDst?id_ex[4:0]:id_ex[9:5]; //regdst? rd:rt
	Adder32bit adderPC_jump( id_ex[73:42] , (id_ex[41:10]<<2), PC_jump[31:0], 1'b0, , );
	
	always@(posedge clk)
	begin
		ex_mem[4:0]<=muxregdst;
		ex_mem[36:5]<=B[31:0];
		ex_mem[74:69]<={Branch, MemRead, MemWrite, RegWrite, MemtoReg};
		ex_mem[68:37]<=PC_jump;
	end
///////////////////////////// MEM Stage //////////////////////////////		
		
	memory data_memory(data_memout[31:0], ex_mem[68:37],ex_mem[36:5], clk, ex_mem[73], ex_mem[72], , printOutputdata);
	assign PCsrc= zero&ex_mem[74]; // branch and zero
	always@(posedge clk)
	begin
		mem_wb[36:5]<=ALUout[31:0];
		mem_wb[4:0]<=ex_mem[4:0];
		mem_wb[38:37]<=ex_mem[70:69];
	end
	
///////////////////////////// WB Stage //////////////////////////////		

	mux32 muxmemtoreg(mem_wb[36:5], data_memout[31:0] , mem_wb[37], writeData[31:0]);
	
endmodule
	
///////////////////////////// TESTBENCH //////////////////////////////		
	
module tb_processor();
reg clk, rst, InitializeInstructionMemory,printOutputdata;

initial begin
clk=1;
forever #5 clk=~clk;
end

processor pro1( clk, rst, InitializeInstructionMemory,printOutputdata);

initial begin
rst=1;
InitializeInstructionMemory=1;
printOutputdata=0;
#8	rst=0;
	InitializeInstructionMemory=0;
	printOutputdata=0;
#4	rst=0;
	InitializeInstructionMemory=0;
	printOutputdata=0;
#10	rst=0;
	InitializeInstructionMemory=0;
	printOutputdata=0;

end



endmodule

	
	
	