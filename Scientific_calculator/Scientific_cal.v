module Scientific_calculator(C,A,B,ms,op,clk,reset,equal);
output [6:0] C;
input [2:0] A;
input [2:0] B;
input ms,clk,reset,equal;
input [2:0] op;
reg [6:0] C,X;
reg [3:0] state, next_state;
reg mop;
reg done;
parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0100, S4 = 4'b0101, S5 = 4'b0110,
S6 = 4'b0111, S7 = 4'b1000, S8 = 4'b1001, S9 = 4'b1010, S10 = 4'b1011, S11 = 4'b1100,
S12 = 4'b1101;
parameter ADD = 3'b000, SUB = 3'b001, MUL = 3'b010, DIV = 3'b011, C1 = 3'b100, C2 = 3'b101,
C3 = 3'b110, C4 = 3'b111;

always @(posedge clk)
begin
    if (reset == 1)
      begin
       state <= S0;
      end
    else begin
       state <= next_state;
      end
 end
    always @(state)
    begin
        case (state)
        S0 : begin
            //A = 0;
            C = 0;
            //equal <= 0;
            done <= 0;
            mop <= 0;
            next_state <= S1;
            end
        S1 : begin
            if (reset == 0 && equal)
            begin
            //C <= 1;
            if (ms == 0)
              begin
              //C <= 1;
              next_state <= S2;
              end
            else
              next_state <= S3;
            end
            else if (reset)
              next_state <= S0;
              else
              next_state <= S1;
            end
        S2 : begin
              //C <= 1;
              if (reset == 0 && equal)
              begin
                // C <= 1;
                case (op)
                ADD : next_state <= S4;
                SUB : next_state <= S5;
                MUL : next_state <= S6;
                DIV : next_state <= S7;
                default :begin
              if (mop == 0)
                 next_state <= S2;
              else
                 next_state <= S12;
              end
              endcase
              end
              else if (reset)
              next_state <= S0;
              else
              next_state <= S2;
              end
        S3 : begin
              if (reset == 0 && equal)
              begin
                case (op)
                C1 : next_state <= S8;
                C2 : next_state <= S9;
                C3 : next_state <= S10;
                C4 : next_state <= S11;
                default :begin
                if (mop == 0)
                next_state <= S2;
                else
                next_state <= S12;
                end
                endcase
                end
              else if (reset)
                next_state <= S0;
              end
        S4 : begin
              if (reset == 0 && equal)
              begin
                if (mop == 1)
                begin
                //equal <= 0;
                C <= X + B;
                //done <= 0;
                next_state <= S12;
                end
              else
                begin
                //equal <= 0;
                C <= A + B;
                //done <= 0;
                next_state <= S12;
                end
               end
              else if (reset)
                next_state <= S0;
              end
        S5 : begin
              if (reset == 0 && equal)
              begin
                if (mop == 1)
                begin
                //equal <= 0;
                C <= X - B;
                //done <= 0;
                next_state <= S12;
              end
              else
                begin
                //equal <= 0;
                C <= A - B;
                //done <= 0;
                next_state <= S12;
                end
              end
              else if (reset)
                next_state <= S0;
              end
        S6 : begin
            if (reset == 0 && equal)
              begin
              if (mop == 1)
              begin
                // equal <= 0;
               C <= X * B;
               //done <= 1;
               next_state <= S12;
              end
              else
              begin
                //equal <= 0;
                C <= A * B;
                //done <= 1;
                next_state <= S12;
               end
              end
            else if (reset)
              next_state <= S0;
            end
        S7 : begin
            if (reset == 0 && equal)
            begin
              if (mop == 1)
              begin
                //equal <= 0;
                C <= X / B;
                //done <= 1;
                next_state <= S12;
            end
            else
            begin
              //equal <= 0;
              C <= A / B;
              //done <= 1;
              next_state <= S12;
              end
            end
            else if (reset)
               next_state <= S0;
            end
        S8 : begin
            if (reset == 0 && equal)
            begin
              if (mop == 1)
              begin
              //equal <= 0;
              C <= X ** (2);
              //done <= 1;
              next_state <= S12;
              end
            else
              begin
              // equal <= 0;
              C <= A ** (2);
              //done <= 1;
              next_state <= S12;
              end
            end
            else if (reset)
              next_state <= S0;
            end
        S9 : begin
              if (reset == 0 && equal)
                begin
                if (mop == 1)
                begin
                //equal <= 0;
                C <= X ** 3;
                //done <= 1;
                next_state <= S12;
                end
              else
                begin
                //equal <= 0;
                C <= A ** 3;
                //done <= 1;
                next_state <= S12;
                end
               end
              else if (reset )
                 next_state <= S0;
              end
        S10 : begin
              if (reset == 0 && equal)
                begin
                if (mop == 1)
                begin
                //equal <= 0;
                C <= fact(X) ;
                //done <= 1;
                next_state <= S12;
                end
                else
                begin
                // equal <= 0;
                C <= fact(A);
                //done <= 1;
                next_state <= S12;
                end
              end
              else if (reset)
                 next_state <= S0;
              end
        S11 : begin
            if (reset == 0 && equal)
              begin
              if (mop == 1)
              begin
              //equal <= 0;
              C <= X + B;
              //done <= 1;
              next_state <= S12;
              end
            else
              begin
              //equal <= 0;
              C <= A + B;
              //done <= 1;
              next_state <= S12;
              end
            end
            else if (reset)
              next_state <= S0;
            end
        S12 : begin
              if (reset == 0 && equal)
                begin
                done <= 1;
                mop <= 1;
                X <= C;
                if (ms == 0)
                begin
                case (op)
                ADD : next_state <= S4;
                SUB : next_state <= S5;
                MUL : next_state <= S6;
                DIV : next_state <= S7;
                default :begin
                if (mop == 0)
                next_state <= S2;
                else
                next_state <= S12;
                end
               endcase
              end
              else if (ms == 1)
                begin
                case (op)
                C1 : next_state <= S8;
                C2 : next_state <= S9;
                C3 : next_state <= S10;
                C4 : next_state <= S11;
                default : begin
                if (mop == 0)
                next_state <= S2;
               else
                 next_state <= S12;
                 end
                endcase
               end
              end
               else if (reset)
                next_state <= S0;
              end
        endcase
 end
    function [7:0] fact;
    input [2:0]a;  reg [7:0] temp;
    integer i;
    begin
    if (a == 0)
    fact=1;
    else
      begin
      temp =1;
      for (i=1;i<=a;i=i+1)
        begin
        temp = temp*i;
        end
       fact = temp;
       end
     end
    endfunction
endmodule
