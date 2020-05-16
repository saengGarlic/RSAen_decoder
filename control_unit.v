
module control_unit(
	input clk, rst,
	input [2:0] opcode, 
	output reg [1:0] MemtoReg, ALUOp, RegDst,
	output reg Jump, Branch, MemRead, MemWrite, ALUSrc, RegWrite
	
	// RegDst = rd (=instruct[12:10])
	// R format -> opcode 0 , register only / I format -> opcode 1,4,5,6,7 memory operation / J format -> opcode 2,3 Jump high
	// ALUOp see document
	// MemtoReg
	// ALUSrc : if 0 from register, if 1 from instruction immediate
	);
	
	
	always@(posedge clk) begin
		if(~rst) begin
			RegDst <= 0;	Jump <= 0;
			Branch <= 0;	MemRead <= 0;
			MemtoReg <= 0;	ALUOp <= 0;
			MemWrite <= 0;	ALUSrc <= 0;
			RegWrite <= 0;
			end
		
		else begin
			case(opcode)
				//case R format
				3'b000 : begin
						RegDst <= 2'b01;	Jump <= 1'b0;
						Branch <= 1'b0;		MemRead <= 1'b0;
						MemtoReg <= 2'b00;	ALUOp <= 2'b00;
						MemWrite <= 1'b1;	ALUSrc <= 1'b0;
						RegWrite <= 1'b0;
						end
				
				//slti
				3'b001 : begin
						RegDst <= 2'b01;	Jump <= 1'b0;
						Branch <= 1'b0;		MemRead <= 1'b0;
						MemtoReg <= 2'b00;	ALUOp <= 2'b10;
						MemWrite <= 1'b0;	ALUSrc <= 1'b0;
						RegWrite <= 1'b1;
						end
				
				//j		
				3'b010 : begin
						RegDst <= 2'b00;	Jump <= 1'b1;
						Branch <= 1'b0;		MemRead <= 1'b0;
						MemtoReg <= 2'b00;	ALUOp <= 2'b00;
						MemWrite <= 1'b0;	ALUSrc <= 1'b1;
						RegWrite <= 1'b0;
						end
					
				//jal
				3'b011 : begin
						RegDst <= 2'b10;	Jump <= 1'b1;
						Branch <= 1'b0;		MemRead <= 1'b0;
						MemtoReg <= 2'b10;	ALUOp <= 2'b00;
						MemWrite <= 1'b0;	ALUSrc <= 1'b1;
						RegWrite <= 1'b1;
						end
				
				//lw
				3'b100 : begin
						RegDst <= 2'b00;	Jump <= 1'b0;
						Branch <= 1'b0;		MemRead <= 1'b1;
						MemtoReg <= 2'b01;	ALUOp <= 2'b11;
						MemWrite <= 1'b0;	ALUSrc <= 1'b1;
						RegWrite <= 1'b0;
						end
				
				//sw
				3'b101 : begin
						RegDst <= 2'b00;	Jump <= 1'b0;
						Branch <= 1'b0;		MemRead <= 1'b0;
						MemtoReg <= 2'b00;	ALUOp <= 2'b11;
						MemWrite <= 1'b1;	ALUSrc <= 1'b1;
						RegWrite <= 1'b0;
						end
						
				//beq
				3'b110 : begin
						RegDst <= 2'b00;	Jump <= 1'b0;
						Branch <= 1'b1;		MemRead <= 1'b0;
						MemtoReg <= 2'b00;	ALUOp <= 2'b01;
						MemWrite <= 1'b0;	ALUSrc <= 1'b1;
						RegWrite <= 1'b0;
						end
				
				//addi
				3'b111 : begin
						RegDst <= 2'b00;	Jump <= 1'b0;
						Branch <= 1'b0;		MemRead <= 1'b0;
						MemtoReg <= 2'b00;	ALUOp <= 2'b11;
						MemWrite <= 1'b0;	ALUSrc <= 1'b1;
						RegWrite <= 1'b1;
						end
				
				default : begin
						RegDst <= 0;	Jump <= 0;
						Branch <= 0;	MemRead <= 0;
						MemtoReg <= 0;	ALUOp <= 0;
						MemWrite <= 0;	ALUSrc <= 0;
						RegWrite <= 0;
						end
				endcase
			end
	end
endmodule