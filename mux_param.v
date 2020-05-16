module mux_param #(parameter size=16)(
	input [1:0] sel,
	input [size-1:0] in1, in2, in3, in4,
	output [size-1:0] out
	);
	
	assign out = sel[0]? (sel[1]? in4 : in3) : (sel[1]? in2 : in1);
	

endmodule	
