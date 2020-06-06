module fulladder_gate (a, b, c, sum, cout);

	input a, b, c;
	output sum, cout;
	wire w1,w2,w3;
	xor(w1, a, b);
	xor(sum, w1, c);
	and(w2, c, w1);
	and(w3, a, b);
	or(cout , w2, w3);

endmodule 
//***************************************************************//

module Adder32bit (input [31:0] a, input [31:0]b, output [31:0] out, input cin, output cout, output overflow);
	
	genvar i;
	wire [31:0]carry;
	fulladder_gate fa0(a[0], b[0], cin, out[0], carry[0]);
	for (i=1; i<31; i=i+1) begin
	fulladder_gate fa(a[i], b[i], carry[i-1], out[i], carry[i]);
	end
	fulladder fa31(a[31], b[31], carry[30], out[31], cout);
	assign overflow=carry[30]^cout;

endmodule


module tb_adder32();
	reg [31:0] a;
	wire [31:0] outp;
	Adder32bit adder(a, 32'd4, outp, 1'b0, , );
	
	initial begin
	a<=32'b0;
	#10 a<=32'd4;
	#10 a<=32'd8;
	#10 a<=32'd12;
	end
endmodule

module ALU(input [31:0] A, B ,output reg[31:0] result, output reg zero, overflow, input reg[2:0] ALUop, input clk);
	wire [31:0] adder_output;
	wire carryout;
	wire of;
	wire [31:0]B_inv;
	wire [31:0] B2;
	
	genvar i;
	for (i=0; i<32; i=i+1)begin
	not(B_inv[i], B[i]); 
	end
	
	Adder32bit adder(A[31:0], B2[31:0], adder_output[31:0], ALUop[2], carryout, of);
	mux32 muxB_Binv(B[31:0], B_inv[31:0], ALUop[2], B2[31:0]);
	
	always@(posedge clk)
	begin
		case(ALUop)
		3'b000: begin
				result<= A&B;
				zero<=1'bZ;
				overflow<=1'bZ;
				end
		3'b001: begin
				result<= A|B;
				zero<=1'bZ;
				overflow<=1'bZ;
				end
		3'b010: begin
				result<= adder_output;
				overflow<=of;
				zero<=1'bZ;
				end
		3'b110: begin
				result<= adder_output;
				overflow<=of;
				if(A==B) 
				begin 
					zero<=1'b1;
				end
				else
				begin
					zero<=1'b0;
				end	
				end
		3'b111: begin 
				result[0]<=adder_output[31];
				result[31:1]<=31'd0;
				zero<=1'bZ;
				overflow<=1'bZ;
				end
		default: begin	
				result<= 32'd0;
				zero<=1'bZ;
				overflow<=1'bZ;
				end
		endcase
	end
endmodule
			
module tb_ALU();
	reg [31:0] A, B;
	wire[31:0] result;
	wire zero, overflow;
	reg[2:0] ALUop;
	reg clk;
	
	
	initial begin
	clk=1;
	forever #5 clk=~clk;
	end
	
	
	ALU alu_tb(A[31:0] , B[31:0] , result[31:0] , zero, overflow, ALUop[2:0] , clk);
	
	
	initial begin
	A=32'd1;
	B=32'd1;
	ALUop=3'b010;

	#10
	A=32'd1;
	B=32'd1;
	ALUop=3'b010;

	#10
	A=32'd2;
	B=32'd2;
	ALUop=3'b010;

	#10
	A=32'd3;
	B=32'd3;
	ALUop=3'b010;

	#10
	A=32'd4;
	B=32'd4;
	ALUop=3'b010;
		
	#10
	A=32'd5;
	B=32'd5;
	ALUop=3'b010;

	#10
	A=32'd6;
	B=32'd6;
	ALUop=3'b010;

	#10
	A=32'd7;
	B=32'd7;
	ALUop=3'b010;

	#10
	A=32'd8;
	B=32'd8;
	ALUop=3'b010;
	
end
endmodule

