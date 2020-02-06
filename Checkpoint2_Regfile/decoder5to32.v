
module decoder2to4(in,en,out);

    input [1:0] in;
	 input en;
	 output [3:0] out;
	 wire [1:0] not_in;
	 
	 not not1(not_in[0],in[0]);
	 not not2(not_in[1],in[1]);
	 and and1(out[3],in[0],in[1],en);
	 and and2(out[2],not_in[0],in[1],en);
	 and and3(out[1],in[0],not_in[1],en);
	 and and4(out[0],not_in[0],not_in[1],en);
	 
endmodule


module decoder3to8(in,en,out);

    input [2:0] in;
	 input en;
	 output [7:0] out;
	 wire not_in2,en1,en2;
	 
	 and and5(en2,en,in[2]);
	 decoder2to4 d1(in[1:0],en2,out[7:4]);
	 not not3(not_in2,in[2]);
	 and and6(en1,en,not_in2);
	 decoder2to4 d2(in[1:0],en1,out[3:0]);	 

endmodule


module decoder5to32(in,out);

    input [4:0] in;
    output [31:0] out;
    wire [3:0] en;
	 
	 decoder2to4 d3(in[4:3],1'd1,en[3:0]);
	 decoder3to8 d4(in[2:0],en[0],out[7:0]);
	 decoder3to8 d5(in[2:0],en[1],out[15:8]);
	 decoder3to8 d6(in[2:0],en[2],out[23:16]);
	 decoder3to8 d7(in[2:0],en[3],out[31:24]);

endmodule