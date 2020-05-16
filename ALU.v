module ALU(
	input clk, rst,
	input [2:0] ALUctrl,
	input [15:0] in1, in2,
	output reg zero,
	output reg [15:0] res
	);
	
	always@(posedge clk) begin
		if(~rst) begin
			zero <= 0;
			res <= 0;
			end
		else begin
			case(ALUctrl)
				//add
				3'b000 : begin
						res <= in1 + in2;
						if(res==0) zero <= 1'b1;
						else zero <= 1'b0;
						end
				//sub
				3'b001 : begin
						res <= in1 - in2;
						if(res==0) zero <= 1'b1;
						else zero <= 1'b0;
						end
				
				//and
				3'b010 : begin
						res <= in1 & in2;
						if(res==0) zero <= 1'b1;
						else zero <= 1'b0;
						end
				//or
				3'b011 : begin
						res <= in1 | in2;
						if(res==0) zero <= 1'b1;
						else zero <= 1'b0;
						end
				
				//slt
				3'b100 : begin
						if(in1<in2) begin
							res <= 16'h01;
							zero <= 0;
							end
						else begin 
							res <= 16'h00;
							zero <= 1;
							end
						end
				endcase
			end
		end	
endmodule