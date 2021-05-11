typedef enum {cnt_rest,cnt_start, cnt_crc}cnt_status;
class sb_dlen_op extends uvm_scoreboard ;
`uvm_component_utils(sb_dlen_op)

uvm_tlm_analysis_fifo # (out_data) port_dlen_op;
uvm_analysis_port #(int) dlen_comp;

out_data got_op;	
int cnt_dl,cnt_crc_dl;
cnt_status status;

function new(string name = "sb_dlen_op", uvm_component parent= null);
	super.new(name,parent);
	status=cnt_rest;
endfunction:new

function void build_phase(uvm_phase phase);
	port_dlen_op=new("got_data",this);
	dlen_comp=new("fifo_sb_dlen_op",this);	
endfunction :build_phase

task run_phase(uvm_phase phase);		
	forever begin
		port_dlen_op.get(got_op);	
//		`uvm_info("debug",$sformatf("out_data %h  start_out %b ",got_op.b10_data, got_op.start_out),UVM_MEDIUM)
	case(status)
		cnt_rest:begin
			if(got_op.b10_data ==10'h27c ||got_op.b10_data ==10'h183 ) status=cnt_rest; 
			else begin 
				if(got_op.b10_data==10'h57||got_op.b10_data==10'h3a8 ) begin 
					status = cnt_crc;
					cnt_dl=0;
				//	`uvm_info("op_debug_sb_len",$sformatf("si_data dlen %d ",cnt_dl),UVM_MEDIUM)
					dlen_comp.write(cnt_dl);
				end	else begin 
					status=cnt_start;
					cnt_dl=cnt_dl+1;
				end
			end 
		end
			
		cnt_start:begin		
				if(got_op.b10_data==10'h57||got_op.b10_data==10'h3a8 ) begin ///23.7 57=00_0101_0111  /3a8=11_1010_1000			
					//if(cnt_dl >32) begin	
					//`uvm_fatal("got_dl_out",$sformatf("transmited %d lenght on output",cnt_dl))
				//	end	
					//$display("i am cnt fifo = %d ",cnt_dl);
				//	`uvm_info("op_debug_sb_len",$sformatf("si_data dlen %d ",cnt_dl),UVM_MEDIUM)
					dlen_comp.write(cnt_dl);
					cnt_dl=0;
					cnt_crc_dl=0;
					status=cnt_crc;
				end else begin
					cnt_dl=cnt_dl+1;
					status=cnt_start;
					//$display("i am cnt = %d for daata %h ",cnt_dl,got_op.b10_data);
				end
			end
		cnt_crc:begin
			//$display("i am cnt = %d ",cnt_dl);
			if(got_op.b10_data==10'h17c || got_op.b10_data ==10'h283 ) begin 
			//	$display("i am final cnt_crc = %d ",cnt_crc_dl);
				if(cnt_crc_dl !=4) `uvm_error("got_dl_CRC",$sformatf("transmited %d lenght crc output expected 4",cnt_crc_dl ));
				cnt_crc_dl=0;
				status=cnt_rest;
			end else begin
				cnt_crc_dl=cnt_crc_dl+1;
		///	$display("i am cnt_crc = %d ",cnt_crc_dl);
				status=cnt_crc;
				
			end
		end
	endcase
   end
endtask:run_phase
endclass: sb_dlen_op
