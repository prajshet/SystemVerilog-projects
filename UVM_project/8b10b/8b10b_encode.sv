`timescale 1ns / 1ps

module a8b10b_encode(e2t_intf.b8_intf m);

logic din_dirty_d,din_dirty;
logic [8:0] din_d,din;
logic [9:0] dout_d;
logic [7:0] b6_encode;
logic [5:0] b4_encode;
logic [31:0] crc_out,crc_out_d,crc_in;
logic [1:0] crc_count,crc_count_d;
logic [10:0] count,count_d;
logic disp_in_d,disp_out,crc_en,disp_in;
logic [2:0] PS,NS;
logic pushout_d,startout_d;

always_comb begin

    case(PS)
        3'b000: begin //Reset
                disp_in_d = 0;
                disp_out = disp_in_d;
                dout_d = 0;
                din_dirty_d = 0;
                startout_d = 0;
                count_d = 0;
                crc_count_d = 0;
                pushout_d = 0;
                crc_out_d = 32'hffffffff;
                NS = 3'b001;

                if(m.pushin & m.startin & m.datain == 9'h13C)begin
                    din_d = m.datain;
                    NS = 3'b001;
                end else begin
                    din_d = 0;
                    NS = 3'b000;
                end

            end

        3'b001: begin //encode data and generate crc

            casex ({din[8], din[4:0]})
                6'bx_00000: b6_encode = 8'b111001_11;
                6'bx_00001: b6_encode = 8'b101110_11;
                6'bx_00010: b6_encode = 8'b101101_11;
                6'bx_00011: b6_encode = 8'b100011_00;
                6'bx_00100: b6_encode = 8'b101011_11;
                6'bx_00101: b6_encode = 8'b100101_00;
                6'bx_00110: b6_encode = 8'b100110_00;
                6'bx_00111: b6_encode = 8'b000111_10;
                6'bx_01000: b6_encode = 8'b100111_11;
                6'bx_01001: b6_encode = 8'b101001_00;
                6'bx_01010: b6_encode = 8'b101010_00;
                6'bx_01011: b6_encode = 8'b001011_00;
                6'bx_01100: b6_encode = 8'b101100_00;
                6'bx_01101: b6_encode = 8'b001101_00;
                6'bx_01110: b6_encode = 8'b001110_00;
                6'bx_01111: b6_encode = 8'b111010_11;
                6'bx_10000: b6_encode = 8'b110110_11;
                6'bx_10001: b6_encode = 8'b110001_00;
                6'bx_10010: b6_encode = 8'b110010_00;
                6'bx_10011: b6_encode = 8'b010011_00;
                6'bx_10100: b6_encode = 8'b110100_00;
                6'bx_10101: b6_encode = 8'b010101_00;
                6'bx_10110: b6_encode = 8'b010110_00;
                6'bx_10111: b6_encode = 8'b010111_11;
                6'bx_11000: b6_encode = 8'b110011_11;
                6'bx_11001: b6_encode = 8'b011001_00;
                6'bx_11010: b6_encode = 8'b011010_00;
                6'bx_11011: b6_encode = 8'b011011_11;
                6'b0_11100: b6_encode = 8'b011100_00;
                6'b1_11100: b6_encode = 8'b111100_11;
                6'bx_11101: b6_encode = 8'b011101_11;
                6'bx_11110: b6_encode = 8'b011110_11;
                6'bx_11111: b6_encode = 8'b110101_11;
            endcase

      casex ({din[8], din[7:5]}) 
         4'bx_000: b4_encode = 6'b1101_11;
         4'b0_001: b4_encode = 6'b1001_00;
         4'b1_001: b4_encode = 6'b0110_10;
         4'b0_010: b4_encode = 6'b1010_00;
         4'b1_010: b4_encode = 6'b0101_10;
         4'bx_011: b4_encode = 6'b0011_10;
         4'bx_100: b4_encode = 6'b1011_11;
         4'b0_101: b4_encode = 6'b0101_00;
         4'b1_101: b4_encode = 6'b1010_10;
         4'b0_110: b4_encode = 6'b0110_00;
         4'b1_110: b4_encode = 6'b1001_10;
         4'b0_111: 	begin
					if ((din[4:0]==17||din[4:0]==18||din[4:0]==20)&&(!disp_out)) begin
						b4_encode = 6'b1110_01;
					end else if ((din[4:0]==11||din[4:0]==13||din[4:0]==14)&&(disp_out)) begin
						b4_encode = 6'b0001_01;
					end else begin
						b4_encode = 6'b0111_11;
					end
					end
         4'b1_111: b4_encode = 6'b1110_11;
      endcase
     

      crc_count_d = 0;

      if(din[8])begin
          crc_out_d = crc_out;
      end else begin
          crc_out_d = crc(din[7:0],crc_in);
      end

      if(!m.pushin)begin
          din_dirty_d = 1;
      end else begin
          din_dirty_d = 0;
      end


      disp_out = disp_in;

      if(disp_out & din == 9'h1BC) begin
		   dout_d[5:0] = 6'b101000; //23.7 disp=1
		end else if (disp_out==0 & din == 9'h1BC)begin
		   dout_d = 6'b010111; //23.7 disp = -1
		end else if(disp_out & b6_encode[1])begin
          dout_d[5:0] = ~b6_encode[7:2];
      end else begin
          dout_d[5:0] = b6_encode[7:2];
      end

      if(din == 9'h1BC)begin
          disp_out = disp_in;
      end else begin
          disp_out = disp_out ^ b6_encode[0];
      end


       if(disp_out & din == 9'h1BC) begin
          dout_d[9:6] = 4'b1110;
      end else if (!disp_out & din == 9'h1BC)begin
          dout_d[9:6] = 4'b0001;
      end else if(disp_out == 1 & b4_encode[1])begin
          dout_d[9:6] = ~b4_encode[5:2];
      end else begin
          dout_d[9:6] = b4_encode[5:2];
      end

      if(din == 9'h1BC)begin
          disp_out = disp_in;
      end else begin
          disp_out = disp_out ^ b4_encode[0];
      end
      disp_in_d = disp_out;

      if(count == 0)begin
          pushout_d = 1;
          startout_d = 1;
      end else begin
          pushout_d = din_dirty?1'b0:1'b1;
          startout_d = 0;
      end
         
      if(din == 9'h1BC)begin
          crc_en = 1;
      end else begin
          crc_en = 0;
      end

      if(m.pushin)begin
          din_d = m.datain;
          count_d = count+1;
      end else begin
          din_d = crc_en?crc_out[31:24]:din;
          count_d = 0;
          crc_count_d = 2'b00;
      end

      if(din == 9'h1BC)begin
          NS = 3'b010;
      end else begin
          NS = 3'b001;
      end


  end

3'b010: begin //encode crc
        count_d = 0;
        crc_out_d = crc_out;
        din_dirty_d = 0;
        
        if(crc_count == 3)begin
            crc_count_d = 0;
            NS = 3'b011;
        end else begin
            crc_count_d = crc_count+1;
            NS = 3'b010;
        end

    case(crc_count)
        //2'b00:din_d[7:0] = crc_out[31:24];
        2'b00:din_d[7:0] = crc_out[23:16];
        2'b01:din_d[7:0] = crc_out[15:8];
        2'b10:din_d[7:0] = crc_out[7:0];
    endcase


    casex ({din[8], din[4:0]}) 
         6'bx_00000: b6_encode = 8'b111001_11;
         6'bx_00001: b6_encode = 8'b101110_11;
         6'bx_00010: b6_encode = 8'b101101_11;
         6'bx_00011: b6_encode = 8'b100011_00;
         6'bx_00100: b6_encode = 8'b101011_11;
         6'bx_00101: b6_encode = 8'b100101_00;
         6'bx_00110: b6_encode = 8'b100110_00;
         6'bx_00111: b6_encode = 8'b000111_10;
         6'bx_01000: b6_encode = 8'b100111_11;
         6'bx_01001: b6_encode = 8'b101001_00;
         6'bx_01010: b6_encode = 8'b101010_00;
         6'bx_01011: b6_encode = 8'b001011_00;
         6'bx_01100: b6_encode = 8'b101100_00;
         6'bx_01101: b6_encode = 8'b001101_00;
         6'bx_01110: b6_encode = 8'b001110_00;
         6'bx_01111: b6_encode = 8'b111010_11;
         6'bx_10000: b6_encode = 8'b110110_11;
         6'bx_10001: b6_encode = 8'b110001_00;
         6'bx_10010: b6_encode = 8'b110010_00;
         6'bx_10011: b6_encode = 8'b010011_00;
         6'bx_10100: b6_encode = 8'b110100_00;
         6'bx_10101: b6_encode = 8'b010101_00;
         6'bx_10110: b6_encode = 8'b010110_00;
         6'bx_10111: b6_encode = 8'b010111_11;
         6'bx_11000: b6_encode = 8'b110011_11;
         6'bx_11001: b6_encode = 8'b011001_00;
         6'bx_11010: b6_encode = 8'b011010_00;
         6'bx_11011: b6_encode = 8'b011011_11;
         6'b0_11100: b6_encode = 8'b011100_00;
         6'b1_11100: b6_encode = 8'b111100_11;
         6'bx_11101: b6_encode = 8'b011101_11;
         6'bx_11110: b6_encode = 8'b011110_11;
         6'bx_11111: b6_encode = 8'b110101_11;
      endcase

      casex ({din[8], din[7:5]}) 
         4'bx_000: b4_encode = 6'b1101_11;
         4'b0_001: b4_encode = 6'b1001_00;
         4'b1_001: b4_encode = 6'b0110_10;
         4'b0_010: b4_encode = 6'b1010_00;
         4'b1_010: b4_encode = 6'b0101_10;
         4'bx_011: b4_encode = 6'b0011_10;
         4'bx_100: b4_encode = 6'b1011_11;
         4'b0_101: b4_encode = 6'b0101_00;
         4'b1_101: b4_encode = 6'b1010_10;
         4'b0_110: b4_encode = 6'b0110_00;
         4'b1_110: b4_encode = 6'b1001_10;
         4'b0_111: 	begin
					if ((din[4:0]==17||din[4:0]==18||din[4:0]==20)&&(!disp_out)) begin
						b4_encode = 6'b1110_01;
					end else if ((din[4:0]==11||din[4:0]==13||din[4:0]==14)&&(disp_out)) begin
						b4_encode = 6'b0001_01;
					end else begin
						b4_encode = 6'b0111_11;
					end
					end
         4'b1_111: b4_encode = 6'b1110_11;
      endcase
   

      disp_out = disp_in;
      
      if(disp_out & b6_encode[1])begin
          dout_d[5:0] = ~b6_encode[7:2];
      end else begin
          dout_d[5:0] = b6_encode[7:2];
      end

      pushout_d = 1;
      startout_d = 0;
      disp_out = disp_out ^ b6_encode[0];


      if(disp_out & b4_encode[1])begin
          dout_d[9:6] = ~b4_encode[5:2];
      end else begin
          dout_d[9:6] = b4_encode[5:2];
      end

      disp_out = disp_out ^ b4_encode[0];
      disp_in_d = disp_out;

  end

  3'b011: begin //send 28.5
            din_d = 0;
            if(disp_out)begin
                dout_d = 10'b1010000011;
            end else begin
                dout_d = 10'b0101111100;
            end
	    disp_in_d = disp_out;

            pushout_d = 1;
            startout_d = 0;

            NS = 3'b000;
        end
    endcase

end
          

always @(posedge m.clk or posedge m.reset) begin
    if(m.reset)begin
        din <= 0;
        m.dataout <= 0;
        m.pushout <= 0;
        m.startout <= 0;
        crc_count <= 0;
        crc_out <= 32'hFFFFFFFF;
        count <= 0;
        PS <= 0;
        crc_in <= 32'hffffffff;
        din_dirty <= 0;
	disp_in <= 0;
    end else begin
        din <= #1 din_d;
        m.dataout <= #1 dout_d;
        m.pushout <= #1 pushout_d;
        crc_count <= #1 crc_count_d;
        crc_out <= #1 crc_out_d;
        count <= #1 count_d;
        PS <= NS;
        crc_in <= #1 crc_out_d;
        din_dirty <= #1 din_dirty_d;
	m.startout <= #1 startout_d;
	disp_in <= #1 disp_in_d;
    end
end


function automatic [31:0] crc (input [7:0]din,input [31:0] crc_in);

    begin
	crc[0] = (crc_in[2] ^ crc_in[8] ^ din[2]);
	crc[1] = (crc_in[0] ^ crc_in[3] ^ crc_in[9] ^ din[0] ^ din[3]);
	crc[2] = (crc_in[0] ^ crc_in[1] ^ crc_in[4] ^ crc_in[10] ^ din[0] ^ din[1] ^ din[4]);
	crc[3] = (crc_in[1] ^ crc_in[2] ^ crc_in[5] ^ crc_in[11] ^ din[1] ^ din[2] ^ din[5]);
	crc[4] = (crc_in[0] ^ crc_in[2] ^ crc_in[3] ^ crc_in[6] ^ crc_in[12] ^ din[0] ^ din[2] ^ din[3] ^ din[6]);
	crc[5] = (crc_in[1] ^ crc_in[3] ^ crc_in[4] ^ crc_in[7] ^ crc_in[13] ^ din[1] ^ din[3] ^ din[4] ^ din[7]);
	crc[6] = (crc_in[4] ^ crc_in[5] ^ crc_in[14] ^ din[4] ^ din[5]);
	crc[7] = (crc_in[0] ^ crc_in[5] ^ crc_in[6] ^ crc_in[15] ^ din[0] ^ din[5] ^ din[6]);
	crc[8] = (crc_in[1] ^ crc_in[6] ^ crc_in[7] ^ crc_in[16] ^ din[1] ^ din[6] ^ din[7]);
	crc[9] = (crc_in[7] ^ crc_in[17] ^ din[7]);
	crc[10] = (crc_in[2] ^ crc_in[18] ^ din[2]);
	crc[11] = (crc_in[3] ^ crc_in[19] ^ din[3]);
	crc[12] = (crc_in[0] ^ crc_in[4] ^ crc_in[20] ^ din[0] ^ din[4]);
	crc[13] = (crc_in[0] ^ crc_in[1] ^ crc_in[5] ^ crc_in[21] ^ din[0] ^ din[1] ^ din[5]);
	crc[14] = (crc_in[1] ^ crc_in[2] ^ crc_in[6] ^ crc_in[22] ^ din[1] ^ din[2] ^ din[6]);
	crc[15] = (crc_in[2] ^ crc_in[3] ^ crc_in[7] ^ crc_in[23] ^ din[2] ^ din[3] ^ din[7]);
	crc[16] = (crc_in[0] ^ crc_in[2] ^ crc_in[3] ^ crc_in[4] ^ crc_in[24] ^ din[0] ^ din[2] ^ din[3] ^ din[4]);
	crc[17] = (crc_in[0] ^ crc_in[1] ^ crc_in[3] ^ crc_in[4] ^ crc_in[5] ^ crc_in[25] ^ din[0] ^ din[1] ^ din[3] ^ din[4] ^ din[5]);
	crc[18] = (crc_in[0] ^ crc_in[1] ^ crc_in[2] ^ crc_in[4] ^ crc_in[5] ^ crc_in[6] ^ crc_in[26] ^ din[0] ^ din[1] ^ din[2] ^ din[4] ^ din[5] ^ din[6]);
	crc[19] = (crc_in[1] ^ crc_in[2] ^ crc_in[3] ^ crc_in[5] ^ crc_in[6] ^ crc_in[7] ^ crc_in[27] ^ din[1] ^ din[2] ^ din[3] ^ din[5] ^ din[6] ^ din[7]);
	crc[20] = (crc_in[3] ^ crc_in[4] ^ crc_in[6] ^ crc_in[7] ^ crc_in[28] ^ din[3] ^ din[4] ^ din[6] ^ din[7]);
	crc[21] = (crc_in[2] ^ crc_in[4] ^ crc_in[5] ^ crc_in[7] ^ crc_in[29] ^ din[2] ^ din[4] ^ din[5] ^ din[7]);
	crc[22] = (crc_in[2] ^ crc_in[3] ^ crc_in[5] ^ crc_in[6] ^ crc_in[30] ^ din[2] ^ din[3] ^ din[5] ^ din[6]);
	crc[23] = (crc_in[3] ^ crc_in[4] ^ crc_in[6] ^ crc_in[7] ^ crc_in[31] ^ din[3] ^ din[4] ^ din[6] ^ din[7]);
	crc[24] = (crc_in[0] ^ crc_in[2] ^ crc_in[4] ^ crc_in[5] ^ crc_in[7] ^ din[0] ^ din[2] ^ din[4] ^ din[5] ^ din[7]);
	crc[25] = (crc_in[0] ^ crc_in[1] ^ crc_in[2] ^ crc_in[3] ^ crc_in[5] ^ crc_in[6] ^ din[0] ^ din[1] ^ din[2] ^ din[3] ^ din[5] ^ din[6]);
	crc[26] = (crc_in[0] ^ crc_in[1] ^ crc_in[2] ^ crc_in[3] ^ crc_in[4] ^ crc_in[6] ^ crc_in[7] ^ din[0] ^ din[1] ^ din[2] ^ din[3] ^ din[4] ^ din[6] ^ din[7]);
	crc[27] = (crc_in[1] ^ crc_in[3] ^ crc_in[4] ^ crc_in[5] ^ crc_in[7] ^ din[1] ^ din[3] ^ din[4] ^ din[5] ^ din[7]);
	crc[28] = (crc_in[0] ^ crc_in[4] ^ crc_in[5] ^ crc_in[6] ^ din[0] ^ din[4] ^ din[5] ^ din[6]);
	crc[29] = (crc_in[0] ^ crc_in[1] ^ crc_in[5] ^ crc_in[6] ^ crc_in[7] ^ din[0] ^ din[1] ^ din[5] ^ din[6] ^ din[7]);
	crc[30] = (crc_in[0] ^ crc_in[1] ^ crc_in[6] ^ crc_in[7] ^ din[0] ^ din[1] ^ din[6] ^ din[7]);
	crc[31] = (crc_in[1] ^ crc_in[7] ^ din[1] ^ din[7]);

    return crc;
end
endfunction


endmodule



     













