`timescale 1ns/1ns
module test_RSA(
//	input [1022:0] instream,
//	input clk,
//	output reg [1022:0] outstream
	);
	
	reg [1022:0] instream;
	reg clk;
	reg [1022:0] outstream;
	
	reg [3:0] state;
	//default: input split /0:push word / 1:tgbase convert / 2:bignumber convert / 3:encrypt / 4:decrypt / 5:split into 2 tgbase / 6:ascii convert / 7:output stream	
	reg flag;
	reg [6:0] step;
	
	reg [6:0] arry [146:0];
	
	reg [6:0] ascii_4673;
	reg [5:0] tgBASE_4673;
	reg [13:0] oneBig_4673;
	reg [13:0] encrypt_4673;
	reg [13:0] DoneBig_4673;
	reg [5:0] DtgBASE_4673;
	reg [6:0] Dascii_4673;
	
	reg [15:0] n, e, d;
	
	integer i, eos, init, temp;
	integer p, q; 		//encryption parameters
		
	initial begin
		instream [1022-:98] =98'b10010001100101110110011011001101111010000010101111101111111001011011001100100010000100000000000000;
		clk = 0;
	end
	
	initial $monitor("%d  %d  %d  %d ",ascii_4673,tgBASE_4673,oneBig_4673,encrypt_4673);
	
	always begin 
		#5 clk=~clk;
		end
	
	always@(clk or state) begin
	
		case(state)
			//split input stream into array : encrypt stage 1
			4'b1111: begin						
						if(instream[1022-7*i]!==1'bx) begin
							arry[146-i] = instream[(1022-7*i)-:7];
							i = i+1;
							state = 4'b1111;
						end
						else begin
							eos = i;
							state = 4'b0000;
							end					
						
					end
					
			//pushing ascii split into module
			4'b0000: begin
						if(step==eos) state=4'b1000;
						else begin
							ascii_4673 = arry[146-step];
							
							state = 4'b0001;
						end
					end
					
			//conversion to tgBASE_4673 : encrypt stage 2
			4'b0001: begin
						if((ascii_4673>31)&&(ascii_4673<34))
							tgBASE_4673 = ascii_4673 - 32;
						else if((ascii_4673>47)&&(ascii_4673<58))
							tgBASE_4673 = ascii_4673 - 46;
						else if((ascii_4673>64)&&(ascii_4673<91))
							tgBASE_4673 = ascii_4673 - 53;
						else if((ascii_4673>96)&&(ascii_4673<123))
							tgBASE_4673 = ascii_4673 - 59;
						else begin
							tgBASE_4673 = 0;
							end
							
						state = 4'b0010;
					end
		
			//merging 2 tgBASE_4673 to 1 big number : encrypt stage 3
			4'b0010: begin
						if(step[0]==0) begin
							oneBig_4673[13:7] = {1'b0,tgBASE_4673};							
							state = 4'b0000;
							end
						else begin
							oneBig_4673[6:0] = {1'b0,tgBASE_4673};
							state = 4'b0011;
							
							i=0;
							end
						step = step +1;
						
					end

			//rsa encryption : encrypt stage 4	
			4'b0011: begin						
						if(i==0) begin
							init = oneBig_4673%n;							
							if(e[0]==1) temp = init;
							else temp = 1;
							i = i+1;
							state = 4'b0011;
							end
						else if(!(2**i<e)) begin
							encrypt_4673 = temp%n;
							i = 0;
							state = 4'b0100;
							end
						else begin							
							init = (init**2)%n;
							if(e[i]==1) temp = (temp * init)%n;
							i = i+1;
							state = 4'b0011;
							end
					end
			
			//rsa decryption : decrypt stage 1
			4'b0100: begin						
						if(i==0) begin
							init = encrypt_4673%n;
							temp = 1;
							if(d[0]==1) temp = init;
							i = i+1;
							state = 4'b0100;
							end
						else if(!(2**i<d)) begin
							DoneBig_4673 = temp%n;
							i = 0;
							state = 4'b0101;
							end
						else begin							
							init = (init**2)%n;
							if(d[i]==1) temp = (temp * init);
							i = i+1;
							state = 4'b0100;
							end
					end

			//split into two DtgBASE64 : decrypt stage 2
			4'b0101: begin
						if(flag==0) begin
							DtgBASE_4673 = DoneBig_4673[12:7];
							end
						else begin
							DtgBASE_4673 = DoneBig_4673[5:0];
							end
						state = 4'b0110;
					end

			//conversion to ascii : decrypt stage 3
			4'b0110: begin
						if(!(DtgBASE_4673<0)&&(DtgBASE_4673<2))
							Dascii_4673 = DtgBASE_4673 + 32;
						else if(DtgBASE_4673<12)
							Dascii_4673 = DtgBASE_4673 + 46;
						else if(DtgBASE_4673<38)
							Dascii_4673 = DtgBASE_4673 + 53;
						else if(DtgBASE_4673<64)
							Dascii_4673 = DtgBASE_4673 + 59;
						else begin
							Dascii_4673 = 0;
							end
						
						state = 4'b0111;
					end
		
			//push to arry : decrypt stage 4
			4'b0111: begin
						if(flag==0) begin
							arry[148-step]= Dascii_4673;
							flag = 1;
							state = 4'b0101;
							end
						else begin							
							arry[147-step]= Dascii_4673;
							flag = 0;
							state = 4'b0000;
							end
					end
			
			//flush to outstream
			4'b1000: begin														
						for(i=0; i<eos; i=i+1) begin
							outstream[(1022-7*i)-:7] = arry[146-i];
							end
					end
					
			default: begin 
					state = 4'b1111; step = 0; p = 101; q = 103; n = 10403; e= 71; d = 431; flag = 0; i = 0;
					end
		endcase
	end
endmodule
