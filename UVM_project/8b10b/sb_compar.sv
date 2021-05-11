class sb_compar extends uvm_scoreboard ;
`uvm_component_utils(sb_compar)

uvm_tlm_analysis_fifo # (out_data) dut_msg;
uvm_tlm_analysis_fifo # (en_data) my_msg;

out_data dut_en;
en_data my_en;	
logic[3:0] cnt_delay;
logic en;

function new(string name = "sb_compar", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
	dut_msg=new("dut_msg_n",this);
	my_msg=new("my_msg_n",this);	
endfunction :build_phase

task run_phase(uvm_phase phase);		
	en=0;
	forever begin
		dut_msg.get(dut_en);
		my_msg.get(my_en);
		
		if((dut_en.b10_data==10'h57 || dut_en.b10_data ==10'h3a8) &&(my_en.enco==10'h17c || my_en.enco ==10'h283)) begin
		 	cnt_delay=4; en=1; 	`uvm_info("end_compar",$sformatf("i am delay"),UVM_MEDIUM)
		end
		
		if(!en) begin
			if(dut_en.b10_data != my_en.enco)
					 `uvm_error("mismatch on o/p",$sformatf("expectd= %h    got=%h  ",my_en.enco,dut_en.b10_data)) 	
		end else begin
		 	cnt_delay=cnt_delay-1;
		 	`uvm_info("en_check",$sformatf("i am cnt=%d",cnt_delay),UVM_MEDIUM)
			`if(cnt_delay==0) en=0;
		end
			
end
endtask:run_phase
endclass: sb_compar
