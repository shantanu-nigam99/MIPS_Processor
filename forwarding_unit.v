module comparator(input [4:0] A, B, output C );
	wire [4:0] xnor_out;
	xnor(xnor_out[0], A[0], B[0]);
	xnor(xnor_out[1], A[1], B[1]);
	xnor(xnor_out[2], A[2], B[2]);
	xnor(xnor_out[3], A[3], B[3]);
	xnor(xnor_out[4], A[4], B[4]);
	assign C=xnor_out[0]&xnor_out[1]&xnor_out[2]&xnor_out[3]&xnor_out[4];
endmodule


/* module forwarding_unit(input [4:0] Rd_mem, Rd_wb, Rs, Rt, output [1:0] A, B);
	wire Rs_mem, Rt_mem, Rs_wb, Rt_wb;
	wire negRs_mem, negRt_mem;
	comparator	compRs_mem(Rs[4:0], Rd_mem[4:0], Rs_mem);
	comparator compRs_wb(Rs[4:0], Rd_wb[4:0], Rs_wb);
	comparator compRt_mem(Rt[4:0], Rd_mem[4:0], Rt_mem);
	comparator compRt_wb(Rt[4:0], Rd_wb[4:0], Rt_wb);
	
	not(negRs_mem, Rs_mem);
	assign A[0]= negRs_mem & Rs_wb;
	assign A[1]= Rs_mem;
	
	not(negRt_mem, Rt_mem);
	assign B[0]= negRt_mem & Rt_wb;
	assign B[1]= Rt_mem;
	
endmodule */

module forwarding_unit(input [4:0] Rd_mem, Rd_wb, Rs, Rt, output reg [1:0] Aout, Bout, input clk);

	
	wire Rs_mem, Rt_mem, Rs_wb, Rt_wb;
	wire negRs_mem, negRt_mem;
	wire [1:0] A, B;
	
	comparator compRs_mem(Rs[4:0], Rd_mem[4:0], Rs_mem);
	comparator compRs_wb(Rs[4:0], Rd_wb[4:0], Rs_wb);
	comparator compRt_mem(Rt[4:0], Rd_mem[4:0], Rt_mem);
	comparator compRt_wb(Rt[4:0], Rd_wb[4:0], Rt_wb);
	
	not(negRs_mem, Rs_mem);
	assign A[0]= negRs_mem & Rs_wb;
	assign A[1]= Rs_mem;
	
	not(negRt_mem, Rt_mem);
	assign B[0]= negRt_mem & Rt_wb;
	assign B[1]= Rt_mem;
	
	always@(negedge clk)
	begin
		case(A[1:0])
		2'b00: Aout<= 2'b00;
		2'b01: Aout<= 2'b01;
		2'b10: Aout<= 2'b10;
		2'b11: Aout<= 2'b11;
		default: Aout<= 2'b00;
		endcase
	end
	
	always@(negedge clk)
	begin
		case(B[1:0])
		2'b00: Bout<= 2'b00;
		2'b01: Bout<= 2'b01;
		2'b10: Bout<= 2'b10;
		2'b11: Bout<= 2'b11;
		default: Bout<= 2'b00;
		endcase
	end
	
		
		
endmodule


module tb_forwarding_unit();
reg [4:0] Rd_mem, Rd_wb, Rs, Rt; 
wire [1:0] A, B;
forwarding_unit fwunt(Rd_mem[4:0], Rd_wb[4:0], Rs[4:0], Rt[4:0], A[1:0], B[1:0]);
initial  begin
		Rd_mem=5'b00000;
		Rd_wb=5'b00000;
		Rs=5'b00001;
		Rt=5'b00010;
	#10
		Rd_mem=5'b00000;
		Rd_wb=5'b00000;
		Rs=5'b00001;
		Rt=5'b00010;
	#10
		Rd_mem=5'b00000;
		Rd_wb=5'b00001;
		Rs=5'b00001;
		Rt=5'b00010;
	#10
		Rd_mem=5'b00000;
		Rd_wb=5'b00010;
		Rs=5'b00001;
		Rt=5'b00010;
	#10
		Rd_mem=5'b00001;
		Rd_wb=5'b00000;
		Rs=5'b00001;
		Rt=5'b00010;
	#10
		Rd_mem=5'b00010;
		Rd_wb=5'b00000;
		Rs=5'b00001;
		Rt=5'b00010;
	
end

endmodule



