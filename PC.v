module PC(
	input clk, rst,
	input en,
	output reg [15:0] addr
	);
	reg [12:0] counter ;
	
	always@(posedge clk) begin
		if(~rst) begin
			counter <= 0;
			addr <= 16'h00;
			end
		
		else begin
			if(en) begin
				addr = counter;
				counter = counter + 1'b1;
				end
			end
		
		end
endmodule
