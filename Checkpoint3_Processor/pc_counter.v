module pc_counter(clk, rst, pc_in, pc_out);
 input clk, rst;
 input [31:0] pc_in;
 output reg[31:0] pc_out;
 
 initial begin
     pc_out <= 32'd0;
 end
 
 always @(posedge clk) begin
 if(rst)
     pc_out <= 32'd0;
 else
     pc_out <= pc_in;
 end

 endmodule
 