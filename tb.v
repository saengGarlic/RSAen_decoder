module tb();
	reg clk;
	wire [12:0]d;
	
	d_finder d1(clk,d);
	

	initial clk = 0;
	always begin
		#5 clk = ~clk;
		end




endmodule