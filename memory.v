module memory(
	output reg [31:0] memOut,
	input [31:0] address,
	input [31:0] dataIn,
	input clk,
	input readEnable,
	input writeEnable,
	input initializeMemory,
	input printOutput
	);
	
reg [7:0] memory [0:1023];

integer i, f;

always @ (posedge initializeMemory)
	$readmemh("Instruction_memory1.txt", memory);

always @ (posedge printOutput)
begin
	f = $fopen("Data_memory.txt", "w");
		if (f)  $display("File was opened successfully : %0d", f);
		else    $display("File was NOT opened successfully : %0d", f);		
		for(i = 0; i < 1023; i = i+1)
			$fwrite(f, "%h\n", memory[i]);
		$fclose(f);
end

always @ (posedge clk)
begin
	if(readEnable)
		begin
		memOut[7:0] <= memory[address];
		memOut[15:8] <= memory[address+1];
		memOut[23:16] <= memory[address+2];
		memOut[31:24] <= memory[address+3];
		end
		
	else if (writeEnable)
		begin
		memory [address] <= dataIn[7:0];
		memory [address+1] <= dataIn[15:8];
		memory [address+2] <= dataIn[23:16];
		memory [address+3] <= dataIn[31:24];
		end
		
	else memOut <= 32'd0;
	
end

endmodule
