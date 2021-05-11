// 8b10b driver
class b8_driver extends uvm_driver #(b8_seq_itm);
`uvm_component_utils(b8_driver)

b8_seq_itm itm;

virtual e2t_intf intf;
bit[1:0] cnt;
function new(string name = "b8_driver", uvm_component parent= null);
	super.new(name,parent);
	cnt = 0;
endfunction:new

function void connect_phase(uvm_phase phase);
if(uvm_config_db # (virtual e2t_intf)::get(null,"dut_conn", "my_dut_intf",intf));	
		else begin 
		`uvm_fatal("config", "did not got dut_conn intf")	
		end;
endfunction: connect_phase

task drv_reset();
		intf.reset=1;
		intf.pushin=0;
		intf.startin=0;
		intf.datain=0;
		@(posedge(intf.clk)) #1
		intf.reset=0;
endtask :drv_reset

task drv_c0();
		intf.reset=0;
		intf.pushin=1;
		intf.datain= {1'h1,8'h3c};
	
		intf.startin = (cnt == 0) ? 1 : 0;
		@(posedge(intf.clk)) #1;
		if(cnt==3) begin 
		cnt=0;
		intf.pushin=0;
		//intf.datain = 0;
		end
		else cnt = cnt+1;
		//$display("%d cnt \n ",cnt);
endtask :drv_c0

task drv_dat0();
		intf.reset=0;
		intf.startin=0;
		intf.datain=0;
		intf.pushin=1;
	@(posedge(intf.clk)) #1
		intf.pushin=0;
endtask :drv_dat0

task drv_dat(b8_seq_itm n);
		intf.reset=0;
		intf.startin=0;
		intf.pushin=1;
		//$display("my data lenght %d", n.dlen);
		for(int i=0; i<n.dlen; i=i+1)begin
		//$display("data no %d", i);
		//$display("dat1 = %d", n.dat1[i]);
			intf.datain=n.dat1[i];
			@(posedge(intf.clk)) #1 ;
		end
		#1 intf.pushin=0;
//		@(posedge(intf.clk));
endtask :drv_dat

task drv_c1();
		intf.reset=0;
		intf.startin=0;
		intf.datain= {1'h1,8'hbc};
		intf.pushin=1;
		@(posedge(intf.clk)) #1	intf.pushin=0; intf.datain=0;
endtask :drv_c1

task drv_delay();
		intf.reset=0;
		intf.startin=0;
		intf.datain=0;
		intf.pushin=0;
		@(posedge(intf.clk)) #1;
endtask :drv_delay

task run_phase (uvm_phase phase);
	forever begin
		//@(posedge (intf.clk));
      	seq_item_port.get_next_item(itm);
   //   	$display("Typ: %s", itm.typ.name());
		
      	case(itm.typ)
			reset: drv_reset();
			c0:drv_c0();
			dat0:drv_dat0();
			rdat:drv_dat(itm);
			c1:drv_c1();
			delay:drv_delay;
      	endcase 	
		seq_item_port.item_done();
	end
      	
endtask: run_phase

endclass : b8_driver
