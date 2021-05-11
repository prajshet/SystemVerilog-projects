typedef enum bit [4:0]{reset,
			c0,
			c1,
			dat0,
			rdat,
			delay} D_typ;

class b8_seq_itm extends uvm_sequence_item;
`uvm_object_utils (b8_seq_itm)

D_typ typ;
rand bit [8:0] dat1[];
rand logic pdelay;
logic [2:0]dlen ;

	function new (string name = "b8_seq_itm" );//uvm_component parent=null is not need as we use object utilis
		super.new(name);
	endfunction:new
	
endclass:b8_seq_itm
