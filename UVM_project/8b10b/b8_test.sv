//test class of 8b_10b encodeing tb 
class b8_test extends uvm_test;
`uvm_component_utils(b8_test)

b8_seq seq;
b8_env env;
	function new(string name = "b8_test", uvm_component parent= null);
		super.new(name,parent);
	endfunction:new

	function void build_phase( uvm_phase phase);
		env = b8_env::type_id::create("env",this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);

	endfunction: connect_phase

	task run_phase (uvm_phase phase);
	seq = b8_seq::type_id::create("seq",this);
		phase.raise_objection(this);
			seq.start(env.agent.seqr);
			#10000;
		phase.drop_objection(this);
	endtask: run_phase
endclass : b8_test
