// dlen on input and output comparison s
class sb_io_dl extends uvm_scoreboard ;
`uvm_component_utils(sb_io_dl)

uvm_tlm_analysis_fifo # (int) m2sb_in_dl;
uvm_tlm_analysis_fifo # (int) m2sb_op_dl;

int in_dl,out_dl;
function new(string name = "sb_io_dl", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
	m2sb_in_dl=new("input_data_lenght",this);
	m2sb_op_dl=new("output_data_lenght",this);
endfunction :build_phase

task run_phase(uvm_phase phase);
forever begin
m2sb_in_dl.get(in_dl);
m2sb_op_dl.get(out_dl);
if(in_dl!==out_dl) `uvm_error("invlid dlen",$sformatf("transmited %d lenght on output for i/p ldlen=%d",out_dl,in_dl))
//else `uvm_info("valid_dlen",$sformatf("in_dlen %d get out_dlen=%d",in_dl,out_dl),UVM_MEDIUM)
end
endtask:run_phase


endclass: sb_io_dl
