typedef enum {st,des} ct;
class sb_4inital extends uvm_scoreboard ;
`uvm_component_utils(sb_4inital)

uvm_tlm_analysis_fifo # (in_data) m2sb_msg;
ct count;
in_data got;
int cnt_sb4;
function new(string name = "sb_4inital", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
	m2sb_msg=new("got_data",this);
endfunction :build_phase

task run_phase(uvm_phase phase);
	count=st;
	forever begin
		m2sb_msg.get(got);
		case(count)
			st:  begin
				if(got.si_data==9'h13c && got.start_dis==1) begin cnt_sb4=cnt_sb4+1; count=des;  end
				else begin cnt_sb4=0; count=st; end
			end 
			des: begin
				if(got.si_data==9'h13c) begin cnt_sb4=cnt_sb4+1; count=des; end
				else begin
				 if(cnt_sb4 == 4) begin
				// `uvm_info("got_4x28",$sformatf("transmited %d 28.1",cnt_sb4),UVM_MEDIUM)
					cnt_sb4=0;
					count=st;
				 end else begin
					`uvm_error("got_4x28",$sformatf("transmited %d 28.1",cnt_sb4))
					cnt_sb4=0;
					count=st;
				 end
				end
			end
		endcase
	end
endtask:run_phase
endclass: sb_4inital
