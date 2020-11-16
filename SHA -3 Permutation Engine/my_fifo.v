module fifo_messege (clk, reset, Al_Dl_101in, D_IDin, S_IDin, M_Addrin, M_Datain, my_write_flag, my_read_flag, 
	Al_Dl_101out, D_IDout, S_IDout, M_Addrout, M_Dataout, my_empty_flag, my_full_flag);
input		clk;
input		reset;
input [7:0]	Al_Dl_101in;
input [7:0]	D_IDin;
input [7:0]	S_IDin;
input [7:0]	M_Addrin;
input [7:0]	M_Datain;
input		my_read_flag;
input		my_write_flag;
output [7:0]	Al_Dl_101out;
output [7:0]	D_IDout;
output [7:0]	S_IDout;
output [7:0]	M_Addrout;
output [7:0]	M_Dataout;
output		my_empty_flag;
output		my_full_flag;

reg [7:0]	Al_Dl_101out;
reg [7:0]	D_IDout;
reg [7:0]	S_IDout;
reg [7:0]	M_Addrout;
reg [7:0]	M_Dataout;
reg 		my_empty_flag;
reg		my_full_flag;

reg [(8-1):0]	Last_inp;
reg [(8-1):0]	First_inp;

reg [8:0]	the_counter;

reg [40:0] the_FIFO[0:(1<<8)];

integer i;
always @(posedge clk or posedge reset) begin
	if (reset == 1) begin
		Al_Dl_101out <= 8'b0;
      		D_IDout <= 8'b0;
      		S_IDout <= 8'b0;
      		M_Addrout <= 8'b0;
		M_Dataout <= 8'b0;
   	end
   	else begin
      		{Al_Dl_101out,D_IDout,S_IDout,M_Addrout,M_Dataout} <= the_FIFO[Last_inp];
  	end
end 
     
always @(posedge clk)
	if (reset == 1'b0) begin
		if (my_write_flag == 1'b1 && my_full_flag == 1'b0) the_FIFO[First_inp] <= {Al_Dl_101in,D_IDin,S_IDin,M_Addrin,M_Datain};
	end


	always @(posedge clk) begin
		if (reset == 1'b1) begin
			First_inp <= 0;
		end else begin
			if (my_write_flag == 1'b1 && my_full_flag == 1'b0) begin
				First_inp <= First_inp + 1;
			end
		end
	end

	always @(posedge clk) begin
		if (reset == 1'b1) begin
			Last_inp <= 0;
		end else begin
			if (my_read_flag == 1'b1 && my_empty_flag == 1'b0) begin             
				Last_inp <= Last_inp + 1;
			end
		end
	end


	always @(posedge clk) begin
		if (reset == 1'b1) begin
			the_counter <= 0;
		end else begin
			case ({my_read_flag, my_write_flag})
				2'b00: the_counter <= the_counter;
				2'b01: 
					if (!my_full_flag) the_counter <= the_counter + 1;
				2'b10: 
					if (!my_empty_flag) the_counter <= the_counter - 1;
				2'b11: the_counter <= the_counter;
			endcase
		end
	end

	always @(the_counter) begin
		if (the_counter == 0) my_empty_flag = 1'b1;
		else my_empty_flag = 1'b0;
	end

	always @(the_counter) begin
		if (the_counter < (1<<8)) my_full_flag = 1'b0;
		else my_full_flag = 1'b1;
	end

endmodule
