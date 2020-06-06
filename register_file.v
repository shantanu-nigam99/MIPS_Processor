module register(output reg [31:0] dout_A, dout_B, input clk, rst, w_rb, input [4:0] rs, rt, rd, input [31:0] din);
	reg [31:0] register [0:31];
	initial $readmemh("register.txt", register);
	integer i;
	always @(posedge clk, posedge rst)
	begin
		case (rst)
//		1'b1:
//			begin
//				for(i = 0; i<32; i = i+1)
//				register[i] <= 32'd0;
//			end
		1'b0: 
			begin
				dout_A <= register[rs];
				dout_B <= register[rt];
			end
			
		endcase
	end
	
	always@(negedge clk)
	begin
		if(w_rb) 
			begin
				register[rd] <= din;
			end
	end	
	
endmodule

module tb_register();

reg clk;
reg w_rb;
initial begin
clk=1;
forever #5 clk=~clk;
end

wire [31:0] A, B; 
reg [4:0] rs, rt, rd;
reg [31:0] din;

register reg1(A[31:0] , B[31:0] , clk, 1'b0 , w_rb,  rs[4:0], rt[4:0], rd[4:0],  din[31:0]);

initial begin
w_rb=1'b0; rs=5'd0; rt=5'd0; rd=5'd0; din=32'd0;
#10 w_rb=1'b1; rs=5'd0; rt=5'd0; rd=5'd2; din=32'd69;
#10 w_rb=1'b0; rs=5'd12; rt=5'd2; rd=5'd2; din=32'd69;

end
endmodule
