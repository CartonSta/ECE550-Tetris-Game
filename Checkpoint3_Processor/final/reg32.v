module reg32(in,enable,clk,reset,out);

  input [31:0] in;
  input clk, enable, reset;
  output [31:0] out;
  
  generate
	 genvar i;
	     for(i=0;i<32;i=i+1)
		  begin:start
	         dffe_ref dff1(out[i], in[i], clk, enable, reset);
	     end
  endgenerate
  
endmodule