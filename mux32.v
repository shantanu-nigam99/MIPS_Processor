module mux32(input [31:0] in0, in1, input sel, output [31:0] out );

assign out[31:0]=sel?in1[31:0]:in0[31:0];

endmodule

module mux32_4x1(input [31:0] in0, in1, in2, in3, input [1:0] sel, output [31:0] out );

assign out[31:0]=sel[0]?(sel[1]?in3[31:0]:in1[31:0]):(sel[1]?in2[31:0]:in0[31:0]);

endmodule

module tb_mux32_4x1();
reg[31:0] in0, in1, in2, in3;
reg[1:0] sel;
wire[31:0] out;
mux32_4x1 mux1(in0[31:0], in1[31:0], in2[31:0], in3[31:0], sel[1:0], out[31:0]);

initial begin
	in0=32'd10;
	in1=32'd11;
	in2=32'd12;
	in3=32'd14;
	sel=2'd0;
	#10 sel=2'd1;
	#10 sel= 2'd2;
	#10 sel= 2'd3;
	
end
endmodule