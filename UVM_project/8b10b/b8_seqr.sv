// 8b10b sequencer  
class b8_seqr extends uvm_sequencer # (b8_seq_itm);
`uvm_component_utils(b8_seqr)

function new(string name = "b8_seqr", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

endclass : b8_seqr
