module en_decoder_RSA #(parameter p = 101, q = 103, n = 10403, e= 71, d = 431)(
	input [1022:0] instream,
	input clk, mode,	//mode1: decrypt mode
	output reg [1022:0] outstream
	);

	reg [1022:0] out_buf;
	reg [3:0] state;
	/*	default: mode select / 15: push instream to arry / 14: push input to encrypt_4673, check end of input
		0:push word, check end of input / 1:ascii to tgbase / 2:tgbase to onebig / 3:encrypt 
		4:decrypt / 5:donebig to dtgbase / 6:dtgbase to dascii / 7:write on memory
		8:flush memory to outstream / 9:clear register, idling
	*/
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
			
	integer i, eos;
	integer temp, init;
	
			
	initial begin
		$display("step | ascii  tgBASE  oneBig  encrypt  DoneBig  DtgBASE  Dascii  Dascii(char)");
		$monitor("%4d | %5d  %6d  %6d  %7d  %7d  %7d  %6d  %1c",step, ascii_4673,tgBASE_4673,oneBig_4673,encrypt_4673,DoneBig_4673,DtgBASE_4673,Dascii_4673,Dascii_4673);
	end
	

	always@(clk or instream) begin
	
		case(state)
			//start
			default: begin 						
						step = 0;  flag = 0; i = 0;
						if(mode==0) state = 4'b1111;
						else state = 4'b1110;
					end
					
			//split input stream into array : encrypt stage 1
			4'b1111: begin						
						if(instream[1022-7*i]!==1'bx) begin
							arry[146-i] = instream[(1022-7*i)-:7];
							i = i+1;
							state = 4'b1111;
						end
						else begin
							eos = i;
							i=0;
							state = 4'b0000;
							end					
						
					end
			//push instream to encrypt_4673 for decrypt only mode
			4'b1110: begin					 						
						if(instream[1022-14*step]!==1'bx) begin
							encrypt_4673 = instream[(1022-14*step)-:14]; 										
							state = 4'b0100;
							end
						else begin
							eos = step*2;
							i=0;
							state = 4'b1000;
							end
					end
					
			//pushing ascii split into module
			4'b0000: begin
						if(step==eos) begin
							i=0;
							state=4'b1000;
							end
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
							oneBig_4673 = 0;
							oneBig_4673 = tgBASE_4673*100;							
							state = 4'b0000;
							end
						else begin
							oneBig_4673 = oneBig_4673 + tgBASE_4673;				
							state = 4'b0011;
							end
						step = step +1;
					end

			//rsa encryption : encrypt stage 4	
			4'b0011: begin						
						if(i==0) begin
							init = oneBig_4673%n;							
							if(e%2==1) temp = init;
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
							if(d%2==1) temp = init%n;
							else temp = 1;
							i = i+1;
							state = 4'b0100;
							end
						else if(!(2**i<d)) begin
							DoneBig_4673 = temp%n;
							i = 0;
							flag=0;
							state = 4'b0101;
							end
						else begin							
							init = (init**2)%n;
							if(d[i]==1) temp = (temp * init)%n;
							i = i+1;
							state = 4'b0100;
							end
					end

			//split into two DtgBASE64 : decrypt stage 2
			4'b0101: begin
						if(flag==0) begin
							DtgBASE_4673 = (DoneBig_4673 - DoneBig_4673%100)/100;
							end
						else begin
							DtgBASE_4673 = DoneBig_4673%100;
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
							if(mode==0) arry[148-step]= Dascii_4673;
							else arry[146-2*step]= Dascii_4673;
							flag = 1;
							state = 4'b0101;
							end
						else begin			
							if(mode==0) arry[147-step]= Dascii_4673;
							else arry[145-2*step] = Dascii_4673;
							flag = 0;
							state = 4'b0000;
							if(mode==1) begin
								state = 4'b1110;
								step = step + 1;
								end
							end
					end
			
			//flush to outstream
			4'b1000: begin
						if(!(i>eos)) begin
							out_buf[(1022-7*i)-:7] = arry[146-i];
							state = 4'b1000;
							i=i+1;
							end
						else begin
							outstream = out_buf;
							$display("process complete");
							state = 4'b1001;
							end
					end
			
			//system idle
			4'b1001: begin
						step=0;flag=0;i=0;oneBig_4673=0;encrypt_4673=0;DoneBig_4673=0;DtgBASE_4673=0;Dascii_4673=0;
					end
			
			
		endcase
	end
endmodule
