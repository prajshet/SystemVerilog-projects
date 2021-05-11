// input monitor for 8b10b 
class b8_mon_in extends uvm_monitor;
`uvm_component_utils(b8_mon_in)

virtual e2t_intf intf;

uvm_analysis_port #(in_data) in_po; // sending dat 
in_data id;  // tansaction class 

function new(string name = "b8_mon_in", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void connect_phase(uvm_phase phase);
if(uvm_config_db # (virtual e2t_intf)::get(null,"dut_conn", "my_dut_intf",intf));	
		else begin 
		`uvm_fatal("config", "did not got dut_conn intf")	
		end;
endfunction: connect_phase
 
function void build_phase(uvm_phase phase);
	in_po=new("in_data",this);
endfunction : build_phase

task run_phase(uvm_phase phase);
	forever @(posedge(intf.clk)) begin
		id=new();
		if(intf.pushin && !intf.reset) begin
			id.si_data = intf.datain;
			id.start_dis = intf.startin;
			in_po.write(id);
		end

	end
endtask:run_phase

endclass :b8_mon_in
