
module regfile(
clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB,
//modified
reg2, reg3, reg4, reg5, reg6, reg8, reg30, reg31
);

    input clock, ctrl_writeEnable, ctrl_reset;
    input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    input [31:0] data_writeReg;
    output [31:0] data_readRegA, data_readRegB;
	 
	 wire [31:0] temp_writeEnable, reg_Enable, enableA, enableB;
	 wire [31:0] out_writeReg [31:0], data_toread[31:0];

	 decoder5to32 decoder1(ctrl_writeReg[4:0], temp_writeEnable[31:0]);
	 generate
	 genvar i;
	     for(i=0;i<32;i=i+1)
		  begin:start1
	         and and1(reg_Enable[i], ctrl_writeEnable, temp_writeEnable[i]);
	     end
	 endgenerate
	 
	 generate
	 genvar j;
	     for(j=0;j<32;j=j+1)
		  begin:start2
	         reg32 reg32_2(data_writeReg[31:0],reg_Enable[j],clock,
				ctrl_reset,out_writeReg[j][31:0]);
	     end
	 endgenerate 
	 
	 assign data_toread[0][31:0] = 32'h00000000;
	 generate
	 genvar k;
	     for(k=1;k<32;k=k+1)
		  begin:start3
		      assign data_toread[k][31:0] = out_writeReg[k][31:0];
		  end
	 endgenerate

	 decoder5to32 decoder2(ctrl_readRegA[4:0], enableA[31:0]);
	 decoder5to32 decoder3(ctrl_readRegB[4:0], enableB[31:0]);
	 
	 generate
	 genvar m;
	     for(m=0;m<32;m=m+1)
		  begin:start4
	         tristate_buffer trb1(data_toread[m][31:0], enableA[m], data_readRegA[31:0]);
	     end
	 endgenerate
	 
    generate
	 genvar n;
	     for(n=0;n<32;n=n+1)
		  begin:start5
	         tristate_buffer trb2(data_toread[n][31:0], enableB[n], data_readRegB[31:0]);
	     end
	 endgenerate
	 
	 //modified
	 output [31:0] reg2, reg3, reg4, reg5, reg6, reg8, reg30, reg31;
	 assign reg2[31:0] = data_toread[2][31:0];
	 assign reg3[31:0] = data_toread[3][31:0];
	 assign reg4[31:0] = data_toread[4][31:0];
	 assign reg5[31:0] = data_toread[5][31:0];
	 assign reg6[31:0] = data_toread[6][31:0];
	 assign reg8[31:0] = data_toread[8][31:0];
	 assign reg30[31:0] = data_toread[30][31:0];
	 assign reg31[31:0] = data_toread[31][31:0];
	 
endmodule