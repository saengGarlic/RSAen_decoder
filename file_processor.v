`timescale 1ns/1ns
module file_processor();
	wire [1022:0] out_stream0, out_stream1, out_stream2;
	reg [1022:0] out_buf0, out_buf1, out_buf2;
	reg [1022:0] in_stream0, in_stream1, in_stream2;
	reg [6:0] arry0 [146:0];
	reg [13:0] arry1 [72:0];
	reg [13:0] arry2 [72:0];
	reg clk;
	
	integer i, j, k, i_end, j_end, k_end, raw0, out0, raw1, out1, raw2, out2;
	
	
	en_decoder_RSA E1(in_stream0,clk,1'b0,out_stream0);
//	en_decoder_RSA D1(in_stream1,clk,1'b1,out_stream1);
//	en_decoder_RSA #(97, 109, 10573, 89, 233) D2(in_stream2,clk,1'b1,out_stream2);
	
	initial begin
		clk = 0;
		i = 0;
		//input file 1: ascii code -> encrypt -> decrypt
		raw0 = $fopen("proj3-input1.txt","rb");
		
		while(!$feof(raw0)) begin
			$fscanf(raw0,"%7b",arry0[146-i]);
			$display("input1 imported: %3d : binary:%14b dec:%4d hex:%4h",i,arry0[146-i],arry0[146-i],arry0[146-i]);
			i = i+1;
		end
		$fclose(raw0);
		i_end = i-1;		
		for(i=0; i<i_end; i=i+1) begin
			in_stream0[1022-7*i-:7] = arry0[146-i];
			end
		
		//input file 2: encrypted code -> decrypt
		j = 0; 
		raw1 = $fopen("proj3-input2.txt","r");
		
		while(!$feof(raw1)) begin
			$fscanf(raw1,"%d\n",arry1[72-j]);
			$display("input2 imported: %3d : binary:%14b dec:%4d hex:%4h",j,arry1[72-j],arry1[72-j],arry1[72-j]);
			j = j+1;
		end
		$fclose(raw1);
		j_end = j;
		
		for(j=0; j<j_end; j=j+1) begin
			in_stream1[(1022-14*j)-:14] = arry1[72-j];
			end
	
		//input file 3: encrypted code -> decrypt w/p=97, q=109, n=10573, e=89, d=116
		k = 0; 
		raw2 = $fopen("proj3-input3.txt","r");
		
		while(!$feof(raw2)) begin
			$fscanf(raw2,"%d\n",arry2[72-k]);
			$display("input3 imported: %3d : binary:%14b dec:%4d hex:%4h",k,arry2[72-k],arry2[72-k],arry2[72-k]);
			k = k+1;
		end
		$fclose(raw2);
		k_end = k;
		
		for(k=0; k<k_end; k=k+1) begin
			in_stream2[(1022-14*k)-:14] = arry2[72-k];
			end
	end
	
	always begin	
		#5 clk = ~clk;
	end

	always@(out_stream0) begin	
		$display("input1 decrypted : %b",out_stream0);
		out_buf0 = out_stream0;
		out0 = $fopen("decryption_out1.txt","w");
		i=0;
		while(out_buf0[1022-7*i]!==1'bx) begin
			$fwrite(out0,"%c",out_buf0[1022-7*i-:7]);
			i = i+1;
			end
		$fclose(out0);
	end
	always@(out_stream1) begin		
		$display("input2 decrypted : %b",out_stream1);
		out_buf1 = out_stream1;
		out1 = $fopen("decryption_out2.txt","w");
		j=0;
		while(out_buf1[1022-7*j]!==1'bx) begin
			$fwrite(out1,"%c",out_buf1[1022-7*j-:7]);
			j = j+1;
			end
		$fclose(out1);
	end
	
	always@(out_stream2) begin		
		$display("input3 decrypted : %b",out_stream2);
		out_buf2 = out_stream2;
		out2 = $fopen("decryption_out3.txt","w");
		k=0;
		while(out_buf2[1022-7*k]!==1'bx) begin
			$fwrite(out2,"%c",out_buf2[1022-7*k-:7]);
			k = k+1;
			end
		$fclose(out2);
	end
	
endmodule