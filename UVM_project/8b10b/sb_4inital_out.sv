// sb_4initial_out check for 28.1 wihth -1 disparity and dut only sends 4 28.1 
typedef enum {str,dest} cte;
class sb_4inital_out extends uvm_scoreboard ;
`uvm_component_utils(sb_4inital_out)

uvm_tlm_analysis_fifo # (out_data) m2sb_4x281;
cte count;
out_data got;
int cnt_sb4;
function new(string name = "sb_4inital_out", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
	m2sb_4x281=new("got_data",this);
endfunction :build_phase

task run_phase(uvm_phase phase);
	count=str;
	forever begin
		m2sb_4x281.get(got);
		case(count)
			str:  begin
				if(got.start_out==1 && got.b10_data!=10'h27c ) begin
					`uvm_fatal("out_sb_4inital",$sformatf("transmited %b expected %b for 28.1",got.b10_data, 10'h27c)) // check for correct 10b for 28.1 
				end 
	
				if(got.b10_data==10'h27c && got.start_out==1) begin 
					cnt_sb4=cnt_sb4+1; count=dest;
				end	else begin cnt_sb4=0; count=str; end
			end 
			dest: begin
				if(got.b10_data==10'h27c || got.b10_data==10'h183) begin cnt_sb4=cnt_sb4+1; count=dest; end
				else begin
				 if(cnt_sb4 == 4) begin
				 //`uvm_info("got_4x28_out",$sformatf("transmited %d 28.1 output",cnt_sb4),UVM_MEDIUM)
					cnt_sb4=0;
					count=str;
				 end else begin
					`uvm_fatal("got_4x28_out",$sformatf("transmited %d 28.1 output",cnt_sb4))
					cnt_sb4=0;
					count=str;
				 end
				end
			end
		endcase
	end
endtask:run_phase
endclass: sb_4inital_out
//110000_0110//f9 
