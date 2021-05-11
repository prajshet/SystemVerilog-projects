// agent class for 8b10b encodieng holding driver sequencer.
class b8_agent extends uvm_agent;
`uvm_component_utils(b8_agent)

b8_seqr seqr;
b8_driver driver;
b8_mon_in monitor;
b8_mon_out monitor_out;

function new(string name = "b8_agent", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

	function void build_phase( uvm_phase phase);
		seqr = b8_seqr::type_id::create("seqr",this);
		driver = b8_driver::type_id::create("driver",this);
		monitor = b8_mon_in::type_id::create("monitor",this);
		monitor_out = b8_mon_out::type_id::create("monitor_out",this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		driver.seq_item_port.connect(seqr.seq_item_export);
	endfunction: connect_phase

endclass : b8_agent
