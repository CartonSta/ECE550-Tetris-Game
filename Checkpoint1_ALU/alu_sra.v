module sra_1(in,sel,sign,out);

    input [31:0] in;
	 inout sel,sign;
    output [31:0] out;

	 mux2to1 mux10(in[31],sign,sel,out[31]);
	 generate
	 genvar i;
	     for(i=0;i<31;i=i+1)
		  begin:start1
		      mux2to1 mux11(in[30-i],in[31-i],sel,out[30-i]);
		  end
	 endgenerate

endmodule

module sra_2(in,sel,sign,out);

    input [31:0] in;
	 inout sel,sign;
    output [31:0] out;

	 mux2to1 mux20(in[31],sign,sel,out[31]);
	 mux2to1 mux21(in[30],sign,sel,out[30]);
	 generate
	 genvar j;
	     for(j=0;j<30;j=j+1)
		  begin:start2
		      mux2to1 mux22(in[29-j],in[31-j],sel,out[29-j]);
		  end
	 endgenerate

endmodule

module sra_3(in,sel,sign,out);

    input [31:0] in;
	 inout sel,sign;
    output [31:0] out;

	 mux2to1 mux30(in[31],sign,sel,out[31]);
	 mux2to1 mux31(in[30],sign,sel,out[30]);
	 mux2to1 mux32(in[29],sign,sel,out[29]);
	 mux2to1 mux33(in[28],sign,sel,out[28]);

	 generate
	 genvar k;
	     for(k=0;k<28;k=k+1)
		  begin:start3
		      mux2to1 mux34(in[27-k],in[31-k],sel,out[27-k]);
		  end
	 endgenerate

endmodule

module sra_4(in,sel,sign,out);

    input [31:0] in;
	 inout sel,sign;
    output [31:0] out;

	 generate
	 genvar m;
	     for(m=0;m<8;m=m+1)
		  begin:start4
		      mux2to1 mux40(in[31-m],sign,sel,out[31-m]);
		  end
	 endgenerate
	 
	 generate
	 genvar n;
	     for(n=0;n<24;n=n+1)
		  begin:start41
		      mux2to1 mux41(in[23-n],in[31-n],sel,out[23-n]);
		  end
	 endgenerate

endmodule

module sra_5(in,sel,sign,out);

    input [31:0] in;
	 inout sel,sign;
    output [31:0] out;

	 generate
	 genvar p;
	     for(p=0;p<16;p=p+1)
		  begin:start5
		      mux2to1 mux40(in[31-p],sign,sel,out[31-p]);
		  end
	 endgenerate
	 
	 generate
	 genvar q;
	     for(q=0;q<16;q=q+1)
		  begin:start51
		      mux2to1 mux51(in[15-q],in[31-q],sel,out[15-q]);
		  end
	 endgenerate

endmodule

module alu_sra(data_operandA, ctrl_shiftamt, result_sra);

    input [31:0] data_operandA;
	 input [4:0] ctrl_shiftamt;
	 output [31:0] result_sra;
	 wire [31:0] temp1,temp2,temp3,temp4;
	 
	 sra_1 s1(data_operandA[31:0],ctrl_shiftamt[0],data_operandA[31],temp1[31:0]);
	 sra_2 s2(temp1[31:0],ctrl_shiftamt[1],data_operandA[31],temp2[31:0]);
	 sra_3 s3(temp2[31:0],ctrl_shiftamt[2],data_operandA[31],temp3[31:0]);
	 sra_4 s4(temp3[31:0],ctrl_shiftamt[3],data_operandA[31],temp4[31:0]);
	 sra_5 s5(temp4[31:0],ctrl_shiftamt[4],data_operandA[31],result_sra[31:0]);
	 
endmodule