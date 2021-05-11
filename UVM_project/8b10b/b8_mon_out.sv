class b8_mon_out extends uvm_monitor;
`uvm_component_utils(b8_mon_out)

virtual e2t_intf intf;
uvm_analysis_port #(out_data) out_po; // sending dat 
out_data op_data;  // output tansaction class 

function new(string name = "b8_mon_out", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void connect_phase(uvm_phase phase);
	if(uvm_config_db # (virtual e2t_intf)::get(null,"dut_conn", "my_dut_intf",intf));	
		else begin 
		`uvm_fatal("config", "did not got dut_conn intf")	
		end;
endfunction: connect_phase
 
function void build_phase(uvm_phase phase);
	out_po=new("out_data",this);
endfunction : build_phase

task run_phase(uvm_phase phase);
	forever @(posedge(intf.clk)) begin
		op_data=new();
		if(intf.pushout && !intf.reset) begin
			op_data.b10_data = intf.dataout;
			op_data.start_out = intf.startout;
		out_po.write(op_data);
		end
	end
endtask:run_phase
endclass :b8_mon_out
