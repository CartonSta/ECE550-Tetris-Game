module alu_subtract(data_operandA, data_operandB, result_subtract,
 isNotEqual, isLessThan, overflow);

    input [31:0] data_operandA, data_operandB;
	 
	 output [31:0] result_subtract;
    output isNotEqual, isLessThan,overflow;
	 
	 wire [31:0] not_data_operandB, temp, temp2;
	 wire [15:0] temp3;
	 wire [7:0] temp4;
	 wire [3:0] temp5;
	 wire notA31, notB31, notC31, temp01, temp02, temp6, temp7, co1, co2;
	 //result_subtract
	 generate
	 genvar i;
	     for(i=0;i<32;i=i+1)
		  begin:start
            not not1(not_data_operandB[i], data_operandB[i]);
	     end
	 endgenerate
	 RCA RCA1(not_data_operandB[15:0], 32'h00000000, 1'b1, temp[15:0], co1);
	 RCA RCA2(not_data_operandB[31:16], 32'h00000000, co1, temp[31:16], co2);
	 alu_add alu_add1(data_operandA[31:0], temp[31:0], result_subtract[31:0]);
	 //overflow
	 not not0(notA31, data_operandA[31]);
	 not not1(notB31, data_operandB[31]);
	 not not2(notC31, result_subtract[31]);
	 and and1(temp01, notA31, data_operandB[31], result_subtract[31]);
    and and2(temp02, data_operandA[31], notB31, notC31);
	 or or1(overflow, temp01, temp02);
	 //isNotEqual
	 generate
	 genvar k;
	     for(k=0;k<32;k=k+1)
		  begin:bit1
            xor xor1(temp2[k], data_operandA[k], data_operandB[k]);
	     end
	 endgenerate
	 generate
	 genvar j;
	     for(j=0;j<16;j=j+1)
		  begin:bit2
            or or1(temp3[j], temp2[2*j], temp2[2*j+1]);
	     end
	 endgenerate
	 generate
	 genvar m;
	     for(m=0;m<8;m=m+1)
		  begin:bit3
            or or2(temp4[m], temp3[2*m], temp3[2*m+1]);
	     end
	 endgenerate
	 generate
	 genvar n;
	     for(n=0;n<4;n=n+1)
		  begin:bit4
            or or3(temp5[n], temp4[2*n], temp4[2*n+1]);
	     end
	 endgenerate
	 or or4(temp6, temp5[0], temp5[1]);
	 or or5(temp7, temp5[2], temp5[3]);
	 or or6(isNotEqual, temp6, temp7);
	 //isLessThan
	 xor xor2(isLessThan, result_subtract[31], overflow);
	 
endmodule