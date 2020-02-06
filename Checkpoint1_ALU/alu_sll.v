module sll_1(in,sel,out);

    input [31:0] in;
	 inout sel;
    output [31:0] out;

	 mux2to1 mux10(in[0],0,sel,out[0]);
	 generate
	 genvar i;
	     for(i=0;i<31;i=i+1)
		  begin:start1
		      mux2to1 mux11(in[i+1],in[i],sel,out[i+1]);
		  end
	 endgenerate

endmodule

module sll_2(in,sel,out);

    input [31:0] in;
	 inout sel;
    output [31:0] out;

	 mux2to1 mux20(in[0],0,sel,out[0]);
	 mux2to1 mux21(in[1],0,sel,out[1]);
	 generate
	 genvar j;
	     for(j=0;j<30;j=j+1)
		  begin:start2
		      mux2to1 mux22(in[j+2],in[j],sel,out[j+2]);
		  end
	 endgenerate

endmodule

module sll_3(in,sel,out);

    input [31:0] in;
	 inout sel;
    output [31:0] out;

	 mux2to1 mux30(in[0],0,sel,out[0]);
	 mux2to1 mux31(in[1],0,sel,out[1]);
	 mux2to1 mux32(in[2],0,sel,out[2]);
	 mux2to1 mux33(in[3],0,sel,out[3]);

	 generate
	 genvar k;
	     for(k=0;k<28;k=k+1)
		  begin:start3
		      mux2to1 mux34(in[k+4],in[k],sel,out[k+4]);
		  end
	 endgenerate

endmodule

module sll_4(in,sel,out);

    input [31:0] in;
	 inout sel;
    output [31:0] out;

	 generate
	 genvar m;
	     for(m=0;m<8;m=m+1)
		  begin:start4
		      mux2to1 mux40(in[m],0,sel,out[m]);
		  end
	 endgenerate
	 
	 generate
	 genvar n;
	     for(n=0;n<24;n=n+1)
		  begin:start41
		      mux2to1 mux41(in[n+8],in[n],sel,out[n+8]);
		  end
	 endgenerate

endmodule

module sll_5(in,sel,out);

    input [31:0] in;
	 inout sel;
    output [31:0] out;

	 generate
	 genvar p;
	     for(p=0;p<16;p=p+1)
		  begin:start5
		      mux2to1 mux40(in[p],0,sel,out[p]);
		  end
	 endgenerate
	 
	 generate
	 genvar q;
	     for(q=0;q<16;q=q+1)
		  begin:start51
		      mux2to1 mux51(in[q+16],in[q],sel,out[q+16]);
		  end
	 endgenerate

endmodule

module alu_sll(data_operandA, ctrl_shiftamt, result_sll);

    input [31:0] data_operandA;
	 input [4:0] ctrl_shiftamt;
	 output [31:0] result_sll;
	 wire [31:0] temp1,temp2,temp3,temp4;
	 
	 sll_1 s1(data_operandA[31:0],ctrl_shiftamt[0],temp1[31:0]);
	 sll_2 s2(temp1[31:0],ctrl_shiftamt[1],temp2[31:0]);
	 sll_3 s3(temp2[31:0],ctrl_shiftamt[2],temp3[31:0]);
	 sll_4 s4(temp3[31:0],ctrl_shiftamt[3],temp4[31:0]);
	 sll_5 s5(temp4[31:0],ctrl_shiftamt[4],result_sll[31:0]);
	 
endmodule