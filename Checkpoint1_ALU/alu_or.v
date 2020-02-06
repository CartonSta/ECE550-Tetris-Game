module alu_or(data_operandA, data_operandB, result_or);

    input [31:0] data_operandA, data_operandB;
	 
	 output [31:0] result_or;
    
	 genvar i;
	 generate
	     for(i=0;i<32;i=i+1)
		  begin:start
		      or or1(result_or[i],data_operandA[i],data_operandB[i]);
		  end
	 endgenerate
	 
endmodule