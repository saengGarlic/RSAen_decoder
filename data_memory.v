module data_memory(
	input clk, rst,
	input MemRead, MemWrite,
	input [15:0] Addr, WriteData,
	output reg [15:0] ReadData
	);
	
	reg [8191:0] DMemArry [15:0];
	integer i;

	
	always@(posedge clk) begin
	
		if(~rst) begin
			for(i=0; i<8192; i=i+1) begin
				DMemArry[i] = 16'h00;
				end
				
			DMemArry[0]	<= 16'b0000_0000_0000_0000;	DMemArry[8]	<= 16'b1110_0001_0010_1000;
			DMemArry[1]	<= 16'b0000_0000_0010_0001;	DMemArry[9]	<= 16'b0101_0011_1100_0101;
			DMemArry[2]	<= 16'b0000_0000_0000_1100;	DMemArry[10] <= 16'b1001_0111_1000_1001;
			DMemArry[3]	<= 16'b0000_0000_0011_0001;	DMemArry[11] <= 16'b1101_0011_1101_1111;
			DMemArry[4]	<= 16'b0000_0000_1100_1001;	DMemArry[12] <= 16'b1011_1001_1001_0001;
			DMemArry[5]	<= 16'b0000_0000_0011_1100;	DMemArry[13] <= 16'b0000_0100_0110_0101;
			DMemArry[6]	<= 16'b0000_0000_1101_1011;	DMemArry[14] <= 16'b0001_1100_0101_0110;
			DMemArry[7]	<= 16'b0000_0000_0000_0111;	DMemArry[15] <= 16'b0001_0010_1110_0100;
			ReadData <= 0;
			end
			
		else begin
			if(MemRead == 1'b1) begin
				ReadData <= DMemArry[Addr];
				end
			else if(MemWrite == 1'b1) begin
				DMemArry[Addr] <= WriteData;
				end
			else ReadData = 0;
			
			end
		end
endmodule
			
				