module alu(data_operandA, data_operandB, ctrl_ALUopcode,
ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	 
    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;
	 
	 wire [31:0] result_add, result_subtract, result_and, result_or, result_sll, result_sra;
	 wire [7:0] result_sel;
	 wire isNotEqual_subtract,isLessThan_subtract,overflow_add, overflow_subtract;
	 
	 alu_add add32(data_operandA[31:0], data_operandB[31:0], result_add[31:0], overflow_add);
	 alu_subtract subtract32(data_operandA[31:0], data_operandB[31:0], 
	 result_subtract[31:0], isNotEqual_subtract, isLessThan_subtract, overflow_subtract);
	 alu_and and32(data_operandA[31:0], data_operandB[31:0], result_and[31:0]);
	 alu_or or32(data_operandA[31:0], data_operandB[31:0], result_or[31:0]);
	 alu_sll sll32(data_operandA[31:0], ctrl_shiftamt[4:0], result_sll[31:0]);
	 alu_sra sra32(data_operandA[31:0], ctrl_shiftamt[4:0], result_sra[31:0]);
	 
	 generate
	 genvar i;
	     for(i=0;i<32;i=i+1)
		  begin:start
	         mux8to1 mux1(result_add[i],result_subtract[i],result_and[i],result_or[i],
				result_sll[i],result_sra[i],1'b0,1'b0,ctrl_ALUopcode[2:0],data_result[i]);
		  end
	 endgenerate
	 mux8to1 mux2(1'b0,isNotEqual_subtract,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,
	 ctrl_ALUopcode[2:0],isNotEqual);
	 mux8to1 mux3(1'b0,isLessThan_subtract,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,
	 ctrl_ALUopcode[2:0],isLessThan);
	 mux8to1 mux4(overflow_add,overflow_subtract,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,
	 ctrl_ALUopcode[2:0],overflow);
	 
endmodule