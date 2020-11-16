module Scientific_calculator_tb();
wire [6 : 0] C;
reg [2:0] A, B;
reg clk,reset,ms,k,equal;
reg [2:0] op;
Scientific_calculator SC (C,A,B,ms,op,clk,reset,equal);
initial
      begin
      #5;
      equal = 1;
      clk = 0;
      reset =1;
      #10
      reset=0;
      ms = 1'b0;
      #10;
      A = 3'b011;
      B = 3'b001;
      op = 3'b000;
      #20;
      B = 3'b010;
      op = 3'b001;
      #20;
      ms = 1'b1;
      op = 3'b100;
      #20;
      op = 3'b110;
      #20;
      $finish;
    end
      always #5 clk = ~clk;
  initial
      begin
      $monitor("A = %d B = %d reset = %b op = %b mop = %b ms = %b C = %d state = %b equal = %b @%t",A,B,reset,op,Scientific_calculator.mop,ms,C,Scientific_calculator.state,Scientific_calculator.equal,$time);
      end
endmodule
