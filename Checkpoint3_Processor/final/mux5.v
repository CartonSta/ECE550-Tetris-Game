module mux5(a0,a1,sel,out);
    
	 input [4:0] a0,a1;
	 input sel;
	 output [4:0] out;

	 generate
	 genvar i;
	     for(i=0;i<5;i=i+1)
		  begin:start
            mux mux0(a0[i],a1[i],sel,out[i]);
	     end
	 endgenerate

endmodule
