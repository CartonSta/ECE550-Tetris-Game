module full_adder(a,b,ci,sum,co);

    input a,b,ci;
    output sum,co;
 
    wire w1, w2, w3;
 
    xor g1 (w1, a, b);
    xor g2 (sum, ci, w1);
    and g3 (w2, w1, ci);
    and g4 (w3, a, b);
    or g5 (co, w2, w3);
 
endmodule


module RCA(in1,in2,ci,sum,co);

	input[15:0] in1,in2;
	input ci;
	output[15:0] sum;
	output co;
	
	wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15;
	
	
	full_adder u0 (in1[0], in2[0], ci, sum[0], c1);
   full_adder u1 (in1[1], in2[1], c1, sum[1], c2);
	full_adder u2 (in1[2], in2[2], c2, sum[2], c3);
	full_adder u3 (in1[3], in2[3], c3, sum[3], c4);
	full_adder u4 (in1[4], in2[4], c4, sum[4], c5);
   full_adder u5 (in1[5], in2[5], c5, sum[5], c6);
	full_adder u6 (in1[6], in2[6], c6, sum[6], c7);
	full_adder u7 (in1[7], in2[7], c7, sum[7], c8);
	full_adder u8 (in1[8], in2[8], c8, sum[8], c9);
   full_adder u9 (in1[9], in2[9], c9, sum[9], c10);
	full_adder u10 (in1[10], in2[10], c10, sum[10], c11);
	full_adder u11 (in1[11], in2[11], c11, sum[11], c12);
	full_adder u12 (in1[12], in2[12], c12, sum[12], c13);
   full_adder u13 (in1[13], in2[13], c13, sum[13], c14);
	full_adder u14 (in1[14], in2[14], c14, sum[14], c15);
	full_adder u15 (in1[15], in2[15], c15, sum[15], co);
	
endmodule


module alu_add(data_operandA, data_operandB, result_add, overflow);

    input [31:0] data_operandA, data_operandB;
	 output [31:0] result_add;
    output overflow;
	 
	 wire co,co0,co1;
	 wire [15:0] sum0,sum1;
	 wire notA31,notB31,notC31,temp,temp2;
	 
	 RCA RCA0(data_operandA[15:0],data_operandB[15:0],1'b0,result_add[15:0],co);
	 RCA RCA1(data_operandA[31:16],data_operandB[31:16],1'b0,sum0[15:0],co0);
	 RCA RCA2(data_operandA[31:16],data_operandB[31:16],1'b1,sum1[15:0],co1);
	 generate
	 genvar i;
	     for(i=0;i<16;i=i+1)
		  begin:start
            mux2to1 mux0(sum0[i],sum1[i],co,result_add[i+16]);
	     end
	 endgenerate
	 
	 not not0(notA31, data_operandA[31]);
	 not not1(notB31, data_operandB[31]);
	 not not2(notC31, result_add[31]);
	 and and1(temp, notA31, notB31, result_add[31]);
    and and2(temp2, data_operandA[31], data_operandB[31], notC31);
	 or or1(overflow, temp, temp2);
	 
endmodule