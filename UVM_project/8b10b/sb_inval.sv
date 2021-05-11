// static check for invlaid values 
class sb_inval extends uvm_scoreboard ;
`uvm_component_utils(sb_inval)

uvm_tlm_analysis_fifo # (out_data) m2sb_val;
out_data val;
bit invalid,a,b;

function new(string name = "sb_inval", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
	m2sb_val=new("inval_data",this);
endfunction :build_phase
task msg_print (input logic [9:0] data_10b, input logic en );
			if(en) begin
			`uvm_error("invid o/p",$sformatf("transmited %b lenght on output",data_10b))
			end
endtask
task run_phase(uvm_phase phase);
	forever begin
			m2sb_val.get(val);
			a = 0;
			b = 0;
			 casex(val.b10_data)
				 10'b1000111100: a = 1;
				 10'b0111000011: a = 1;
				 10'b1110xxxxxx: a = 1;
				 10'b0001xxxxxx: a = 1;
				 10'bx11111xxxx: a = 1;
				 10'bx00000xxxx: a = 1;
			endcase
			
			casex(val.b10_data)
			10'b11101x0001: b =1;
			10'b11101x0010: b =1;
			10'b11101x0100: b =1;
			10'b1110101000: b =1;
			10'b1110000011: b =1;
			10'b00010x1110: b =1;
			10'b00010x1101: b =1;
			10'b00010x1011: b =1;
			10'b0001010111: b =1;
			10'b0001111100: b =1;
			endcase

			invalid = a & !b;
			if(invalid)
				msg_print(val.b10_data,invalid);
	end

endtask:run_phase

endclass: sb_inval
