`timescale 1ns/1ns
module d_finder #(parameter n=10573, e=89)(
//	input clk,
//	output reg[11:0] d
	);
	reg clk;
	reg [11:0] d;
	
	reg flag;
	reg [1:0] state;
	integer candidate, pi, i, p, q;
	
	
	initial clk = 0;
	always #5 clk=~clk;

	
	always@(clk or state) begin
		case(state)
			//idle
			default : begin
						state = 2'b00; i=1;
					end
			2'b00: begin				
					candidate = 10*i+1;
					fork
						if(n%candidate == 0) begin
							p=candidate; flag=1'b1;
							end
						if(n%(candidate+2) == 0) begin
							p=candidate+2; flag=1'b1;
							end
						if(n%(candidate+6) == 0) begin
							p=candidate+6; flag=1'b1;
							end
						if(n%(candidate+8) == 0) begin
							p=candidate+8; flag=1'b1;
							end
					join
					if(flag==1'b1) begin
						q = n/p;
						pi = (p-1)*(q-1);
						state = 2'b01;						
						i = 1;
						end
					else fork
						i = i+1;
						state = 2'b00;
						join
					end
			
			2'b01: begin
						if((i*pi+1)%e==0) begin
							d = (i*pi+1)/e;
							end
						else begin
							state = 2'b01;
							i=i+1;
							end						
					end
						
		endcase
	end
endmodule

