module alu_and(data_operandA, data_operandB, result_and);

    input [31:0] data_operandA, data_operandB;
	 
	 output [31:0] result_and;
    
	 genvar i;
	 generate
	     for(i=0;i<32;i=i+1)
		  begin:start
		      and and1(result_and[i],data_operandA[i],data_operandB[i]);
		  end
	 endgenerate
	 
endmodule