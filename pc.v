module pc(input reg clk, rst ,input [31:0] pcin, output [31:0] pcout);
	reg [31:0] pcmem;
	initial pcmem<=32'd0;
	always@(posedge clk, posedge rst)
	if(rst)
		pcmem<=32'd0;
	else	
	begin
		pcmem<=pcin;
	end
	
	assign pcout = pcmem;
	
	
	
	
	
endmodule