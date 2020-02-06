module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
        key_p,
        key_ctrl
        );

 
input iRST_n;
input iVGA_CLK;

input key_p;
input [7:0] key_ctrl;

output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;  
                      
////////////          
reg[9:0] x;
reg[9:0] y;
reg[2:0] rot; 
// to record rotations     
reg[20:0] count;
wire[15:0] rand_num;

random rand_gen (.clk(clk), .rand_num(rand_num));

reg clk;      
reg [18:0] ADDR;
reg[15:0] black[23:0];
// to label fixed squares
reg[4:0] rmv[23:0];
// to record squares for every row
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));

////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end


//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data img_data_inst (
 .address ( ADDR ),
 .clock ( VGA_CLK_n ),
 .q ( index )
 );
 
/////////////////////////
//////Add switch-input logic here
 
//////Color table output
img_index img_index_inst (
 .address ( index ),
 .clock ( iVGA_CLK ),
 .q ( bgr_data_raw)
 ); 
//////

integer score;
integer i;
integer k;
reg falled;   // whether current square has falled
integer w;

initial
begin
 w <= 20;
 x <= 140;
 y <= 0;
 count <= 0;
 i <= rand_num % 5;     // random shape
 rot <= 0; 			// initialize rotation to 0
 score <= 0;
 falled <= 0;

 for(k=0;k<24;k=k+1)
    begin
  black[k][15:0] <= 0;
  rmv[k] <=0;
  end

end

always @(posedge(VGA_CLK_n))
begin
 count <= count +1;
 if(count == 50000)
  clk = ~clk;
end 

always @(posedge(VGA_CLK_n)) 
begin

if (ADDR%640<320) begin

  if (i==0) begin
		if (((ADDR%640 <= x+2*w) && (ADDR%640 >= x) 
			&& (ADDR/640 <= y+2*w) && (ADDR/640 >= y))
		 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
		 bgr_data <= 6'h00FF00;
		else
		 bgr_data <= bgr_data_raw;
	end
   
  else if(i == 1) begin
		if (rot == 0) begin
		  if ((((ADDR%640 <= x+2*w) && (ADDR%640 >= x) &&
			(ADDR/640 <= y+w) && (ADDR/640 >= y))
			  || ((ADDR%640 <= x+3*w) && (ADDR%640 >= x+w) &&
			(ADDR/640 <= y+2*w) && (ADDR/640 >= y+w)))
				||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			  bgr_data <= 6'h00FF00;
		  else
			  bgr_data <= bgr_data_raw;
	   end
		else begin
			if ((((ADDR%640 <= x+3*w) && (ADDR%640 >= x+2*w) &&
			(ADDR/640 <= y+2*w) && (ADDR/640 >= y))
			  || ((ADDR%640 <= x+2*w) && (ADDR%640 >= x+w) &&
			(ADDR/640 <= y+3*w) && (ADDR/640 >= y+w)))
			   ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			  bgr_data <= 6'h00FF00;
		  else
			  bgr_data <= bgr_data_raw;
		
		end
	end
   
  else if(i == 2) begin
		if (rot == 0) begin
			if ((((ADDR%640 <= x+3*w) && (ADDR%640 >= x) &&
				(ADDR/640 <= y+2*w) && (ADDR/640 >= y+w))
			 || ((ADDR%640 <= x+2*w) && (ADDR%640 >= x+w) &&
			 (ADDR/640 <= y+w) && (ADDR/640 >= y)))
			 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			 bgr_data <= 6'h00FF00;
			else
			 bgr_data <= bgr_data_raw;
		end
		
		else if (rot == 1) begin
			if ((((ADDR%640 <= x+w) && (ADDR%640 >= x) &&
				(ADDR/640 <= y+2*w) && (ADDR/640 >= y+w))
			 || ((ADDR%640 <= x+2*w) && (ADDR%640 >= x+w) &&
			 (ADDR/640 <= y+3*w) && (ADDR/640 >= y)))
			 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			 bgr_data <= 6'h00FF00;
			else
			 bgr_data <= bgr_data_raw;
		end
		
		else if (rot == 2) begin
			if ((((ADDR%640 <= x+3*w) && (ADDR%640 >= x) &&
				(ADDR/640 <= y+2*w) && (ADDR/640 >= y+w))
			 || ((ADDR%640 <= x+2*w) && (ADDR%640 >= x+w) &&
			 (ADDR/640 <= y+3*w) && (ADDR/640 >= y+2*w)))
			 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			 bgr_data <= 6'h00FF00;
			else
			 bgr_data <= bgr_data_raw;
		end
		
		else begin
			if ((((ADDR%640 <= x+3*w) && (ADDR%640 >= x+2*w) &&
				(ADDR/640 <= y+2*w) && (ADDR/640 >= y+w))
			 || ((ADDR%640 <= x+2*w) && (ADDR%640 >= x+w) &&
			 (ADDR/640 <= y+3*w) && (ADDR/640 >= y)))
			 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			 bgr_data <= 6'h00FF00;
			else
			 bgr_data <= bgr_data_raw;
		end		 
		 
	end
   
  else if(i == 3) begin
		if (rot == 0) begin
			if ((((ADDR%640 <= x+w) && (ADDR%640 >= x) &&
				(ADDR/640 <= y+3*w) && (ADDR/640 >= y))
			 || ((ADDR%640 <= x+2*w) && (ADDR%640 >= x+w) &&
			 (ADDR/640 <= y+3*w) && (ADDR/640 >= y+2*w)))
			 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			 bgr_data <= 6'h00FF00;
			else
			 bgr_data <= bgr_data_raw;
		end
		
		else if (rot == 1) begin
			if ((((ADDR%640 <= x+3*w) && (ADDR%640 >= x+2*w) &&
				(ADDR/640 <= y+w) && (ADDR/640 >= y))
			 || ((ADDR%640 <= x+3*w) && (ADDR%640 >= x) &&
			 (ADDR/640 <= y+2*w) && (ADDR/640 >= y+w)))
			 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			 bgr_data <= 6'h00FF00;
			else
			 bgr_data <= bgr_data_raw;
		end
		
		else if (rot == 2) begin
			if ((((ADDR%640 <= x+w) && (ADDR%640 >= x) &&
				(ADDR/640 <= y+w) && (ADDR/640 >= y))
			 || ((ADDR%640 <= x+2*w) && (ADDR%640 >= x+w) &&
			 (ADDR/640 <= y+3*w) && (ADDR/640 >= y)))
			 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			 bgr_data <= 6'h00FF00;
			else
			 bgr_data <= bgr_data_raw;
		end
		
		else begin
			if ((((ADDR%640 <= x+w) && (ADDR%640 >= x) &&
				(ADDR/640 <= y+3*w) && (ADDR/640 >= y+2*w))
			 || ((ADDR%640 <= x+3*w) && (ADDR%640 >= x) &&
			 (ADDR/640 <= y+2*w) && (ADDR/640 >= y+w)))
			 ||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			 bgr_data <= 6'h00FF00;
			else
			 bgr_data <= bgr_data_raw;
		end
		
	end
	 
  else begin
		if (rot == 0) begin
		  if (((ADDR%640 <= x+w) && (ADDR%640 >= x) 
			  && (ADDR/640 <= y+4*w) && (ADDR/640 >= y))
			||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			bgr_data <= 6'h00FF00;
		  else
			  bgr_data <= bgr_data_raw;
		end
		
		else begin
			if (((ADDR%640 <= x+4*w) && (ADDR%640 >= x) 
			  && (ADDR/640 <= y+w) && (ADDR/640 >= y))
			||(black[ADDR/640/w][ADDR%640/w]==1'b1))
			bgr_data <= 6'h00FF00;
		  else
			  bgr_data <= bgr_data_raw;
		end
			
   end

  end
 
 else if (ADDR%640 < 330)
    begin 
    if(ADDR%640 == 320)
	    bgr_data <= 6'h00FF00;
    else
	    bgr_data <= bgr_data_raw;
	 end
		 
 else if (ADDR%640 < 450)
    begin
	 if (score/100 == 0)
	    begin
		 if (((((ADDR%640 >= 19*w) && (ADDR%640 <= 20*w))
		    || ((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w)))  
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 20*w) && (ADDR%640 <= 21*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end
	 else if (score/100 == 1)
	    begin
       if (((ADDR%640 >= 20*w) && (ADDR%640 <= 21*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/100 == 2)
	    begin
       if ((((ADDR%640 >= 19*w) && (ADDR%640 <= 22*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 ||((((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w))
			 && ((ADDR/640 >= 2*w) && (ADDR/640 <= 3*w)))
			 || (((ADDR%640 >= 19*w) && (ADDR%640 <= 20*w))
			 && ((ADDR/640 >= 4*w) && (ADDR/640 <= 5*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/100 == 3)
	    begin
       if (((((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))
			 && ((ADDR%640 >= 19*w) && (ADDR%640 <= 22*w)))
		    || (((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end	 
	 else if (score/100 == 4)
	    begin
       if ((((ADDR%640 >= 19*w) && (ADDR%640 <= 20*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 4*w)))
		    || (((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 20*w) && (ADDR%640 <= 21*w)) 
	       && ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)))
		    )
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/100 == 5)
	    begin
       if ((((ADDR%640 >= 19*w) && (ADDR%640 <= 22*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 ||((((ADDR%640 >= 19*w) && (ADDR%640 <= 20*w))
			 && ((ADDR/640 >= 2*w) && (ADDR/640 <= 3*w)))
			 || (((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w))
			 && ((ADDR/640 >= 4*w) && (ADDR/640 <= 5*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/100 == 6)
	    begin
		 if ((((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 6*w))))
		    || (((ADDR%640 >= 20*w) && (ADDR%640 <= 21*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 || (((ADDR%640 >= 19*w) && (ADDR%640 <= 20*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end 
	 else if (score/100 == 7)
	    begin
       if ((((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 19*w) && (ADDR%640 <= 21*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 2*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/100 == 8)
	    begin
		 if (((((ADDR%640 >= 19*w) && (ADDR%640 <= 20*w))
		    || ((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w)))  
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 20*w) && (ADDR%640 <= 21*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end
	 else if (score/100 == 9)
	    begin
		 if ((((ADDR%640 >= 19*w) && (ADDR%640 <= 20*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
		    || (((ADDR%640 >= 20*w) && (ADDR%640 <= 21*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 || (((ADDR%640 >= 21*w) && (ADDR%640 <= 22*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end	 
	 end
 
 else if (ADDR%640 < 530)
    begin
	 if (score/10%10 == 0)
	    begin
		 if (((((ADDR%640 >= 23*w) && (ADDR%640 <= 24*w))
		    || ((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w)))  
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 24*w) && (ADDR%640 <= 25*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end
	 else if (score/10%10 == 1)
	    begin
       if (((ADDR%640 >= 24*w) && (ADDR%640 <= 25*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/10%10 == 2)
	    begin
       if ((((ADDR%640 >= 23*w) && (ADDR%640 <= 26*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 ||((((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w))
			 && ((ADDR/640 >= 2*w) && (ADDR/640 <= 3*w)))
			 || (((ADDR%640 >= 23*w) && (ADDR%640 <= 24*w))
			 && ((ADDR/640 >= 4*w) && (ADDR/640 <= 5*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/10%10 == 3)
	    begin
       if (((((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))
			 && ((ADDR%640 >= 23*w) && (ADDR%640 <= 26*w)))
		    || (((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end	 
	 else if (score/10%10 == 4)
	    begin
       if ((((ADDR%640 >= 23*w) && (ADDR%640 <= 24*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 4*w)))
		    || (((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 24*w) && (ADDR%640 <= 25*w)) 
	       && ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)))
		    )
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/10%10 == 5)
	    begin
       if ((((ADDR%640 >= 23*w) && (ADDR%640 <= 26*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 ||((((ADDR%640 >= 23*w) && (ADDR%640 <= 24*w))
			 && ((ADDR/640 >= 2*w) && (ADDR/640 <= 3*w)))
			 || (((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w))
			 && ((ADDR/640 >= 4*w) && (ADDR/640 <= 5*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/10%10 == 6)
	    begin
		 if ((((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 6*w))))
		    || (((ADDR%640 >= 24*w) && (ADDR%640 <= 25*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 || (((ADDR%640 >= 23*w) && (ADDR%640 <= 24*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end 
	 else if (score/10%10 == 7)
	    begin
       if ((((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 23*w) && (ADDR%640 <= 25*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 2*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score/10%10 == 8)
	    begin
		 if (((((ADDR%640 >= 23*w) && (ADDR%640 <= 24*w))
		    || ((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w)))  
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 24*w) && (ADDR%640 <= 25*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end
	 else if (score/10%10 == 9)
	    begin
		 if ((((ADDR%640 >= 23*w) && (ADDR%640 <= 24*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
		    || (((ADDR%640 >= 24*w) && (ADDR%640 <= 25*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 || (((ADDR%640 >= 25*w) && (ADDR%640 <= 26*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end	 
	 end
 
 else 
    begin
	 if (score%10 == 0)
	    begin
		 if (((((ADDR%640 >= 27*w) && (ADDR%640 <= 28*w))
		    || ((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w)))  
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 28*w) && (ADDR%640 <= 29*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end
	 else if (score%10 == 1)
	    begin
       if (((ADDR%640 >= 28*w) && (ADDR%640 <= 29*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score%10 == 2)
	    begin
       if ((((ADDR%640 >= 27*w) && (ADDR%640 <= 30*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 ||((((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w))
			 && ((ADDR/640 >= 2*w) && (ADDR/640 <= 3*w)))
			 || (((ADDR%640 >= 27*w) && (ADDR%640 <= 28*w))
			 && ((ADDR/640 >= 4*w) && (ADDR/640 <= 5*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score%10 == 3)
	    begin
       if (((((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))
			 && ((ADDR%640 >= 27*w) && (ADDR%640 <= 30*w)))
		    || (((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end	 
	 else if (score%10 == 4)
	    begin
       if ((((ADDR%640 >= 27*w) && (ADDR%640 <= 28*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 4*w)))
		    || (((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 28*w) && (ADDR%640 <= 29*w)) 
	       && ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)))
		    )
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score%10 == 5)
	    begin
       if ((((ADDR%640 >= 27*w) && (ADDR%640 <= 30*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 ||((((ADDR%640 >= 27*w) && (ADDR%640 <= 28*w))
			 && ((ADDR/640 >= 2*w) && (ADDR/640 <= 3*w)))
			 || (((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w))
			 && ((ADDR/640 >= 4*w) && (ADDR/640 <= 5*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score%10 == 6)
	    begin
		 if ((((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 2*w)) 
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 6*w))))
		    || (((ADDR%640 >= 28*w) && (ADDR%640 <= 29*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 || (((ADDR%640 >= 27*w) && (ADDR%640 <= 28*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end 
	 else if (score%10 == 7)
	    begin
       if ((((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 27*w) && (ADDR%640 <= 29*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 2*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;	
       end
	 else if (score%10 == 8)
	    begin
		 if (((((ADDR%640 >= 27*w) && (ADDR%640 <= 28*w))
		    || ((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w)))  
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w)))
			 || (((ADDR%640 >= 28*w) && (ADDR%640 <= 29*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w)))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end
	 else if (score%10 == 9)
	    begin
		 if ((((ADDR%640 >= 27*w) && (ADDR%640 <= 28*w)) 
	       && (((ADDR/640 >= w) && (ADDR/640 <= 4*w)) 
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
		    || (((ADDR%640 >= 28*w) && (ADDR%640 <= 29*w))
			 && (((ADDR/640 >= w) && (ADDR/640 <= 2*w))
			 || ((ADDR/640 >= 3*w) && (ADDR/640 <= 4*w))
			 || ((ADDR/640 >= 5*w) && (ADDR/640 <= 6*w))))
			 || (((ADDR%640 >= 29*w) && (ADDR%640 <= 30*w)) 
	       && ((ADDR/640 >= w) && (ADDR/640 <= 6*w))))
          bgr_data <= 6'h00FF00;
       else
          bgr_data <= bgr_data_raw;
		 end	 
	 end
end

/////////////////////////////   remove row  /////////////////////////


integer b, c;
//
always @(posedge(clk)) 

begin

 if (rmv[0]!= 0) begin       // game over
  score <= 0;
  
  for(k=23;k>=0;k=k-1)
    begin
  black[k][15:0] <= 0;
  rmv[k] <=0;
  end
  
   falled <= 0;
	y <= 0;
	
 end
 
 else begin
 
 for(b=23;b>0;b=b-1) begin   
    if (rmv[b] == 16) begin
	 score <= score + 10;
    for(c=b;c>0;c=c-1) begin
       rmv[c] <= rmv[c-1];
       black[c][15:0] <= black[c-1][15:0];
    end
    rmv[0] <= 0;
    black[0][15:0] <= 0;
  end
 end
 end 

////////////////////////////////////////////////////////////////////////////

if (falled==1) begin	
	falled <= 0;
	end

else begin

 if(i==0) begin
	  if (( y + 2*w < 480) && ( black[y/w+2][x/w] != 1 ) 
	  && ( black[y/w+2][x/w+1] != 1 )) begin
		  if (score < 30)
				 y <= y + w/2;
			 else
				 y <= y + w;
	  end
  
	  else begin
		  score <= score+1;
		  black[y/w][x/w] <= 1'b1;
		  black[y/w+1][x/w] <= 1'b1;
		  black[y/w][x/w+1] <= 1'b1;
		  black[y/w+1][x/w+1] <= 1'b1;
		  
			 rmv[y/w] = rmv[y/w] + 2;
			 rmv[y/w+1] = rmv[y/w+1] + 2;
			 
			 y <= 0;
			 falled <= 1;
			 i <= rand_num % 5;
			 //rot <= 0;
		 end
 end

 else if(i==1) begin
		if (rot == 0) begin
			 if (( y + 2*w < 480) && ( black[y/w+2][x/w+1] != 1 ) 
				 && ( black[y/w+2][x/w+2] != 1 )
				 && (black[y/w+1][x/w] != 1)) begin
				 if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			end
		
		  else begin 
			score <= score+1;
			black[y/w][x/w] <= 1'b1;
			black[y/w][x/w+1] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w+1][x/w+2] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 2;
			rmv[y/w+1] = rmv[y/w+1] + 2;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	 
	else begin
		 if (( y + 3*w < 480) && ( black[y/w+3][x/w+1] != 1 ) 
			 && ( black[y/w+2][x/w+2] != 1 )) begin
			 if (score < 30)
				 y <= y + w/2;
			 else
				 y <= y + w;
			end
		
		  else begin 
			score <= score+1;
			black[y/w][x/w+2] <= 1'b1;
			black[y/w+2][x/w+1] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w+1][x/w+2] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 2;
			rmv[y/w+2] = rmv[y/w+2] + 1;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	
  end

 else if(i==2) begin
	if (rot == 0) begin
		  if (( y + 2*w < 480) && ( black[y/w+2][x/w] != 1 ) 
		  && ( black[y/w+2][x/w+1] != 1 ) && ( black[y/w+2][x/w+2] != 1 ))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			
		  else begin
			score <= score+1;
			black[y/w][x/w+1] <= 1'b1;
			black[y/w+1][x/w] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w+1][x/w+2] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 3;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	 
	else if (rot == 1) begin
		  if (( y + 3*w < 480) && ( black[y/w+2][x/w] != 1 ) 
		  && ( black[y/w+3][x/w+1] != 1 ))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			
		  else begin
			score <= score+1;
			black[y/w][x/w+1] <= 1'b1;
			black[y/w+1][x/w] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w+2][x/w+1] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 2;
			rmv[y/w+2] = rmv[y/w+2] + 1;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	 
	else if (rot == 2) begin
		  if (( y + 3*w < 480) && ( black[y/w+2][x/w] != 1 ) 
		  && ( black[y/w+3][x/w+1] != 1 ) && ( black[y/w+2][x/w+2] != 1 ))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			
		  else begin
			score <= score+1;
			black[y/w+2][x/w+1] <= 1'b1;
			black[y/w+1][x/w] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w+1][x/w+2] <= 1'b1;
			
			rmv[y/w+2] = rmv[y/w+2] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 3;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	
	else begin
		  if (( y + 3*w < 480) && ( black[y/w+2][x/w+2] != 1 ) 
		  && ( black[y/w+3][x/w+1] != 1 ))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			
		  else begin
			score <= score+1;
			black[y/w][x/w+1] <= 1'b1;
			black[y/w+1][x/w+2] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w+2][x/w+1] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 2;
			rmv[y/w+2] = rmv[y/w+2] + 1;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	 
  end

 else if(i==3) begin
	if (rot == 0) begin
		  if (( y + 3*w < 480) && ( black[y/w+3][x/w] != 1 ) 
		  && ( black[y/w+3][x/w+1] != 1 ))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			
		  else begin
			score <= score+1;
			black[y/w][x/w] <= 1'b1;
			black[y/w+1][x/w] <= 1'b1;
			black[y/w+2][x/w] <= 1'b1;
			black[y/w+2][x/w+1] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 1;
			rmv[y/w+2] = rmv[y/w+2] + 2;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	 
	else if (rot == 1) begin
		  if (( y + 2*w < 480) && ( black[y/w+2][x/w] != 1 ) 
		  && (black[y/w+2][x/w+1] != 1) && (black[y/w+2][x/w+2] != 1))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			
		  else begin
			score <= score+1;
			black[y/w][x/w+2] <= 1'b1;
			black[y/w+1][x/w] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w+1][x/w+2] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 3;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	 
	else if (rot == 2) begin
		  if (( y + 3*w < 480) && ( black[y/w+1][x/w] != 1 ) 
		  && ( black[y/w+3][x/w+1] != 1 ))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			
		  else begin
			score <= score+1;
			black[y/w][x/w+1] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w][x/w] <= 1'b1;
			black[y/w+2][x/w+1] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 2;
			rmv[y/w+1] = rmv[y/w+1] + 1;
			rmv[y/w+2] = rmv[y/w+2] + 1;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	 
	else begin
		  if (( y + 3*w < 480) && ( black[y/w+3][x/w] != 1 ) 
		  && (black[y/w+2][x/w+1] != 1) && (black[y/w+2][x/w+2] != 1))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
			
		  else begin
			score <= score+1;
			black[y/w+2][x/w] <= 1'b1;
			black[y/w+1][x/w] <= 1'b1;
			black[y/w+1][x/w+1] <= 1'b1;
			black[y/w+1][x/w+2] <= 1'b1;
			
			rmv[y/w+2] = rmv[y/w+2] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 3;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			//rot <= 0;
			end
	 end
	 
  end

 else begin
	if (rot == 0) begin
		  if (( y + 4*w < 480) && ( black[y/w+4][x/w] != 1))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
		  else begin
			score <= score+1;
			black[y/w][x/w] <= 1'b1;
			black[y/w+1][x/w] <= 1'b1;
			black[y/w+2][x/w] <= 1'b1;
			black[y/w+3][x/w] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 1;
			rmv[y/w+1] = rmv[y/w+1] + 1;
			rmv[y/w+2] = rmv[y/w+2] + 1;
			rmv[y/w+3] = rmv[y/w+3] + 1;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			end
	 end
	 
	 else begin
		  if (( y + w < 480) && ( black[y/w+1][x/w] != 1)
		  && ( black[y/w+1][x/w+1] != 1) && ( black[y/w+1][x/w+2] != 1)
		  && ( black[y/w+1][x/w+3] != 1))
			  if (score < 30)
					 y <= y + w/2;
				 else
					 y <= y + w;
		  else begin
			score <= score+1;
			black[y/w][x/w] <= 1'b1;
			black[y/w][x/w+1] <= 1'b1;
			black[y/w][x/w+2] <= 1'b1;
			black[y/w][x/w+3] <= 1'b1;
			
			rmv[y/w] = rmv[y/w] + 4;
			
			y <= 0;
			falled <= 1;
			i <= rand_num % 5;
			end
	 end
	end
  end
end

always @(posedge key)
begin  
//////////////////////// move left or right ////////////////////////

 if(key_ctrl == 8'h6b)  begin //left    
     if ((i==0) && (x>0)) begin
			if ((black[y/w][x/w-1] != 1)
			 && (black[y/w+1][x/w-1] !=1))
			 x <= x - w;
     end
     
     else if(i==1) begin
			if ((rot==0) ) begin
				if ((black[y/w][x/w-1] != 1)
				 && (black[y/w+1][x/w] != 1)
				 && (x>0))
				 x <= x - w; 
			end
				
			else begin
				if (x>0) begin
				if ((black[y/w][x/w+1] != 1)
				 && (black[y/w+1][x/w] != 1)
				 && (black[y/w+2][x/w] != 1))
				 x <= x - w;
				 end
			end
     end
     
     else if(i==2) begin
			if (rot==0) begin
				if ( (black[y/w][x/w] != 1)
				 && (black[y/w+1][x/w-1] != 1)
				 && (x>0))
				 x <= x - w;  
			end
			
			else if (rot==1) begin
				if ( (black[y/w][x/w] != 1)
				 && (black[y/w+1][x/w-1] != 1)
				 && (black[y/w+2][x/w] != 1)
				 && (x>0))
				 x <= x - w; 
			end
			
			else if (rot==2) begin
				if ( (black[y/w+2][x/w] != 1)
				 && (black[y/w+1][x/w-1] != 1)
				 && (x>0))
				 x <= x - w; 
			end
			
			else if(rot==3) begin
				 if ( (black[y/w][x/w] != 1)
				 && (black[y/w+1][x/w] != 1)
				 && (black[y/w+2][x/w] != 1)
				  && (x>0))
				 x <= x - w; 
			end
			
     end
     
     else if((i==3) && (x>0)) begin
			if (rot == 0) begin
				if ( (black[y/w][x/w-1] != 1)
				 && (black[y/w+1][x/w-1] != 1)
				 && (black[y/w+2][x/w-1] != 1))
				 x <= x - w;  
			end
			
			else if (rot == 1) begin
				if ( (black[y/w][x/w+2] != 1)
				 && (black[y/w+1][x/w-1] != 1))
				 x <= x - w; 
			end
			
			else if (rot == 2) begin
				if ( (black[y/w][x/w-1] != 1)
				 && (black[y/w+1][x/w] != 1)
				 && (black[y/w+2][x/w] != 1))
				 x <= x - w;  
			end
			
			else begin
				if ((black[y/w+1][x/w-1] != 1)
				 && (black[y/w+2][x/w-1] != 1))
				 x <= x - w; 
			end
			
     end
      
     else if((i==4) && (x>0)) begin
			if (rot == 0) begin
				if ( (black[y/w][x/w-1] != 1)
				 && (black[y/w+1][x/w-1] != 1)
				 && (black[y/w+2][x/w-1] != 1)
				 && (black[y/w+3][x/w-1] != 1))
				 x <= x - w;  
			end
			
			else begin
				if (black[y/w+1][x/w-1] != 1)
				x <= x - w;
			end
     end
     
  
  end
 
  else if (key_ctrl == 8'h74) begin  //right	 
    if (i==0) begin
     if (x< 320-2*w) begin
      if ((black[y/w][x/w+2] != 1)
       && (black[y/w+1][x/w+2] !=1))
       x <= x + w;
     end
    end
     
    else if (i==1) begin
		if (x< 320-3*w)  begin
		  if (rot==0) begin  
			if ( (black[y/w][x/w+2] != 1)
			 && (black[y/w+1][x/w+3] != 1))
			 x <= x + w;  
		  end
		 
		  
		  else begin	  
			if ( (black[y/w][x/w+3] != 1)
			 && (black[y/w+1][x/w+3] != 1)
			 && (black[y/w+2][x/w+1] != 1) )
			 x <= x + w;  
		  end
		end
    end
     
    else if(i==2) begin
		  if (rot==0) begin
				if ( (black[y/w][x/w+2] != 1)
				 && (black[y/w+1][x/w+3] != 1)
				 && (x < 320-3*w))
				 x <= x + w;  
		  end
		  
		  else if (rot==1) begin
				if ( (black[y/w][x/w+2] != 1)
				 && (black[y/w+1][x/w+2] != 1)
				 && (black[y/w+2][x/w+2] != 1)
				  && (x < 320-2*w))
				 x <= x + w;  
		  end
		  
		  else if (rot==2) begin
				if ( (black[y/w+2][x/w+2] != 1)
				 && (black[y/w+1][x/w+3] != 1)
				  && (x < 320-3*w))
				 x <= x + w;  
		  end
		  
		  else if (rot==3) begin
				if ( (black[y/w][x/w+2] != 1)
				 && (black[y/w+1][x/w+3] != 1)
				 && (black[y/w+2][x/w+2] != 1)
				 && (x < 320-3*w))
				 x <= x + w;  
		  end
		  
    end
     
    else if(i==3) begin
			if ((rot==0) && (x < 320-2*w)) begin
				if ( (black[y/w][x/w+1] != 1)
				 && (black[y/w+1][x/w+1] != 1)
				 && (black[y/w+2][x/w+2] != 1))
				 x <= x + w;  
		  end
		  
		  else if ((rot==1) && (x < 320-3*w)) begin
				if ( (black[y/w][x/w+3] != 1)
				 && (black[y/w+1][x/w+3] != 1))
				 x <= x + w;  
		  end
		  
		  else if ((rot==2) && (x < 320-2*w)) begin
				if ( (black[y/w][x/w+2] != 1)
				 && (black[y/w+1][x/w+2] != 1)
				 && (black[y/w+2][x/w+2] != 1))
				 x <= x + w;  
		  end
		  
		  else if ((rot==3) && (x < 320-3*w)) begin
				if ( (black[y/w][x/w+3] != 1)
				 && (black[y/w+1][x/w+1] != 1))
				 x <= x + w;  
		  end
  end
      
    else begin
		if (rot==0) begin
				if ( (black[y/w][x/w+1] != 1)
				 && (black[y/w+1][x/w+1] != 1)
				 && (black[y/w+2][x/w+1] != 1)
				 && (black[y/w+3][x/w+1] != 1)
				  && (x<320-w))
				 x <= x + w; 
		end
	
		else begin
				if ((black[y/w][x/w+4] != 1)&& (x<320-4*w))
				x <= x + w;
		end
		
     end
    
  end 

	/// rotate using key_up 8'h75
  else if (key_ctrl == 8'h75) begin
	 if (i==1) begin
		if (rot==0) begin
			if ((y+2*w<480) && (black[y/w][x/w+2]!=1)
				&& (black[y/w+2][x/w+1]!=1))
				rot <= 1;
		end
		
		else begin
			if ((black[y/w][x/w]!=1) && (black[y/w][x/w+1]!=1))
				rot <= 0;
		end
	 end
	 
	 else if (i==2) begin
		if (rot==0) begin
			if ((y+2*w<480) && (black[y/w+2][x/w+1]!=1))
				rot <= 1;
		end
		
		else if (rot==1) begin
			if ((x+2*w<320) && (black[y/w+1][x/w+2]!=1))
				rot <= 2;
		end
		
		else if (rot==2) begin
			if ((y>0) && (black[y/w][x/w+1]!=1))
				rot <= 3;
		end
		
		else begin
			if ((x>0) && (black[y/w+1][x/w]!=1))
				rot <= 0;
		end
	 end
	 
	 else if (i==3) begin
		if (rot==0) begin
			if ((black[y/w][x/w+2]!=1) && (black[y/w+1][x/w+1]!=1)
				&& (black[y/w+1][x/w+2]!=1) && (x+2*w<320))
				rot <= 1;
		end
		
		else if (rot==1) begin
			if ((black[y/w][x/w]!=1) && (black[y/w][x/w+1]!=1)
				&& (black[y/w+2][x/w+1]!=1) && y>0)
				rot <= 2;
		end
		
		else if (rot==2) begin
			if ((black[y/w+1][x/w]!=1) && (black[y/w+1][x/w+2]!=1)
				&& (black[y/w+2][x/w]!=1) && (x+w<320))
				rot <= 3;
		end
		
		else begin
			if ((black[y/w][x/w]!=1) && (black[y/w+2][x/w]!=1)
				&& (black[y/w+2][x/w+1]!=1) && (y>0))
				rot <= 0;
		end
	 end
  
	else if (i==4) begin
		if (rot==0) begin
			if ((black[y/w+1][x/w+1]!=1)&& (black[y/w+1][x/w+2]!=1)
				&& (black[y/w+1][x/w+3]!=1) && (x+4*w<320))
				rot <= 1;
		end
		
		else begin
			if ((black[y/w][x/w]!=1) && (black[y/w+2][x/w]!=1)
				&& (black[y/w+3][x/w]!=1) && (y-w>0))
				rot <= 0;
		end
	 end
  end
  
/////////////////////////////////////////////////////////////////////  
 
end
///////////////////////////////////////    debouncer   /////////////////

reg tmp;
reg key;
always @ ( posedge(VGA_CLK_n))
begin

  key <= (~key_p) & tmp;  
  tmp <= key_p;

end


//////latch valid data at falling edge;
//always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;

assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
