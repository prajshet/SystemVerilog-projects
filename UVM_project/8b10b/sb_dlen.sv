// scorebord dlen provide a i/p data length to anothe sb which collect the o/p data length 
class sb_dlen extends uvm_scoreboard ;
`uvm_component_utils(sb_dlen)

uvm_tlm_analysis_fifo # (in_data) m2sb_msg;
uvm_analysis_port #(int) in_dlen;

in_data got;	
int cnt;
function new(string name = "sb_dlen", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
	m2sb_msg=new("got_data",this);
	in_dlen=new("fifo_sb_dlen",this);	
endfunction :build_phase

task run_phase(uvm_phase phase);		
	forever begin
		m2sb_msg.get(got);	
		//`uvm_info("debug",$sformatf("si_data %h  start_dis %b ",got.si_data, got.start_dis),UVM_MEDIUM)
		if(got.si_data!=9'h13c) begin
			cnt=cnt+1;
			if(got.si_data==9'h1bc) begin
			//	`uvm_info("debug_sb_len",$sformatf("si_data dlen %d ",cnt-1),UVM_MEDIUM)			
				in_dlen.write(cnt-1);
				cnt=0;
			end
		end	
	end
endtask:run_phase
endclass: sb_dlen
