module tristate_buffer(in, enable, out);

    input [31:0] in;
    input enable;
    output [31:0] out;
    generate
	 genvar i;
	     for(i=0;i<32;i=i+1)
		  begin:start1
            assign out[i] = enable? in[i] : 1'bz;
		  end
    endgenerate	  

endmodule