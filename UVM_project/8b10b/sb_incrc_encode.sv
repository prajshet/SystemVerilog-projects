class sb_incrc_encode extends uvm_scoreboard ;
`uvm_component_utils(sb_incrc_encode)

uvm_tlm_analysis_fifo # (reg [31:0]) inp_crc;
uvm_analysis_port #(reg [39:0]) dis_enc_crc;
uvm_analysis_port #(reg [39:0]) idis_enc_crc;

reg [31:0] crc;
reg [39:0] encoded_crc;
reg [39:0] iencoded_crc;
reg dis;
reg idis;
reg [2:0] count;
reg [7:0] enc_byte;
logic [7:0] b6_encode;
logic [5:0] b4_encode;

function new(string name = "sb_incrc_encode", uvm_component parent= null);
	super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
	inp_crc=new("input_crc",this);
	dis_enc_crc=new("encoded_crc",this);	
    idis_enc_crc=new("inverse_encoded_crc",this);	
endfunction : build_phase

task run_phase(uvm_phase phase);
	forever begin
		inp_crc.get(crc);	//gets the next full crc from sb_in2crc
        dis = 0;
        idis = 1;   
        for(count=0;count<4;count=count+1) begin

            case(count)
                2'b00:enc_byte[7:0] = crc[31:24];
                2'b01:enc_byte[7:0] = crc[23:16];
                2'b10:enc_byte[7:0] = crc[15:8];
                2'b11:enc_byte[7:0] = crc[7:0];
            endcase

            casex ({1'b0, enc_byte[4:0]}) 
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

            casex ({1'b0, enc_byte[7:5]}) 
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
							if ((enc_byte[4:0]==17||enc_byte[4:0]==18||enc_byte[4:0]==20)&&(!dis)) begin
								b4_encode = 6'b1110_01;
							end else if ((enc_byte[4:0]==11||enc_byte[4:0]==13||enc_byte[4:0]==14)&&(dis)) begin
								b4_encode = 6'b0001_01;
							end else begin
								b4_encode = 6'b0111_11;
							end
							end
                4'b1_111: b4_encode = 6'b1110_11;
            endcase

            if(dis & b6_encode[1])begin //if disparity started at 0
                case(count)
                2'b00:encoded_crc[35:30] = ~b6_encode[7:2];
                2'b01:encoded_crc[25:20] = ~b6_encode[7:2];
                2'b10:encoded_crc[15:10] = ~b6_encode[7:2];
                2'b11:encoded_crc[5:0] = ~b6_encode[7:2];
                endcase
            end else begin
                case(count)
                2'b00:encoded_crc[35:30] = b6_encode[7:2];
                2'b01:encoded_crc[25:20] = b6_encode[7:2];
                2'b10:encoded_crc[15:10] = b6_encode[7:2];
                2'b11:encoded_crc[5:0] = b6_encode[7:2];
                endcase
            end
            
            if(idis & b6_encode[1])begin    //if disparity started at 1
                case(count)
                2'b00:iencoded_crc[35:30] = ~b6_encode[7:2];
                2'b01:iencoded_crc[25:20] = ~b6_encode[7:2];
                2'b10:iencoded_crc[15:10] = ~b6_encode[7:2];
                2'b11:iencoded_crc[5:0] = ~b6_encode[7:2];
                endcase
            end else begin
                case(count)
                2'b00:iencoded_crc[35:30] = b6_encode[7:2];
                2'b01:iencoded_crc[25:20] = b6_encode[7:2];
                2'b10:iencoded_crc[15:10] = b6_encode[7:2];
                2'b11:iencoded_crc[5:0] = b6_encode[7:2];
                endcase
            end
            
            dis = dis ^ b6_encode[0];
            idis = idis ^ b6_encode[0];

            if(dis & b4_encode[1])begin
                case(count)
                2'b00:encoded_crc[39:36] = ~b4_encode[5:2];
                2'b01:encoded_crc[29:26] = ~b4_encode[5:2];
                2'b10:encoded_crc[19:16] = ~b4_encode[5:2];
                2'b11:encoded_crc[9:6] = ~b4_encode[5:2];
                endcase
            end else begin
                case(count)
                2'b00:encoded_crc[39:36] = b4_encode[5:2];
                2'b01:encoded_crc[29:26] = b4_encode[5:2];
                2'b10:encoded_crc[19:16] = b4_encode[5:2];
                2'b11:encoded_crc[9:6] = b4_encode[5:2];
                endcase
            end
            
            if(idis & b4_encode[1])begin
                case(count)
                2'b00:iencoded_crc[39:36] = ~b4_encode[5:2];
                2'b01:iencoded_crc[29:26] = ~b4_encode[5:2];
                2'b10:iencoded_crc[19:16] = ~b4_encode[5:2];
                2'b11:iencoded_crc[9:6] = ~b4_encode[5:2];
                endcase
            end else begin
                case(count)
                2'b00:iencoded_crc[39:36] = b4_encode[5:2];
                2'b01:iencoded_crc[29:26] = b4_encode[5:2];
                2'b10:iencoded_crc[19:16] = b4_encode[5:2];
                2'b11:iencoded_crc[9:6] = b4_encode[5:2];
                endcase
            end
            
            dis = dis ^ b4_encode[0];
            idis = idis ^ b4_encode[0];
            
        end
        dis_enc_crc.write(encoded_crc);
        idis_enc_crc.write(iencoded_crc);
	end
endtask:run_phase

endclass: sb_incrc_encode
