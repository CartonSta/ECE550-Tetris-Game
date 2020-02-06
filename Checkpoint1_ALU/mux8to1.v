module mux4to1(a0,a1,a2,a3,sel,out);
	input a0,a1,a2,a3;
	input [1:0] sel;
	output out;

	wire mux0,mux1;

	mux2to1 m1 (a0,a1,sel[0],mux0);
	mux2to1 m2 (a2,a3,sel[0],mux1);
	mux2to1 m3 (mux0,mux1,sel[1],out);
endmodule

module mux8to1(a0,a1,a2,a3,a4,a5,a6,a7,sel,out);
	input a0,a1,a2,a3,a4,a5,a6,a7;
	input [2:0] sel;
	output out;

	wire mux2,mux3;

	mux4to1 m1 (a0,a1,a2,a3,sel[1:0],mux2);
	mux4to1 m2 (a4,a5,a6,a7,sel[1:0],mux3);
	mux2to1 m3 (mux2,mux3,sel[2],out);
endmodule