//funciton my_encode (input logic [8:0] in_d, input logic disp_in,  input logic [7:0] d10, input logic disp_out ) ;
typedef enum {f_di,
			  cn_b5,
			  db5,db3,
			  out_write}var_state;
class sb_5b extends uvm_scoreboard ;
`uvm_component_utils(sb_5b)

uvm_tlm_analysis_fifo # (in_data) m2sb_eco5;
uvm_analysis_port #(en_data) b5_enco; 

in_data got_8b;
en_data enc;
var_state en_state;
logic [6:0] b5f;
logic [5:0] b3f;
logic [9:0] b10f;
logic dsisp_in,in_st;
function new(string name = "sb_5b", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
	m2sb_eco5=new("got_8",this);
	b5_enco=new("sent_enco",this);
endfunction :build_phase

task run_phase(uvm_phase phase);
	en_state=f_di;
	
	forever begin
		enc=new();
		m2sb_eco5.get(got_8b);	
		//`uvm_info("encod_input",$sformatf("iam start %h",got_8b.si_data),UVM_MEDIUM)	
		//case (en_state)
			if (en_state==f_di) begin // f_di 
				if(got_8b.si_data[8]==1 && got_8b.si_data[4:0]== 5'b11100) begin // 'b11100=28 
						if (got_8b.start_dis && got_8b.si_data[4:0]==28) begin dsisp_in=0; in_st=1;end 
						else begin in_st=0; end 
						 if(got_8b.si_data[4:0]==28)begin
								if(dsisp_in)  b5f=7'b000011_0; else b5f=~7'b000011_0 ; 
								//`uvm_info("start",$sformatf("i am f_di_28.2"),UVM_MEDIUM)
								dsisp_in=b5f[0];
								en_state=db3;
						 end	 
				end else begin 
					en_state=db5; //`uvm_info("tx_to bd5",$sformatf("i chose db5"),UVM_MEDIUM)
				end  //k code higher ordir bit are similar to data 
			end
			
			if (en_state==db5) begin // 5b6b
			`uvm_info("form db5",$sformatf("i am movig to db5 encodes=%b %d disp=%b",got_8b.si_data[4:0],got_8b.si_data[4:0],dsisp_in),UVM_MEDIUM) 
				case(got_8b.si_data[4:0])
				0: begin if(dsisp_in) b5f=7'b000110_0; else b5f=~7'b000110_0; end
				1: begin if(dsisp_in) b5f=7'b010001_0; else b5f=~7'b010001_0; end
				2: begin if(dsisp_in) b5f=7'b010010_0; else b5f=~7'b010010_0; end
				3: begin if(dsisp_in) b5f=7'b100011_1; else b5f=7'b100011_0; end
				4: begin if(dsisp_in) b5f=7'b010100_0; else b5f=~7'b010100_0; end
				5: begin if(dsisp_in) b5f=7'b100101_1; else b5f=7'b100101_0; end
				6: begin if(dsisp_in) b5f=7'b100110_1; else b5f=7'b100110_0; end	
				7: begin if(dsisp_in) b5f=7'b111000_1; else b5f=~7'b111000_1; end //intresting 
				8: begin if(dsisp_in) b5f=7'b011000_0; else b5f=~7'b011000_0; end
				9: begin if(dsisp_in) b5f=7'b101001_1; else b5f=7'b101001_0; end
				10: begin if(dsisp_in) b5f=7'b101010_1; else b5f=7'b101010_0; end
				11: begin if(dsisp_in) b5f=7'b001011_1; else b5f=7'b001011_0; end
				12: begin if(dsisp_in) b5f=7'b101100_1; else b5f=7'b101100_0; end
				13: begin if(dsisp_in) b5f=7'b001101_1; else b5f=7'b001101_0; end
				14: begin if(dsisp_in) b5f=7'b001110_1; else b5f=7'b001110_0; end
				15: begin if(dsisp_in) b5f=7'b000101_0; else b5f=~7'b000101_0; end
				16: begin if(dsisp_in) b5f=7'b001001_0; else b5f=~7'b001001_0; end
				17: begin if(dsisp_in) b5f=7'b110001_1; else b5f=7'b110001_0; end
				18: begin if(dsisp_in) b5f=7'b110001_1; else b5f=7'b110001_0; end
				19: begin if(dsisp_in) b5f=7'b010011_1; else b5f=7'b010011_0; end
				20: begin if(dsisp_in) b5f=7'b110100_1; else b5f=7'b110100_0; end
				21: begin if(dsisp_in) b5f=7'b010101_1; else b5f=7'b010101_0; end
				22: begin if(dsisp_in) b5f=7'b010110_1; else b5f=7'b010110_0; end
				23: begin if(dsisp_in) b5f=7'b101000_0; else b5f=~7'b101000_0; end
				24: begin if(dsisp_in) b5f=7'b001100_0; else b5f=~7'b001100_0; end
				25: begin if(dsisp_in) b5f=7'b011001_1; else b5f=~7'b011001_1; end
				26: begin if(dsisp_in) b5f=7'b011010_1; else b5f=7'b011010_0; end
				27: begin if(dsisp_in) b5f=7'b100100_0; else b5f=~7'b100100_0; end
				28: begin if(dsisp_in) b5f=7'b011100_1; else b5f=7'b011100_0; end
				29: begin if(dsisp_in) b5f=7'b100010_0; else b5f=~7'b100010_0; end
				30: begin if(dsisp_in) b5f=7'b100001_0; else b5f=~7'b100001_0; end
				31: begin if(dsisp_in) b5f=7'b001010_0; else b5f=~7'b001010_0; end
				endcase
				dsisp_in=b5f[0];
				en_state=db3;
				
			end
			if (en_state==db3) begin //db3
				`uvm_info("encod_db3",$sformatf("iam in bd3 %h , bi %b disp=%b",got_8b.si_data[7:5],got_8b.si_data[7:5],dsisp_in),UVM_MEDIUM)
				if(!got_8b.si_data[8])begin 
					case(got_8b.si_data[7:5])
						0:begin if(dsisp_in) b3f=5'b0010_0; else b3f=~5'b0010_0; end
						1:begin if(dsisp_in) b3f=5'b1001_1; else b3f=5'b1001_0; end
						2:begin if(dsisp_in) b3f=5'b1010_1; else b3f=5'b1010_0; end
						3:begin if(dsisp_in) b3f=5'b1100_1; else b3f=~5'b1100_1; end
						4:begin if(dsisp_in) b3f=5'b0100_0; else b3f=~5'b0100_0; end
						5:begin if(dsisp_in) b3f=5'b0101_1; else b3f=5'b0101_0; end
						6:begin if(dsisp_in) b3f=5'b0110_1; else b3f=5'b0110_0; end
						7:begin if(dsisp_in) b3f=5'b1000_0; else b3f=~5'b1000_0; end
					endcase
				end else begin
				//$display("i am on in db3 with %h",got_8b.si_data);
					case(got_8b.si_data[7:5])
						0:begin if(dsisp_in) b3f=5'b0010_0; else b3f=~5'b0010_0; end
						1:begin if(dsisp_in) b3f=5'b1001_1; else b3f=~5'b1001_1; end
						2:begin if(dsisp_in) b3f=5'b1010_1; else b3f=~5'b1010_1; end
						3:begin if(dsisp_in) b3f=5'b1100_1; else b3f=~5'b1100_1; end
						4:begin if(dsisp_in) b3f=5'b0100_0; else b3f=~5'b0100_0; end
						5:begin if(dsisp_in) b3f=5'b0101_1; else b3f=~5'b0101_1; end
						6:begin if(dsisp_in) b3f=5'b0110_1; else b3f=~5'b0110_1; end
						7:begin if(dsisp_in) b3f=5'b0001_0; else b3f=~5'b0001_0; end
					endcase
				end
				dsisp_in=b3f[0];
				en_state=out_write;
				//`uvm_info("end",$sformatf("i am movig to out_writing "),UVM_MEDIUM)
			end
			//out_write: 
			if (en_state==out_write)begin
				enc.enco={b3f[5:1],b5f[6:1]};
				enc.enco_start=in_st;
			`uvm_info("writign to fifo",$sformatf("encod 9:6 = %b  5:0=%b  start_out=%b %h disp=%b",enc.enco[9:6],enc.enco[5:0],enc.enco_start,enc.enco,dsisp_in),UVM_MEDIUM)
				b5_enco.write(enc);
				en_state=f_di;
			end
		//endcase
		//`uvm_info("end",$sformatf("i am delay"),UVM_MEDIUM)
	end
endtask :run_phase
endclass: sb_5b
