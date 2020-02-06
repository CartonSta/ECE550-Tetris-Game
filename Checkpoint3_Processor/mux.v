module mux(a0,a1,sel,out);

	 input a0,a1,sel;
	 output out;
  	 wire not_sel;
    wire temp1,temp2;
    wire Data_out_temp;

    not n1(not_sel,sel);  
    and and_1(temp1,a0,not_sel);
    and and_2(temp2,a1,sel);
    or or_1(out,temp1,temp2);
	
endmodule