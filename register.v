module register(
	input clk, rst,
	input RegWrite,
	input [2:0] ReadAddr1, ReadAddr2, WriteAddr,
	input [15:0] WriteData,
	output reg [15:0] ReadData1, ReadData2
	// ReadData1 -> rs , ReadData2 -> rt
	);
	
	reg [7:0] RegArry [15:0];
	integer i;
	
	always@(posedge clk) begin
	
		if(~rst) begin
			for(i=0; i<8; i=i+1) begin
				RegArry[i] = 16'h00;
				end
			ReadData1 <= 0;
			ReadData2 <= 0;
			end
			
		else begin
			case(RegWrite)			
				1'b0 : begin
						ReadData1 <= RegArry[ReadAddr1];
						ReadData2 <= RegArry[ReadAddr2];
						end
				
				1'b1 : begin					
						ReadData1 <= RegArry[ReadAddr1];
						ReadData2 <= RegArry[ReadAddr2];
						RegArry[WriteAddr] <= WriteData;
						end
				default : begin
						ReadData1 <= RegArry[0];
						ReadData2 <= RegArry[0];
						end
				endcase
			end
					
			
	end	
endmodule