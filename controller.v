// L16 Slide-1

module controller(input [5:0] opcode, output reg  regDst, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg, output reg[1:0] ALUop, input clk);

always@(posedge clk)
	begin
	case(opcode)
	6'b000000: 	begin   //R type (exact specification depends on funct fields) 
				regDst<=1'b1;
				ALUop<=2'b10;
				ALUSrc<=1'b0;
				Branch<=1'b0;
				MemRead<=1'b0;
				MemWrite<=1'b0;
				RegWrite<=1'b1;
				MemtoReg<=1'b0;
				end
				
	6'b100011: 	begin  // LW
				regDst<=1'b0;
				ALUop<=2'b00;
				ALUSrc<=1'b1;
				Branch<=1'b0;
				MemRead<=1'b1;
				MemWrite<=1'b0;
				RegWrite<=1'b1;
				MemtoReg<=1'b1;
				end
				
	6'b101011: 	begin //SW
				regDst<=1'bX;
				ALUop<=2'b00;
				ALUSrc<=1'b1;
				Branch<=1'b0;
				MemRead<=1'b0;
				MemWrite<=1'b1;
				RegWrite<=1'b0;
				MemtoReg<=1'bX;
				end
				
	6'b000100: 	begin // BEQ
				regDst<=1'bX;
				ALUop<=2'b01;
				ALUSrc<=1'b0;
				Branch<=1'b1;
				MemRead<=1'b0;
				MemWrite<=1'b0;
				RegWrite<=1'b0;
				MemtoReg<=1'bX;
				end
				
	default: 	begin 
				regDst<=1'b1;
				ALUop<=2'b10;
				ALUSrc<=1'b0;
				Branch<=1'b0;
				MemRead<=1'b0;
				MemWrite<=1'b0;
				RegWrite<=1'b1;
				MemtoReg<=1'b0;
				end

	endcase
	end
endmodule

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


// L7 S12
module ALUcontroller(input [1:0] ALUop, input [5:0] funct, output [2:0] operation);
	wire w1, w2;
	or(w1, funct[0], funct[3]);
	and(operation[0], w1, ALUop[1]);
	nand(operation[1], funct[2], ALUop[1]);
	and(w2, funct[1], ALUop[1]);
	or(operation[2], ALUop[0], w2);
endmodule

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

 module tb_controller();
 
 reg [5:0]opcode ;
 wire RegDst, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg;
 wire [1:0] ALUop;
 reg clk;
 wire [2:0]operation;
 reg [5:0]funct;
 
 controller cont1(opcode[5:0], RegDst, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg, ALUop[1:0], clk);
 ALUcontroller alucont(ALUop[1:0], funct[5:0], operation[2:0]); 
 
 initial begin
	clk=1;
	forever #5 clk=~clk;
 end
 
initial  begin 
	opcode= 6'b000000;
	funct= 6'b000000;
	#10 opcode= 6'b000000;
		funct= 6'b000010;
	#10 opcode= 6'b000000;
		funct= 6'b000100;
	#10 opcode= 6'b000000;
		funct= 6'b000101;
	#10 opcode= 6'b000000;
		funct= 6'b001010;
	#10 opcode= 6'b000000;
		funct= 6'b000000;
	#10 opcode= 6'b100011;
		funct= 6'b000010;
	#10 opcode= 6'b101011;
		funct= 6'b000010;
	#10 opcode= 6'b000100;
		funct= 6'b000010;
end
endmodule	