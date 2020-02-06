module mux5_4to1(a0,a1,a2,a3,sel,out);
	input [4:0] a0,a1,a2,a3;
	input [1:0] sel;
	output [4:0] out;

	wire [4:0] mux0,mux1;
   
	generate
	genvar i;
	    for(i=0;i<5;i=i+1)
		 begin:start
           mux m1 (a0[i],a1[i],sel[0],mux0[i]);
	        mux m2 (a2[i],a3[i],sel[0],mux1[i]);
	        mux m3 (mux0[i],mux1[i],sel[1],out[i]);
	    end
	endgenerate
	
endmodule