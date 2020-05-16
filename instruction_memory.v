module instruction_memory(
	input clk, rst,
	input [15:0] Addr,
	output reg [15:0] ReadInstruc
	);
	
	reg [8191:0] IMemArry [15:0];
	integer i;
	
	always@(posedge clk) begin
		if(~rst) begin
			for(i=0; i<8192; i=i+1) begin
				IMemArry[i] = 16'h00;
				end
				
			IMemArry[0]	<= 16'b1001_1001_0000_0001;	IMemArry[8]	<= 16'b0000_1001_1100_0011;
			IMemArry[1]	<= 16'b1001_1001_1000_0010;	IMemArry[9]	<= 16'b0110_0000_0000_1101;
			IMemArry[2]	<= 16'b0000_1001_1100_0000;	IMemArry[10] <= 16'b1111_0010_0000_0010;
			IMemArry[3]	<= 16'b0000_1001_1001_0100;	IMemArry[11] <= 16'b1011_1010_0000_0011;
			IMemArry[4]	<= 16'b1100_0100_0000_0010;	IMemArry[12] <= 16'b0100_0000_0000_1111;
			IMemArry[5]	<= 16'b0000_1001_1100_0010;	IMemArry[13] <= 16'b1111_0010_0000_1101;
			IMemArry[6]	<= 16'b0100_0000_0000_1000;	IMemArry[14] <= 16'b0001_1100_0000_1000;
			IMemArry[7]	<= 16'b0000_1001_1100_0001;	IMemArry[15] <= 16'b0000_0000_0000_0000;
			ReadInstruc <= 0;
			end
		else begin
			ReadInstruc <= IMemArry[Addr];
			end
		
		end
endmodule